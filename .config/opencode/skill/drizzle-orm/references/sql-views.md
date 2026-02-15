# Views and Sequences Reference

## Views

Views are virtual tables based on the result of a SQL query. Supported by PostgreSQL, MySQL, SQLite, MSSQL, and CockroachDB.

### Declaring Views

Views can be declared with inline query builder, standalone query builder, or raw SQL.

**PostgreSQL:**
```typescript
import { pgTable, pgView, serial, text, timestamp } from "drizzle-orm/pg-core";

export const user = pgTable("user", {
  id: serial(),
  name: text(),
  email: text(),
  password: text(),
  role: text().$type<"admin" | "customer">(),
  createdAt: timestamp("created_at"),
  updatedAt: timestamp("updated_at"),
});

// Simple view
export const userView = pgView("user_view").as((qb) => 
  qb.select().from(user)
);

// Filtered view
export const customersView = pgView("customers_view").as((qb) => 
  qb.select().from(user).where(eq(user.role, "customer"))
);
```

```sql
CREATE VIEW "user_view" AS SELECT * FROM "user";
CREATE VIEW "customers_view" AS SELECT * FROM "user" WHERE "role" = 'customer';
```

**MySQL:**
```typescript
import { mysqlTable, mysqlView, int, text, timestamp } from "drizzle-orm/mysql-core";

export const user = mysqlTable("user", {
  id: int().primaryKey().autoincrement(),
  name: text(),
  email: text(),
  role: text().$type<"admin" | "customer">(),
  createdAt: timestamp("created_at"),
});

export const userView = mysqlView("user_view").as((qb) => 
  qb.select().from(user)
);
```

**SQLite:**
```typescript
import { sqliteTable, sqliteView, integer, text } from "drizzle-orm/sqlite-core";

export const user = sqliteTable("user", {
  id: integer().primaryKey({ autoIncrement: true }),
  name: text(),
  email: text(),
  role: text().$type<"admin" | "customer">(),
});

export const userView = sqliteView("user_view").as((qb) => 
  qb.select().from(user)
);
```

**MSSQL:**
```typescript
import { mssqlTable, mssqlView, int, text, timestamp } from "drizzle-orm/mssql-core";

export const user = mssqlTable("user", {
  id: int(),
  name: text(),
  email: text(),
  role: text().$type<"admin" | "customer">(),
  createdAt: timestamp("created_at"),
});

export const userView = mssqlView("user_view").as((qb) => 
  qb.select().from(user)
);
```

### Column Selection in Views

Select specific columns:

```typescript
export const customersView = mssqlView("customers_view").as((qb) => {
  return qb
    .select({
      id: user.id,
      name: user.name,
      email: user.email,
    })
    .from(user)
    .where(eq(user.role, "customer"));
});
```

```sql
CREATE VIEW [customers_view] AS (
  SELECT "id", "name", "email" FROM "user" WHERE "role" = 'customer'
);
```

### Standalone Query Builder

Use standalone query builder for complex views:

```typescript
import { pgView, QueryBuilder } from "drizzle-orm/pg-core";

const qb = new QueryBuilder();

export const userView = pgView("user_view").as(qb.select().from(user));
export const customersView = pgView("customers_view").as(
  qb.select().from(user).where(eq(user.role, "customer"))
);
```

### Views with Raw SQL

For complex SQL not supported by query builder:

```typescript
const newYorkers = pgView('new_yorkers', {
  id: serial('id').primaryKey(),
  name: text('name').notNull(),
  cityId: integer('city_id').notNull(),
}).as(sql`select * from ${users} where ${eq(users.cityId, 1)}`);
```

**Note:** When using raw SQL, you must explicitly declare view columns schema.

### Existing Views

For read-only access to existing database views:

```typescript
export const trimmedUser = pgView("trimmed_user", {
  id: serial("id"),
  name: text("name"),
  email: text("email"),
}).existing();
```

Drizzle Kit will ignore `.existing()` views and won't generate `CREATE VIEW` statements.

## Materialized Views

**Supported:** PostgreSQL, CockroachDB

Materialized views persist query results as actual tables, providing faster access at the cost of stale data.

### Declaring Materialized Views

```typescript
import { pgMaterializedView } from "drizzle-orm/pg-core";

const newYorkers = pgMaterializedView('new_yorkers').as((qb) => 
  qb.select().from(users).where(eq(users.cityId, 1))
);
```

```sql
CREATE MATERIALIZED VIEW "new_yorkers" AS SELECT * FROM "users";
```

### Refreshing Materialized Views

```typescript
// Simple refresh
await db.refreshMaterializedView(newYorkers);

// Concurrent refresh (doesn't block reads)
await db.refreshMaterializedView(newYorkers).concurrently();

// Refresh without data (just updates metadata)
await db.refreshMaterializedView(newYorkers).withNoData();
```

### Materialized Views with Raw SQL

