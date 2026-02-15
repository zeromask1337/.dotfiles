# Zod Schema Validation

Generate [Zod](https://zod.dev/) schemas from Drizzle ORM schemas for type-safe validation.

**Features:**
- Create select schemas for tables, views, and enums
- Create insert and update schemas for tables
- Supports all dialects: PostgreSQL, MySQL, SQLite, SingleStore, MSSQL, CockroachDB

## Installation

```bash
npm i drizzle-orm zod
```

## Usage

### Select Schema

Validates data queried from the database (API responses):

```typescript
import { pgTable, text, integer } from 'drizzle-orm/pg-core';
import { createSelectSchema } from 'drizzle-orm/zod';

const users = pgTable('users', {
  id: integer().generatedAlwaysAsIdentity().primaryKey(),
  name: text().notNull(),
  age: integer().notNull()
});

const userSelectSchema = createSelectSchema(users);

// Validate query result
const rows = await db.select().from(users).limit(1);
const parsed = userSelectSchema.parse(rows[0]);
```

### Insert Schema

Validates data to be inserted (API requests):

```typescript
import { createInsertSchema } from 'drizzle-orm/zod';

const userInsertSchema = createInsertSchema(users);

const user = { name: 'Jane', age: 30 };
const parsed = userInsertSchema.parse(user); // Excludes generated id
await db.insert(users).values(parsed);
```

### Update Schema

Validates data for updates:

```typescript
import { createUpdateSchema } from 'drizzle-orm/zod';

const userUpdateSchema = createUpdateSchema(users);

const update = { age: 35 };
const parsed = userUpdateSchema.parse(update); // All fields optional, excludes generated id
await db.update(users).set(parsed).where(eq(users.id, 1));
```

### Views and Enums

```typescript
import { pgEnum, pgView } from 'drizzle-orm/pg-core';

// Enums
const roles = pgEnum('roles', ['admin', 'basic']);
const rolesSchema = createSelectSchema(roles);

// Views
const usersView = pgView('users_view').as((qb) => 
  qb.select().from(users).where(gt(users.age, 18))
);
const usersViewSchema = createSelectSchema(usersView);
```

## Refinements

Extend or override field schemas:

```typescript
import { z } from 'zod/v4';

const userSelectSchema = createSelectSchema(users, {
  name: (schema) => schema.max(20),           // Extend: add max length
  bio: (schema) => schema.max(1000),        // Extend before nullable
  preferences: z.object({ theme: z.string() }) // Override: replace entire schema
});
```

## Factory Functions

For advanced use cases with custom Zod instances:

### Extended Zod Instance

```typescript
import { createSchemaFactory } from 'drizzle-orm/zod';
import { z } from '@hono/zod-openapi'; // Extended Zod with OpenAPI

const { createInsertSchema } = createSchemaFactory({ zodInstance: z });

const userInsertSchema = createInsertSchema(users, {
  name: (schema) => schema.openapi({ example: 'John' })
});
```

### Type Coercion

Automatically coerce types (e.g., string dates to Date objects):

```typescript
import { createSchemaFactory } from 'drizzle-orm/zod';

const { createInsertSchema } = createSchemaFactory({
  coerce: {
    date: true  // Only coerce dates
    // coerce: true  // Coerce all types
  }
});

// With coercion, createdAt becomes z.coerce.date()
const userInsertSchema = createInsertSchema(users);
```

## Data Type Mapping Reference

| Drizzle Type | Zod Schema |
|--------------|-----------|
| `boolean()` | `z.boolean()` |
| `date()` / `timestamp()` (mode: date) | `z.date()` |
| `date()` / `timestamp()` (mode: string) | `z.string()` |
| `text()`, `varchar()`, `char()` | `z.string()` |
| `varchar({ length })`, `char({ length })` | `z.string().length(length)` |
| `varchar({ length })` (max) | `z.string().max(length)` |
| `text({ enum })` | `z.enum(enum)` |
| `uuid()` | `z.string().uuid()` |
| `bit({ dimensions })` | `z.string().regex(/^[01]+$/).max(dimensions)` |
| `integer()`, `serial()` | `z.number().int()` |
| `smallint()` | `z.number().min(-32768).max(32767).int()` |
| `bigint({ mode: 'number' })` | `z.number().min(-9007199254740991).max(9007199254740991).int()` |
| `bigint({ mode: 'bigint' })` | `z.bigint().min(-9223372036854775808n).max(9223372036854775807n)` |
| `real()`, `float()` | `z.number()` |
| `doublePrecision()` | `z.number()` |
| `json()`, `jsonb()` | `z.union([z.string(), z.number(), z.boolean(), z.null(), z.array(z.any()), z.record(z.string(), z.any())])` |
| `point({ mode: 'tuple' })` | `z.tuple([z.number(), z.number()])` |
| `point({ mode: 'xy' })` | `z.object({ x: z.number(), y: z.number() })` |
| `vector({ dimensions })` | `z.array(z.number()).length(dimensions)` |
| `line({ mode: 'abc' })` | `z.object({ a: z.number(), b: z.number(), c: z.number() })` |
| `line({ mode: 'tuple' })` | `z.tuple([z.number(), z.number(), z.number()])` |

### MySQL-Specific Types

| Drizzle Type | Zod Schema |
|--------------|-----------|
| `tinyint()` | `z.number().min(-128).max(127).int()` |
| `tinyint({ unsigned: true })` | `z.number().min(0).max(255).int()` |
| `smallint({ unsigned: true })` | `z.number().min(0).max(65535).int()` |
| `mediumint()` | `z.number().min(-8388608).max(8388607).int()` |
| `int({ unsigned: true })` | `z.number().min(0).max(4294967295).int()` |
| `tinytext()` | `z.string().max(255)` |
| `text()` | `z.string().max(65535)` |
| `mediumtext()` | `z.string().max(16777215)` |
| `longtext()` | `z.string().max(4294967295)` |
| `year()` | `z.number().min(1901).max(2155).int()` |
| `serial` | `z.number().min(0).max(9007199254740991).int()` |

### String Length Limits by MySQL Type

```typescript
// tinytext: 255 bytes (unsigned 8-bit limit)
pipe(string(), maxLength(255))

// text: 65535 bytes (unsigned 16-bit limit)
pipe(string(), maxLength(65_535))

// mediumtext: 16MB (unsigned 24-bit limit)
pipe(string(), maxLength(16_777_215))

// longtext: 4GB (unsigned 32-bit limit)
pipe(string(), maxLength(4_294_967_295))
```

## Practical Examples

### API Route Validation

```typescript
import { Hono } from 'hono';
import { zValidator } from '@hono/zod-validator';

const app = new Hono();

const insertSchema = createInsertSchema(users);
const selectSchema = createSelectSchema(users);

app.post('/users', zValidator('json', insertSchema), async (c) => {
  const data = c.req.valid('json');
  const result = await db.insert(users).values(data).returning();
  return c.json(selectSchema.parse(result[0]));
});

app.get('/users/:id', async (c) => {
  const id = Number(c.req.param('id'));
  const user = await db.select().from(users).where(eq(users.id, id));
  if (!user[0]) return c.notFound();
  return c.json(selectSchema.parse(user[0]));
});
```

### Form Validation

```typescript
const formSchema = createInsertSchema(users, {
  email: (schema) => schema.email(),  // Add email validation
  age: (schema) => schema.min(18),     // Minimum age
});

type FormData = z.infer<typeof formSchema>;

function validateForm(data: unknown): FormData {
  return formSchema.parse(data);
}
```
