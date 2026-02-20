# Magical SQL Operator 🪄

The `sql` template operator provides a type-safe way to write raw SQL within Drizzle ORM queries.

## Basic Usage

### SQL Template Literal

```typescript
import { sql } from 'drizzle-orm';

const id = 69;
await db.execute(sql`select * from ${usersTable} where ${usersTable.id} = ${id}`);
```

```sql
SELECT * FROM "users" WHERE "users"."id" = $1;  -- [69]
```

**Features:**
- Tables/columns auto-escaped with proper SQL syntax
- Parameters mapped to placeholders ($1, $2, etc.)
- Automatic SQL injection protection

## Type Safety

### sql<T> - Explicit Types

Define return types for proper inference:

```typescript
// Without type - returns unknown
const result = await db.select({
  lowerName: sql`lower(${usersTable.name})`
}).from(usersTable);
// result: { lowerName: unknown }[]

// With type - returns string
const result = await db.select({
  lowerName: sql<string>`lower(${usersTable.name})`
}).from(usersTable);
// result: { lowerName: string }[]
```

### sql``.mapWith() - Runtime Mapping

Map database driver values to TypeScript:

```typescript
// Replicate column mapping
sql`...`.mapWith(usersTable.name);  // Maps same as 'text' column

// Custom mapping
sql`...`.mapWith({
  mapFromDriverValue: (value: any) => {
    // Custom transformation
    return value;
  },
});

// Simple type conversion
sql`count(*)`.mapWith(Number);
```

### sql``.as() - Aliases

Explicit column aliases for complex queries:

```typescript
sql`lower(${usersTable.name})`.as('lower_name')
```

```sql
... "usersTable"."name" as lower_name ...
```

## Raw SQL

### sql.raw()

Include unescaped, unparameterized SQL:

```typescript
// Raw string (no parameterization)
sql.raw(`select * from users where id = ${12}`);
// → select * from users where id = 12;

// Within sql template
sql`select * from ${usersTable} where id = ${sql.raw(12)}`;
// → select * from "users" where id = 12;
```

**Warning:** Be careful with `sql.raw()` to avoid SQL injection. Only use with trusted input.

## SQL Composition

### sql.fromList()

Combine multiple SQL chunks:

```typescript
const sqlChunks: SQL[] = [];

sqlChunks.push(sql`select * from users`);
sqlChunks.push(sql` where `);

for (let i = 0; i < 5; i++) {
  sqlChunks.push(sql`id = ${i}`);
  if (i === 4) continue;
  sqlChunks.push(sql` or `);
}

const finalSql: SQL = sql.fromList(sqlChunks);
```

```sql
select * from users where id = $1 or id = $2 or id = $3 or id = $4 or id = $5;
-- [0, 1, 2, 3, 4]
```

### sql.join()

Join SQL chunks with custom separators:

```typescript
const sqlChunks: SQL[] = [
  sql`select * from users`,
  sql`where`,
  sql`active = true`,
  sql`created_at > ${date}`,
];

const finalSql = sql.join(sqlChunks, sql.raw(' AND '));
```

```sql
select * from users where AND active = true AND created_at > $1
```

### sql.append()

Build SQL incrementally:

```typescript
const finalSql = sql`select * from users`;

finalSql.append(sql` where `);

for (let i = 0; i < 5; i++) {
  finalSql.append(sql`id = ${i}`);
  if (i === 4) continue;
  finalSql.append(sql` or `);
}
```

### sql.empty()

Start with blank SQL and build dynamically:

```typescript
const finalSql = sql.empty();

finalSql.append(sql`select * from users`);
finalSql.append(sql` where `);
finalSql.append(sql`active = true`);
```

## SQL in Query Clauses

### SELECT with sql

```typescript
await db.select({
  id: usersTable.id,
  lowerName: sql<string>`lower(${usersTable.name})`,
  aliasedName: sql<string>`lower(${usersTable.name})`.as('aliased_column'),
  count: sql<number>`count(*)`.mapWith(Number)
}).from(usersTable);
```

```sql
select "id", lower("name"), lower("name") as "aliased_column", count(*) from "users";
```

### WHERE with sql

```typescript
const id = 77;
await db.select()
  .from(usersTable)
  .where(sql`${usersTable.id} = ${id}`);
```

```sql
select * from "users" where "users"."id" = $1;  -- [77]
```

**Full-text search:**

```typescript
const searchParam = "Ale";

await db.select()
  .from(usersTable)
  .where(sql`to_tsvector('simple', ${usersTable.name}) @@ to_tsquery('simple', ${searchParam})`);
```

```sql
select * from "users" where to_tsvector('simple', "users"."name") @@ to_tsquery('simple', '$1');
-- ["Ale"]
```

### ORDER BY with sql

```typescript
await db.select()
  .from(usersTable)
  .orderBy(sql`${usersTable.id} desc nulls first`);
```

```sql
select * from "users" order by "users"."id" desc nulls first;
```

### GROUP BY / HAVING with sql

```typescript
await db.select({
  projectId: usersTable.projectId,
  count: sql<number>`count(${usersTable.id})`.mapWith(Number)
}).from(usersTable)
  .groupBy(sql`${usersTable.projectId}`)
  .having(sql`count(${usersTable.id}) > 300`);
```

```sql
select "project_id", count("users"."id") from users 
group by "users"."project_id" 
having count("users"."id") > 300;
```

## Converting SQL to String

### Using Database Dialects

Convert SQL templates to query strings with parameters:

**PostgreSQL:**
```typescript
import { PgDialect } from 'drizzle-orm/pg-core';

const pgDialect = new PgDialect();
pgDialect.sqlToQuery(sql`select * from ${usersTable} where ${usersTable.id} = ${12}`);
// → { sql: 'select * from "users" where "users"."id" = $1', params: [12] }
```

