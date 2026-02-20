# Valibot Schema Validation

Generate [Valibot](https://valibot.dev/) schemas from Drizzle ORM schemas for type-safe validation.

**Features:**
- Create select schemas for tables, views, and enums
- Create insert and update schemas for tables
- Supports all dialects: PostgreSQL, MySQL, SQLite, SingleStore, MSSQL, CockroachDB

## Installation

```bash
npm i drizzle-orm valibot
```

## Usage

### Select Schema

Validates data queried from the database (API responses):

```typescript
import { pgTable, text, integer } from 'drizzle-orm/pg-core';
import { createSelectSchema } from 'drizzle-orm/valibot';
import { parse } from 'valibot';

const users = pgTable('users', {
  id: integer().generatedAlwaysAsIdentity().primaryKey(),
  name: text().notNull(),
  age: integer().notNull()
});

const userSelectSchema = createSelectSchema(users);

// Validate query result
const rows = await db.select().from(users).limit(1);
const parsed = parse(userSelectSchema, rows[0]);
```

### Insert Schema

Validates data to be inserted (API requests):

```typescript
import { createInsertSchema } from 'drizzle-orm/valibot';
import { parse } from 'valibot';

const userInsertSchema = createInsertSchema(users);

const user = { name: 'Jane', age: 30 };
const parsed = parse(userInsertSchema, user); // Excludes generated id
await db.insert(users).values(parsed);
```

### Update Schema

Validates data for updates:

```typescript
import { createUpdateSchema } from 'drizzle-orm/valibot';
import { parse } from 'valibot';

const userUpdateSchema = createUpdateSchema(users);

const update = { age: 35 };
const parsed = parse(userUpdateSchema, update); // All fields optional, excludes generated id
await db.update(users).set(parsed).where(eq(users.name, 'Jane'));
```

### Views and Enums

```typescript
import { pgEnum, pgView } from 'drizzle-orm/pg-core';
import { parse } from 'valibot';

// Enums
const roles = pgEnum('roles', ['admin', 'basic']);
const rolesSchema = createSelectSchema(roles);
const parsed = parse(rolesSchema, 'admin'); // 'admin' | 'basic'

// Views
const usersView = pgView('users_view').as((qb) => 
  qb.select().from(users).where(gt(users.age, 18))
);
const usersViewSchema = createSelectSchema(usersView);
```

## Refinements

Extend or override field schemas using Valibot's pipe API:

```typescript
import { pipe, maxLength, object, string } from 'valibot';

const userSelectSchema = createSelectSchema(users, {
  name: (schema) => pipe(schema, maxLength(20)),      // Extend: add max length
  bio: (schema) => pipe(schema, maxLength(1000)),     // Extend before nullable
  preferences: object({ theme: string() })            // Override: replace entire schema
});

const parsed = parse(userSelectSchema, data);
```

## Data Type Mapping Reference

| Drizzle Type | Valibot Schema |
|--------------|---------------|
| `boolean()` | `boolean()` |
| `date()` / `timestamp()` (mode: date) | `date()` |
| `date()` / `timestamp()` (mode: string) | `string()` |
| `text()`, `varchar()`, `char()` | `string()` |
| `varchar({ length })`, `char({ length })` | `pipe(string(), length(length))` |
| `varchar({ length })` (max) | `pipe(string(), maxLength(length))` |
| `text({ enum })` | `enum(enum)` |
| `uuid()` | `pipe(string(), uuid())` |
| `bit({ dimensions })` | `pipe(string(), regex(/^[01]+$/), maxLength(dimensions))` |
| `integer()`, `serial()` | `pipe(number(), integer())` |
| `smallint()` | `pipe(number(), minValue(-32768), maxValue(32767), integer())` |
| `bigint({ mode: 'number' })` | `pipe(number(), minValue(-9007199254740991), maxValue(9007199254740991), integer())` |
| `bigint({ mode: 'bigint' })` | `pipe(bigint(), minValue(-9223372036854775808n), maxValue(9223372036854775807n))` |
| `real()`, `float()` | `number()` |
| `doublePrecision()` | `number()` |
| `json()`, `jsonb()` | `union([union([string(), number(), boolean(), null_()]), array(any()), record(string(), any())])` |
| `point({ mode: 'tuple' })` | `tuple([number(), number()])` |
| `point({ mode: 'xy' })` | `object({ x: number(), y: number() })` |
| `vector({ dimensions })` | `pipe(array(number()), length(dimensions))` |
| `line({ mode: 'abc' })` | `object({ a: number(), b: number(), c: number() })` |
| `line({ mode: 'tuple' })` | `tuple([number(), number(), number()])` |

### MySQL-Specific Types

| Drizzle Type | Valibot Schema |
|--------------|---------------|
| `tinyint()` | `pipe(number(), minValue(-128), maxValue(127), integer())` |
| `tinyint({ unsigned: true })` | `pipe(number(), minValue(0), maxValue(255), integer())` |
| `smallint({ unsigned: true })` | `pipe(number(), minValue(0), maxValue(65535), integer())` |
| `mediumint()` | `pipe(number(), minValue(-8388608), maxValue(8388607), integer())` |
| `int({ unsigned: true })` | `pipe(number(), minValue(0), maxValue(4294967295), integer())` |
| `tinytext()` | `pipe(string(), maxLength(255))` |
| `text()` | `pipe(string(), maxLength(65535))` |
| `mediumtext()` | `pipe(string(), maxLength(16777215))` |
| `longtext()` | `pipe(string(), maxLength(4294967295))` |
| `year()` | `pipe(number(), minValue(1901), maxValue(2155), integer())` |
| `serial` | `pipe(number(), minValue(0), maxValue(9007199254740991), integer())` |

### String Length Limits by MySQL Type

```typescript
import { pipe, maxLength, string } from 'valibot';

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
import { vValidator } from '@hono/valibot-validator';

const app = new Hono();

const insertSchema = createInsertSchema(users);
const selectSchema = createSelectSchema(users);

app.post('/users', vValidator('json', insertSchema), async (c) => {
  const data = c.req.valid('json');
  const result = await db.insert(users).values(data).returning();
  return c.json(parse(selectSchema, result[0]));
});

app.get('/users/:id', async (c) => {
  const id = Number(c.req.param('id'));
  const user = await db.select().from(users).where(eq(users.id, id));
  if (!user[0]) return c.notFound();
  return c.json(parse(selectSchema, user[0]));
});
```

### Form Validation

```typescript
import { pipe, email, minValue } from 'valibot';

const formSchema = createInsertSchema(users, {
  email: (schema) => pipe(schema, email()),  // Add email validation
  age: (schema) => pipe(schema, minValue(18)), // Minimum age
});

type FormData = Output<typeof formSchema>;

function validateForm(data: unknown): FormData {
  return parse(formSchema, data);
}
```

### Safe Parsing

```typescript
import { safeParse } from 'valibot';

const result = safeParse(userInsertSchema, unknownData);

if (result.success) {
  await db.insert(users).values(result.output);
} else {
  console.error('Validation errors:', result.issues);
}
```
