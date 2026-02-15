# Performance Optimization

Drizzle ORM has almost 0 overhead. To make it actual 0, use **prepared statements**.

## How Queries Work

1. Query builder concatenates all configurations to SQL string
2. String and params sent to database driver
3. Driver compiles SQL to binary executable format and sends to database

**With prepared statements:** SQL concatenation happens once, then database reuses precompiled binary SQL.

## Prepared Statements

### PostgreSQL

```typescript
const db = drizzle(...);

const prepared = db.select().from(customers).prepare("statement_name");

const res1 = await prepared.execute();
const res2 = await prepared.execute();
const res3 = await prepared.execute();
```

### MySQL

```typescript
const prepared = db.select().from(customers).prepare();

const res1 = await prepared.execute();
const res2 = await prepared.execute();
const res3 = await prepared.execute();
```

### SQLite

```typescript
const prepared = db.select().from(customers).prepare();

const res1 = prepared.all();
const res2 = prepared.all();
const res3 = prepared.all();
```

## Placeholders

Use `sql.placeholder()` for dynamic runtime values:

### PostgreSQL

```typescript
import { sql } from "drizzle-orm";

const p1 = db
  .select()
  .from(customers)
  .where(eq(customers.id, sql.placeholder('id')))
  .prepare("p1");

await p1.execute({ id: 10 });  // SELECT * FROM customers WHERE id = 10
await p1.execute({ id: 12 });  // SELECT * FROM customers WHERE id = 12

// With custom SQL
const p2 = db
  .select()
  .from(customers)
  .where(sql`lower(${customers.name}) like ${sql.placeholder('name')}`)
  .prepare("p2");

await p2.execute({ name: '%an%' });
```

### MySQL

```typescript
const p1 = db
  .select()
  .from(customers)
  .where(eq(customers.id, sql.placeholder('id')))
  .prepare();

await p1.execute({ id: 10 });
await p1.execute({ id: 12 });
```

### SQLite

```typescript
const p1 = db
  .select()
  .from(customers)
  .where(eq(customers.id, sql.placeholder('id')))
  .prepare();

p1.get({ id: 10 });
p1.get({ id: 12 });
```

## Serverless Performance

**Serverless functions** (AWS Lambda, Vercel) can live up to 15 minutes and reuse both database connections and prepared statements.

**Edge functions** clean up immediately after invocation, providing little to no performance benefits.

### Reuse Connections and Prepared Statements

```typescript
const databaseConnection = ...;
const db = drizzle({ client: databaseConnection });
const prepared = db.select().from(...).prepare();

// AWS handler
export const handler = async (event: APIGatewayProxyEvent) => {
  return prepared.execute();
}
```

## Query Optimization Tips

### 1. Use Prepared Statements for Repeated Queries

```typescript
// ✅ Good - reuse prepared statement
const getUserById = db
  .select()
  .from(users)
  .where(eq(users.id, sql.placeholder('id')))
  .prepare();

const user1 = await getUserById.execute({ id: 1 });
const user2 = await getUserById.execute({ id: 2 });

// ❌ Bad - rebuild SQL each time
const user1 = await db.select().from(users).where(eq(users.id, 1));
const user2 = await db.select().from(users).where(eq(users.id, 2));
```

### 2. Select Only Needed Columns

```typescript
// ✅ Good - select specific columns
await db.select({ id: users.id, name: users.name }).from(users);

// ❌ Bad - select all columns
await db.select().from(users);
```

### 3. Use Indexes Effectively

```typescript
// Schema with indexes
export const users = pgTable('users', {
  id: serial('id').primaryKey(),
  email: varchar('email', { length: 255 }).notNull().unique(),
  name: varchar('name', { length: 255 }).notNull(),
}, (table) => ({
  emailIdx: index('email_idx').on(table.email),
  nameIdx: index('name_idx').on(table.name),
}));
```

### 4. Batch Operations

```typescript
// ✅ Good - batch insert
await db.insert(users).values([
  { name: 'John', email: 'john@example.com' },
  { name: 'Jane', email: 'jane@example.com' },
  { name: 'Bob', email: 'bob@example.com' },
]);

// ❌ Bad - individual inserts
await db.insert(users).values({ name: 'John', email: 'john@example.com' });
await db.insert(users).values({ name: 'Jane', email: 'jane@example.com' });
await db.insert(users).values({ name: 'Bob', email: 'bob@example.com' });
```

### 5. Use Transactions for Multiple Operations

```typescript
await db.transaction(async (tx) => {
  await tx.insert(users).values({ name: 'John' });
  await tx.insert(posts).values({ title: 'Hello', userId: 1 });
});
```

### 6. Limit Result Sets

```typescript
// Always use pagination for large tables
const result = await db
  .select()
  .from(users)
  .limit(100)
  .offset(0);
```

## Performance Benchmarks

Different database drivers support prepared statements differently. Drizzle ORM can sometimes be **faster than better-sqlite3 driver** due to efficient prepared statement handling.

## Best Practices Summary

| Practice | Impact |
|----------|--------|
| Prepared statements | High - reduces SQL parsing overhead |
| Column selection | Medium - reduces data transfer |
| Indexes | High - speeds up queries |
| Batch operations | High - reduces round trips |
| Transactions | Medium - ensures consistency |
| Pagination | Critical - prevents memory issues |
| Connection reuse | High in serverless - reduces connection overhead |