```typescript
const newYorkers = pgMaterializedView('new_yorkers', {
  id: serial('id').primaryKey(),
  name: text('name').notNull(),
  cityId: integer('city_id').notNull(),
}).as(sql`select * from ${users} where ${eq(users.cityId, 1)}`);
```

### Existing Materialized Views

```typescript
export const trimmedUser = pgMaterializedView("trimmed_user", {
  id: serial("id"),
  name: text("name"),
  email: text("email"),
}).existing();
```

## Advanced View Options

### PostgreSQL Extended Example

```typescript
// Regular view with CTEs and options
const newYorkers = pgView('new_yorkers')
  .with({
    checkOption: 'cascaded',
    securityBarrier: true,
    securityInvoker: true,
  })
  .as((qb) => {
    const sq = qb
      .$with('sq')
      .as(
        qb.select({ userId: users.id, cityId: cities.id })
          .from(users)
          .leftJoin(cities, eq(cities.id, users.homeCity))
          .where(sql`${users.age1} > 18`),
      );
    return qb.with(sq).select().from(sq).where(sql`${users.homeCity} = 1`);
  });

// Materialized view with storage options
const newYorkers2 = pgMaterializedView('new_yorkers')
  .using('btree')
  .with({
    fillfactor: 90,
    toast_tuple_target: 0.5,
    autovacuum_enabled: true,
  })
  .tablespace('custom_tablespace')
  .withNoData()
  .as((qb) => {
    const sq = qb
      .$with('sq')
      .as(
        qb.select({ userId: users.id, cityId: cities.id })
          .from(users)
          .leftJoin(cities, eq(cities.id, users.homeCity))
          .where(sql`${users.age1} > 18`),
      );
    return qb.with(sq).select().from(sq).where(sql`${users.homeCity} = 1`);
  });
```

**Note:** All parameters inside the query are inlined instead of using placeholders.

## Database Support

| Feature | PostgreSQL | MySQL | SQLite | SingleStore | MSSQL | CockroachDB |
|---------|-----------|-------|---------|-------------|-------|-------------|
| Regular Views | ✅ | ✅ | ✅ | ❌ | ✅ | ✅ |
| Materialized Views | ✅ | ❌ | ❌ | ❌ | ❌ | ✅ |

## Sequences

**Supported:** PostgreSQL, CockroachDB

Sequences generate unique sequential values, commonly used for auto-incrementing primary keys.

### Basic Sequence

```typescript
import { pgSequence } from "drizzle-orm/pg-core";

// Simple sequence
export const customSequence = pgSequence("name");
```

### Sequence with Parameters

```typescript
export const customSequence = pgSequence("name", {
  startWith: 100,
  maxValue: 10000,
  minValue: 100,
  cycle: true,
  cache: 10,
  increment: 2
});
```

### Sequence in Custom Schema

```typescript
import { pgSchema } from "drizzle-orm/pg-core";

export const customSchema = pgSchema('custom_schema');
export const customSequence = customSchema.sequence("name");
```

### CockroachDB Sequences

```typescript
import { cockroachSequence, cockroachSchema } from "drizzle-orm/cockroach-core";

// Simple sequence
export const customSequence = cockroachSequence("name");

// With parameters
export const customSequence = cockroachSequence("name", {
  startWith: 100,
  maxValue: 10000,
  minValue: 100,
  cycle: true,
  cache: 10,
  increment: 2
});

// In custom schema
export const customSchema = cockroachSchema('custom_schema');
export const customSequence = customSchema.sequence("name");
```

## Practical Examples

### View for Active Users

```typescript
export const activeUsersView = pgView("active_users").as((qb) =>
  qb.select({
    id: users.id,
    name: users.name,
    email: users.email,
    lastLogin: users.lastLogin,
  })
  .from(users)
  .where(and(
    eq(users.active, true),
    gte(users.lastLogin, sql`now() - interval '30 days'`)
  ))
);
```

### Materialized View for Analytics

```typescript
export const dailyStats = pgMaterializedView("daily_stats").as((qb) =>
  qb.select({
    date: sql<string>`date_trunc('day', ${orders.createdAt})`.as('date'),
    totalOrders: sql<number>`count(*)`.as('total_orders'),
    totalRevenue: sql<number>`sum(${orders.amount})`.as('total_revenue'),
  })
  .from(orders)
  .groupBy(sql`date_trunc('day', ${orders.createdAt})`)
);

// Refresh in a cron job
await db.refreshMaterializedView(dailyStats).concurrently();
```

### Sequence for Custom ID Generation

```typescript
export const orderSequence = pgSequence("order_seq", {
  startWith: 1000,
  increment: 1,
  minValue: 1000,
  maxValue: 999999,
  cycle: false,
  cache: 20,
});

// Use in table
export const orders = pgTable("orders", {
  id: text("id").primaryKey().default(sql`nextval('order_seq')`),
  // ... other columns
});
```