**MySQL:**
```typescript
import { MySqlDialect } from 'drizzle-orm/mysql-core';

const mysqlDialect = new MySqlDialect();
mysqlDialect.sqlToQuery(sql`select * from ${usersTable} where ${usersTable.id} = ${12}`);
// → { sql: 'select * from `users` where `users`.`id` = ?', params: [12] }
```

**SQLite:**
```typescript
import { SQLiteSyncDialect } from 'drizzle-orm/sqlite-core';

const sqliteDialect = new SQLiteSyncDialect();
sqliteDialect.sqlToQuery(sql`select * from ${usersTable} where ${usersTable.id} = ${12}`);
// → { sql: 'select * from "users" where "users"."id" = ?', params: [12] }
```

## Practical Examples

### Dynamic Date Filtering

```typescript
const startDate = new Date('2024-01-01');
const endDate = new Date('2024-12-31');

await db.select()
  .from(orders)
  .where(sql`${orders.createdAt} BETWEEN ${startDate} AND ${endDate}`);
```

### JSON Operations

```typescript
// PostgreSQL JSONB query
await db.select()
  .from(users)
  .where(sql`${users.preferences}->>'theme' = ${'dark'}`);

// MySQL JSON query
await db.select()
  .from(users)
  .where(sql`JSON_EXTRACT(${users.preferences}, '$.theme') = ${'dark'}`);
```

### Geometric Queries

```typescript
// PostgreSQL PostGIS
await db.select()
  .from(locations)
  .where(sql`ST_DWithin(
    ${locations.coordinates},
    ST_SetSRID(ST_MakePoint(${lng}, ${lat}), 4326),
    ${radius}
  )`);
```

### Full-Text Search with Ranking

```typescript
await db.select({
  id: articles.id,
  title: articles.title,
  rank: sql<number>`ts_rank(to_tsvector('english', ${articles.content}), plainto_tsquery('english', ${searchTerm}))`.as('rank')
}).from(articles)
  .where(sql`to_tsvector('english', ${articles.content}) @@ plainto_tsquery('english', ${searchTerm})`)
  .orderBy(sql`rank DESC`);
```

### Window Functions

```typescript
await db.select({
  id: sales.id,
  amount: sales.amount,
  runningTotal: sql<number>`sum(${sales.amount}) OVER (ORDER BY ${sales.date})`.as('running_total'),
  rank: sql<number>`rank() OVER (ORDER BY ${sales.amount} DESC)`.as('rank')
}).from(sales);
```

### Custom Aggregations

```typescript
// String aggregation (PostgreSQL)
await db.select({
  category: products.category,
  productNames: sql<string>`string_agg(${products.name}, ', ')`.as('product_names')
}).from(products)
  .groupBy(products.category);

// Custom count with conditions
await db.select({
  totalOrders: sql<number>`count(*) FILTER (WHERE ${orders.status} = 'completed')`.as('total_orders')
}).from(orders);
```

### Recursive CTEs

```typescript
const recursiveCte = db.$with('tree', { recursive: true }).as(
  db.select({ 
    id: categories.id, 
    name: categories.name, 
    depth: sql<number>`1`.as('depth')
  })
    .from(categories)
    .where(isNull(categories.parentId))
    .unionAll(
      db.select({
        id: categories.id,
        name: categories.name,
        depth: sql`${recursiveCte.depth} + 1`,
      })
        .from(categories)
        .innerJoin(recursiveCte, eq(categories.parentId, recursiveCte.id))
    )
);
```

### Upsert with Conflict Resolution

```typescript
// PostgreSQL
await db.insert(users)
  .values({ id: 1, name: 'John', email: 'john@example.com' })
  .onConflictDoUpdate({
    target: users.id,
    set: {
      name: sql`excluded.name`,
      updatedAt: sql`now()`,
    },
  });
```

### Batch Updates with CASE

```typescript
// Update many rows with different values
await db.update(users)
  .set({
    status: sql`CASE 
      WHEN ${users.id} = ${1} THEN ${'active'}
      WHEN ${users.id} = ${2} THEN ${'pending'}
      ELSE ${users.status}
    END`,
  })
  .where(inArray(users.id, [1, 2, 3]));
```

## Best Practices

### 1. Always Type sql<> Expressions

```typescript
// ✅ Good
sql<string>`lower(${users.name})`
sql<number>`count(*)`
sql<Date>`now()`

// ❌ Bad - returns unknown
sql`lower(${users.name})`
```

### 2. Use mapWith for Driver Values

```typescript
// ✅ Good - explicit mapping
sql`count(*)`.mapWith(Number)
sql`max(created_at)`.mapWith(usersTable.createdAt)

// ❌ Bad - may not map correctly
sql`count(*)`
```

### 3. Avoid sql.raw() with User Input

```typescript
// ❌ Dangerous - SQL injection risk
sql.raw(`select * from users where name = '${userInput}'`);

// ✅ Safe - parameterized
sql`select * from ${users} where ${users.name} = ${userInput}`;
```

### 4. Use sql.fromList for Dynamic Queries

```typescript
// ✅ Good - maintain type safety
const conditions: SQL[] = [];
if (name) conditions.push(sql`${users.name} = ${name}`);
if (email) conditions.push(sql`${users.email} = ${email}`);

const whereClause = conditions.length > 0 
  ? sql`where ${sql.join(conditions, sql.raw(' AND '))}`
  : sql``;
```

### 5. Convert to Query for Debugging

```typescript
import { PgDialect } from 'drizzle-orm/pg-core';

const dialect = new PgDialect();
const query = dialect.sqlToQuery(sql`...`);
console.log('SQL:', query.sql);
console.log('Params:', query.params);
```
