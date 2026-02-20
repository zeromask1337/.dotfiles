---
name: drizzle-orm
description: Modern TypeScript ORM for PostgreSQL, MySQL, SQLite. SQL-like syntax with type-safe queries. Use when working with database schemas, queries, migrations, or any Drizzle ORM tasks.
---

# Drizzle ORM

Drizzle is a modern TypeScript ORM that embraces SQL. It's lightweight (~7.4kb), tree-shakeable, with 0 dependencies, and supports PostgreSQL, MySQL, SQLite, and SingleStore.

## Quick Start

### 1. Install

```bash
npm i drizzle-orm
npm i -D drizzle-kit
```

### 2. Define Schema

**PostgreSQL:**
```typescript
import { pgTable, serial, varchar, integer, text, timestamp } from 'drizzle-orm/pg-core';

export const users = pgTable('users', {
  id: serial('id').primaryKey(),
  name: varchar('name', { length: 255 }).notNull(),
  email: varchar('email', { length: 255 }).notNull().unique(),
  age: integer('age'),
  createdAt: timestamp('created_at').defaultNow(),
});
```

**MySQL:**
```typescript
import { mysqlTable, serial, varchar, int } from 'drizzle-orm/mysql-core';

export const users = mysqlTable('users', {
  id: serial('id').primaryKey(),
  name: varchar('name', { length: 255 }).notNull(),
  age: int('age'),
});
```

**SQLite:**
```typescript
import { sqliteTable, integer, text } from 'drizzle-orm/sqlite-core';

export const users = sqliteTable('users', {
  id: integer('id', { mode: 'number' }).primaryKey({ autoIncrement: true }),
  name: text('name').notNull(),
  email: text('email').notNull(),
});
```

### 3. Connect

```typescript
import { drizzle } from 'drizzle-orm/node-postgres';
import { Pool } from 'pg';

const pool = new Pool({ connectionString: process.env.DATABASE_URL });
const db = drizzle({ client: pool });
```

### 4. Query

```typescript
// Select all
const allUsers = await db.select().from(users);

// Select with where
const user = await db.select().from(users).where(eq(users.id, 1));

// Insert
await db.insert(users).values({ name: 'John', email: 'john@example.com' });

// Update
await db.update(users).set({ name: 'Jane' }).where(eq(users.id, 1));

// Delete
await db.delete(users).where(eq(users.id, 1));
```

## Core Concepts

### Schema Declaration

Drizzle uses a code-first approach. Import the appropriate core package for your database:

- PostgreSQL: `drizzle-orm/pg-core`
- MySQL: `drizzle-orm/mysql-core`
- SQLite: `drizzle-orm/sqlite-core`

Common column types:
- `serial()` / `integer()` / `bigint()` - Auto-incrementing IDs
- `varchar({ length })` / `text()` / `char()` - String types
- `integer()` / `smallint()` / `real()` / `doublePrecision()` - Numeric
- `boolean()` - Boolean
- `timestamp()` / `date()` / `time()` - Date/time
- `json()` / `jsonb()` - JSON (PostgreSQL)
- `uuid()` - UUID

Column modifiers:
- `.notNull()` - Non-nullable
- `.default(value)` - Default value
- `.primaryKey()` - Primary key
- `.unique()` - Unique constraint
- `.references(() => table.column)` - Foreign key

### Relations

```typescript
import { relations } from 'drizzle-orm';

export const usersRelations = relations(users, ({ many, one }) => ({
  posts: many(posts),
  profile: one(profiles, {
    fields: [users.id],
    references: [profiles.userId],
  }),
}));

export const posts = pgTable('posts', {
  id: serial('id').primaryKey(),
  title: varchar('title', { length: 255 }).notNull(),
  userId: integer('user_id').notNull().references(() => users.id),
});

export const postsRelations = relations(posts, ({ one }) => ({
  user: one(users, {
    fields: [posts.userId],
    references: [users.id],
  }),
}));
```

### Query Patterns

**SQL-like queries:**
```typescript
import { eq, and, or, gt, like, desc, count } from 'drizzle-orm';

// Basic select
await db.select().from(users);

// With where
await db.select().from(users).where(eq(users.id, 1));

// Multiple conditions
await db.select().from(users).where(and(eq(users.age, 25), eq(users.name, 'John')));

// OR conditions
await db.select().from(users).where(or(eq(users.age, 25), eq(users.age, 30)));

// Like/ILIKE
await db.select().from(users).where(like(users.name, '%John%'));

// Order by
await db.select().from(users).orderBy(desc(users.createdAt));

// Limit/Offset
await db.select().from(users).limit(10).offset(20);

// Joins
await db
  .select()
  .from(users)
  .leftJoin(posts, eq(users.id, posts.userId))
  .where(eq(users.id, 1));

// Aggregation
await db.select({ count: count() }).from(users);
```

**Relational queries (auto-joins):**
```typescript
const result = await db.query.users.findMany({
  with: {
    posts: true,
    profile: true,
  },
});
```

### Migrations with Drizzle Kit

**drizzle.config.ts:**
```typescript
import { defineConfig } from 'drizzle-kit';

export default defineConfig({
  dialect: 'postgresql', // or 'mysql', 'sqlite'
  schema: './src/schema.ts',
  out: './drizzle',
  dbCredentials: {
    url: process.env.DATABASE_URL!,
  },
});
```

**CLI commands:**
```bash
# Generate migration
npx drizzle-kit generate

# Push schema changes (dev)
npx drizzle-kit push

# Pull schema from existing DB
npx drizzle-kit pull

# Run migrations
npx drizzle-kit migrate

# Open Drizzle Studio (visual editor)
npx drizzle-kit studio
```

## Database Drivers

| Database | Driver | Import |
|----------|--------|--------|
| PostgreSQL | node-postgres | `drizzle-orm/node-postgres` |
| PostgreSQL | neon | `drizzle-orm/neon` |
| PostgreSQL | postgres.js | `drizzle-orm/postgres-js` |
| PostgreSQL | pg-lite | `drizzle-orm/pglite` |
| MySQL | mysql2 | `drizzle-orm/mysql2` |
| MySQL | PlanetScale | `drizzle-orm/planetscale` |
| SQLite | better-sqlite3 | `drizzle-orm/better-sqlite3` |
| SQLite | libsql (Turso) | `drizzle-orm/libsql` |
| SQLite | bun:sqlite | `drizzle-orm/bun-sqlite` |

## References

- Detailed schema options: @references/schema.md
- Query patterns: @references/queries.md
- Migration workflows: @references/migrations.md
- Database connection examples: @references/connections.md
