# Effect Schema Validation

Generate [Effect](https://effect.website/) schemas from Drizzle ORM schemas for type-safe validation using Effect's powerful functional programming ecosystem.

**Features:**
- Create select schemas for tables, views, and enums
- Create insert and update schemas for tables
- Full Effect ecosystem integration (Schema, Effect, Stream, etc.)
- Supported dialects: CockroachDB, MSSQL, MySQL, PostgreSQL, SingleStore, SQLite

## Installation

```bash
npm i drizzle-orm effect
```

## Requirements

Requires `drizzle-orm@1.0.0-beta.15` or later:

```bash
npm i drizzle-orm@beta
```

## Usage

### Select Schema

Validates data queried from the database (API responses):

```typescript
import { pgEnum, pgTable, serial, text, timestamp } from 'drizzle-orm/pg-core';
import { createInsertSchema, createSelectSchema, createUpdateSchema } from 'drizzle-orm/effect-schema';
import { Schema } from 'effect';
import { Effect } from 'effect';

const users = pgTable('users', {
  id: serial('id').primaryKey(),
  name: text('name').notNull(),
  email: text('email').notNull(),
  role: text('role', { enum: ['admin', 'user'] }).notNull(),
  createdAt: timestamp('created_at').notNull().defaultNow(),
});

// Schema for selecting a user
const UserSelect = createSelectSchema(users);

// Usage with Effect
const program = Effect.gen(function*() {
  const rows = yield* Effect.promise(() => db.select().from(users).limit(1));
  const parsedUser = yield* Schema.validate(UserSelect)(rows[0]);
  return parsedUser;
});

// Run the program
Effect.runPromise(program);
```

### Insert Schema

Validates data to be inserted (API requests):

```typescript
const UserInsert = createInsertSchema(users);

const program = Effect.gen(function*() {
  const parsedUser = yield* Schema.validate(UserInsert)({
    name: 'John Doe',
    email: 'johndoe@test.com',
    role: 'admin',
  });
  
  // Insert into database
  yield* Effect.promise(() => db.insert(users).values(parsedUser));
});
```

### Update Schema

Validates data for updates:

```typescript
const UserUpdate = createUpdateSchema(users);

const program = Effect.gen(function*() {
  const update = { name: 'Jane Doe' };
  const parsed = yield* Schema.validate(UserUpdate)(update);
  
  yield* Effect.promise(() => 
    db.update(users).set(parsed).where(eq(users.id, 1))
  );
});
```

## Refinements

Extend or override field schemas using Effect's Schema API:

```typescript
import { Schema, pipe } from 'effect';

const UserInsert = createInsertSchema(users, {
  role: Schema.String,                           // Override with plain string
  id: (schema) => schema.pipe(                    // Extend with pipe
    Schema.greaterThanOrEqualTo(0)
  ),
});

const program = Effect.gen(function*() {
  const parsed = yield* Schema.validate(UserInsert)({
    name: 'John Doe',
    email: 'johndoe@test.com',
    role: 'admin',
  });
});
```

## Effect Ecosystem Integration

### With Effect Services

```typescript
import { Context, Effect, Layer, Schema } from 'effect';

// Define a repository service
class UserRepository extends Context.Tag('UserRepository')<
  UserRepository,
  {
    readonly findById: (id: number) => Effect.Effect<unknown, Error>;
    readonly insert: (user: unknown) => Effect.Effect<void, Error>;
  }
>() {}

// Validation schemas
const UserSelect = createSelectSchema(users);
const UserInsert = createInsertSchema(users);

// Service implementation with validation
const UserRepositoryLive = Layer.succeed(
  UserRepository,
  UserRepository.of({
    findById: (id) => Effect.gen(function*() {
      const row = yield* Effect.promise(() => 
        db.select().from(users).where(eq(users.id, id))
      );
      return yield* Schema.validate(UserSelect)(row[0]);
    }),
    
    insert: (user) => Effect.gen(function*() {
      const parsed = yield* Schema.validate(UserInsert)(user);
      yield* Effect.promise(() => db.insert(users).values(parsed));
    }),
  })
);
```

### Error Handling

```typescript
import { Effect, Schema } from 'effect';

const program = Effect.gen(function*() {
  const result = yield* Schema.validate(UserInsert)(unknownData).pipe(
    Effect.mapError((errors) => new Error(`Validation failed: ${JSON.stringify(errors)}`))
  );
  
  return result;
}).pipe(
  Effect.catchAll((error) => Effect.logError(error.message))
);
```

### Composing with Other Effects

```typescript
import { Effect, Schema, pipe } from 'effect';

const validateAndInsert = (data: unknown) =>
  Effect.gen(function*() {
    // Validate input
    const user = yield* Schema.validate(UserInsert)(data);
    
    // Additional business logic
    yield* Effect.log(`Inserting user: ${user.name}`);
    
    // Database operation
    const result = yield* Effect.promise(() => 
      db.insert(users).values(user).returning()
    );
    
    // Validate output
    const inserted = yield* Schema.validate(UserSelect)(result[0]);
    
    return inserted;
  }).pipe(
    Effect.tap((user) => Effect.log(`Successfully inserted user ${user.id}`))
  );
```

## Data Type Mapping Reference

Effect Schema provides powerful type inference and validation. Here's how Drizzle types map to Effect schemas:

| Drizzle Type | Effect Schema |
|--------------|---------------|
| `boolean()` | `Schema.Boolean` |
| `date()` / `timestamp()` (mode: date) | `Schema.Date` |
| `date()` / `timestamp()` (mode: string) | `Schema.String` |
| `text()`, `varchar()`, `char()` | `Schema.String` |
| `varchar({ length })`, `char({ length })` | `Schema.String` with refinements |
| `text({ enum })` | `Schema.Literal(...enum)` |
| `uuid()` | `Schema.String` with UUID format |
| `integer()`, `serial()` | `Schema.Number` with `Schema.int()` |
| `smallint()` | `Schema.Number` with range validation |
| `bigint({ mode: 'number' })` | `Schema.Number` with safe integer range |
| `bigint({ mode: 'bigint' })` | `Schema.BigInt` |
| `real()`, `float()` | `Schema.Number` |
| `doublePrecision()` | `Schema.Number` |
| `json()`, `jsonb()` | `Schema.Unknown` or complex union |
| `point({ mode: 'tuple' })` | `Schema.Tuple([Schema.Number, Schema.Number])` |
| `point({ mode: 'xy' })` | `Schema.Struct({ x: Schema.Number, y: Schema.Number })` |
| `vector({ dimensions })` | `Schema.Array(Schema.Number)` with length |
| `line({ mode: 'abc' })` | `Schema.Struct({ a, b, c: Schema.Number })` |
| `line({ mode: 'tuple' })` | `Schema.Tuple([Schema.Number, Schema.Number, Schema.Number])` |

### MySQL-Specific Types

| Drizzle Type | Effect Schema |
|--------------|---------------|
| `tinyint()` | `Schema.Number` with int and range `-128` to `127` |
| `tinyint({ unsigned: true })` | `Schema.Number` with int and range `0` to `255` |
| `smallint({ unsigned: true })` | `Schema.Number` with int and range `0` to `65535` |
| `mediumint()` | `Schema.Number` with int and range `-8388608` to `8388607` |
| `int({ unsigned: true })` | `Schema.Number` with int and range `0` to `4294967295` |
| `year()` | `Schema.Number` with int and range `1901` to `2155` |

## Advanced Patterns

### Schema Composition

```typescript
import { Schema } from 'effect';

const UserSelect = createSelectSchema(users);
const PostSelect = createSelectSchema(posts);

// Compose schemas
const UserWithPosts = Schema.Struct({
  ...UserSelect.fields,
  posts: Schema.Array(PostSelect)
});
```

### Conditional Validation

```typescript
import { Schema, Predicate } from 'effect';

const AdminUser = createSelectSchema(users, {
  role: Schema.Literal('admin'),
});

const RegularUser = createSelectSchema(users, {
  role: Schema.Literal('user'),
});

const User = Schema.Union(AdminUser, RegularUser);
```

### Stream Processing

```typescript
import { Stream, Effect, Schema } from 'effect';

const UserSelect = createSelectSchema(users);

const processUsers = Effect.gen(function*() {
  const rows = yield* Effect.promise(() => db.select().from(users));
  
  const validatedStream = Stream.fromIterable(rows).pipe(
    Stream.mapEffect((row) => Schema.validate(UserSelect)(row)),
    Stream.catchAll((error) => Stream.logError(`Validation error: ${error}`))
  );
  
  yield* Stream.runCollect(validatedStream);
});
```

### Testing with Effect

```typescript
import { Effect, Schema } from 'effect';
import { it, expect } from '@effect/vitest';

const UserInsert = createInsertSchema(users);

it.effect('should validate valid user data', () =>
  Effect.gen(function*() {
    const validData = {
      name: 'John',
      email: 'john@example.com',
      role: 'user'
    };
    
    const result = yield* Schema.validate(UserInsert)(validData);
    expect(result.name).toBe('John');
  }));

it.effect('should fail on invalid data', () =>
  Effect.gen(function*() {
    const invalidData = { name: 'John' }; // missing required fields
    
    const exit = yield* Effect.exit(
      Schema.validate(UserInsert)(invalidData)
    );
    
    expect(Exit.isFailure(exit)).toBe(true);
  }));
```

## Comparison with Other Validators

| Feature | Effect Schema | Zod | Valibot |
|---------|---------------|-----|---------|
| Ecosystem | Full FP ecosystem | Standalone | Standalone |
| Tree-shaking | Excellent | Good | Excellent |
| Composability | High (monadic) | Medium | Medium |
| Error handling | Structured | Flat | Flat |
| Learning curve | Steeper | Gentle | Gentle |
| Bundle size | Larger (with Effect) | Medium | Small |

**Choose Effect when:**
- Building complex, composable validation pipelines
- Already using Effect ecosystem
- Need advanced error handling and composition
- Working with streams and async workflows
