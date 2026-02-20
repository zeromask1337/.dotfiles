# TypeBox Schema Validation

Generate [TypeBox](https://sinclairzx81.github.io/typebox/) schemas from Drizzle ORM schemas for type-safe validation and JSON Schema generation.

**Features:**
- Create select schemas for tables, views, and enums
- Create insert and update schemas for tables
- Supports all dialects: PostgreSQL, MySQL, SQLite, SingleStore, MSSQL, CockroachDB
- Generates standard JSON Schema compatible with OpenAPI, Fastify, and other tools

## Installation

```bash
npm i drizzle-orm typebox
```

## Usage

### Select Schema

Validates data queried from the database (API responses):

```typescript
import { pgTable, serial, text, timestamp } from 'drizzle-orm/pg-core';
import { createSelectSchema } from 'drizzle-orm/typebox';
import { Value } from 'typebox/value';

const users = pgTable('users', {
  id: serial('id').primaryKey(),
  name: text('name').notNull(),
  email: text('email').notNull(),
  role: text('role', { enum: ['admin', 'user'] }).notNull(),
  createdAt: timestamp('created_at').notNull().defaultNow(),
});

const selectUserSchema = createSelectSchema(users);

// Validate query result
const isValid = Value.Check(selectUserSchema, rows[0]);
```

### Insert Schema

Validates data to be inserted (API requests):

```typescript
import { createInsertSchema } from 'drizzle-orm/typebox';
import { Value } from 'typebox/value';

const insertUserSchema = createInsertSchema(users);

const user = { name: 'John Doe', email: 'john@test.com', role: 'admin' };
const isValid = Value.Check(insertUserSchema, user); // Excludes generated id and default fields
```

### Update Schema

Validates data for updates:

```typescript
import { createUpdateSchema } from 'drizzle-orm/typebox';

const updateUserSchema = createUpdateSchema(users);

const update = { age: 35 };
const isValid = Value.Check(updateUserSchema, update); // All fields optional
```

## Refinements

Extend or override field schemas:

```typescript
import { Type } from 'typebox';

const insertUserSchema = createInsertSchema(users, {
  role: Type.String(),                              // Override: use plain string
  id: (schema) => Type.Number({ ...schema, minimum: 0 }), // Extend: add minimum
});

// Validate
const isValid: boolean = Value.Check(insertUserSchema, {
  name: 'John Doe',
  email: 'johndoe@test.com',
  role: 'admin',
});
```

## Practical Examples

### Fastify Integration

```typescript
import Fastify from 'fastify';
import { createInsertSchema, createSelectSchema } from 'drizzle-orm/typebox';
import { Type } from 'typebox';

const app = Fastify();

const insertSchema = createInsertSchema(users);
const selectSchema = createSelectSchema(users);

// Type-safe route with JSON Schema validation
app.post('/users', {
  schema: {
    body: insertSchema,
    response: {
      200: selectSchema
    }
  }
}, async (request, reply) => {
  const data = request.body;
  const result = await db.insert(users).values(data).returning();
  return result[0];
});
```

### Elysia Integration

```typescript
import { Elysia } from 'elysia';

const app = new Elysia()
  .post('/users', async ({ body }) => {
    const result = await db.insert(users).values(body).returning();
    return result[0];
  }, {
    body: createInsertSchema(users),
    response: createSelectSchema(users)
  });
```

### JSON Schema Export

```typescript
import { createInsertSchema } from 'drizzle-orm/typebox';

const insertSchema = createInsertSchema(users);

// Export to JSON Schema for OpenAPI specs
const jsonSchema = { ...insertSchema }; // TypeBox schemas are JSON Schema compatible
console.log(JSON.stringify(jsonSchema, null, 2));
```

## TypeBox vs TypeBox Legacy

Drizzle ORM provides two TypeBox packages:

### `drizzle-orm/typebox` (Current)
Uses the standard `typebox` package:

```typescript
import { createInsertSchema } from 'drizzle-orm/typebox';
```

### `drizzle-orm/typebox-legacy` (Deprecated)
Uses `@sinclair/typebox` (older package name):

```typescript
import { createInsertSchema } from 'drizzle-orm/typebox-legacy';
```

**Recommendation:** Use `drizzle-orm/typebox` for new projects.

## Data Type Mapping Reference

TypeBox generates standard JSON Schema types. The exact schema structure depends on the Drizzle column type.

### Common Types

| Drizzle Type | TypeBox Schema |
|--------------|---------------|
| `boolean()` | `{ type: 'boolean' }` |
| `integer()`, `serial()` | `{ type: 'integer' }` |
| `real()`, `float()`, `doublePrecision()` | `{ type: 'number' }` |
| `text()`, `varchar()`, `char()` | `{ type: 'string' }` |
| `varchar({ length })` | `{ type: 'string', maxLength: N }` |
| `char({ length })` | `{ type: 'string', minLength: N, maxLength: N }` |
| `text({ enum })` | `{ type: 'string', enum: [...] }` |
| `date()`, `timestamp()` (mode: date) | `{ type: 'string', format: 'date-time' }` or custom |
| `json()`, `jsonb()` | `{ type: 'object' }` or `{ anyOf: [...] }` |
| `uuid()` | `{ type: 'string', format: 'uuid' }` |
| Arrays (`.array()`) | `{ type: 'array', items: {...} }` |

### Numeric Constraints (MySQL/PostgreSQL)

```typescript
// tinyint - 8-bit signed
Type.Integer({ minimum: -128, maximum: 127 })

// tinyint unsigned - 8-bit unsigned
Type.Integer({ minimum: 0, maximum: 255 })

// smallint - 16-bit signed
Type.Integer({ minimum: -32768, maximum: 32767 })

// integer - 32-bit signed
Type.Integer({ minimum: -2147483648, maximum: 2147483647 })

// bigint - 64-bit as number
Type.Integer({ minimum: -9007199254740991, maximum: 9007199254740991 })

// bigint as bigint
Type.BigInt() // Note: JSON doesn't natively support bigint
```

### String Length Limits by MySQL Type

```typescript
// tinytext: 255 bytes
Type.String({ maxLength: 255 })

// text: 65535 bytes
Type.String({ maxLength: 65535 })

// mediumtext: 16MB
Type.String({ maxLength: 16777215 })

// longtext: 4GB
Type.String({ maxLength: 4294967295 })
```

### Geometric Types

```typescript
// point (mode: 'tuple')
Type.Tuple([Type.Number(), Type.Number()])

// point (mode: 'xy')
Type.Object({ x: Type.Number(), y: Type.Number() })

// vector({ dimensions: 3 })
Type.Array(Type.Number(), { minItems: 3, maxItems: 3 })

// line (mode: 'abc')
Type.Object({ a: Type.Number(), b: Type.Number(), c: Type.Number() })

// line (mode: 'tuple')
Type.Tuple([Type.Number(), Type.Number(), Type.Number()])
```

## Advanced Patterns

### Conditional Validation

```typescript
import { Type, Conditional } from 'typebox';

const schema = createInsertSchema(users, {
  email: (baseSchema) => Type.String({
    ...baseSchema,
    format: 'email'
  }),
  age: (baseSchema) => Type.Integer({
    ...baseSchema,
    minimum: 18,
    maximum: 120
  })
});
```

### Composition

```typescript
import { createSelectSchema, createInsertSchema } from 'drizzle-orm/typebox';
import { Type } from 'typebox';

const baseUserSchema = createSelectSchema(users);
const insertUserSchema = createInsertSchema(users);

// Compose schemas
const apiResponseSchema = Type.Object({
  data: baseUserSchema,
  meta: Type.Object({
    total: Type.Integer()
  })
});
```

### Custom Validators

```typescript
import { Value } from 'typebox/value';

const schema = createInsertSchema(users);

// Custom validation
function validateUser(data: unknown) {
  const errors = [...Value.Errors(schema, data)];
  if (errors.length > 0) {
    throw new Error(`Validation failed: ${errors.map(e => e.message).join(', ')}`);
  }
  return Value.Cast(schema, data);
}
```
