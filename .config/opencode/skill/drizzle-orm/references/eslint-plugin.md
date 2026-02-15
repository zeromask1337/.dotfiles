# ESLint Drizzle Plugin

ESLint plugin for catching common Drizzle ORM mistakes at development time.

## Install

```bash
npm i eslint-plugin-drizzle @typescript-eslint/eslint-plugin @typescript-eslint/parser
```

## Configuration

### Basic Setup (`.eslintrc.yml`)

```yml
root: true
parser: '@typescript-eslint/parser'
parserOptions:
  project: './tsconfig.json'
plugins:
  - drizzle
rules:
  'drizzle/enforce-delete-with-where': "error"
  'drizzle/enforce-update-with-where': "error"
```

### All Config

Enable all rules (except deprecated ones):

```yml
root: true
extends:
  - "plugin:drizzle/all"
parser: '@typescript-eslint/parser'
parserOptions:
  project: './tsconfig.json'
plugins:
  - drizzle
```

### Recommended Config

Currently, `all` is equivalent to `recommended`:

```yml
root: true
extends:
  - "plugin:drizzle/recommended"
parser: '@typescript-eslint/parser'
parserOptions:
  project: './tsconfig.json'
plugins:
  - drizzle
```

## Rules

### enforce-delete-with-where

**Purpose:** Prevents accidental deletion of all table rows.

**Rule:** Requires `.where()` clause in `.delete()` statements.

**Problem:** Most of the time, you don't need to delete all rows and require some kind of `WHERE` condition.

#### Configuration 1: Without drizzleObjectName

```yml
rules:
  'drizzle/enforce-delete-with-where': "error"
```

```typescript
class MyClass {
  public delete() {
    return {}
  }
}

const myClassObj = new MyClass();

// ❌ ESLint Error: triggered on any .delete() call
myClassObj.delete()

const db = drizzle(...)
// ❌ ESLint Error: delete without where
await db.delete(users)
```

#### Configuration 2: With drizzleObjectName

Specify which object names should trigger the rule:

```yml
rules:
  'drizzle/enforce-delete-with-where':
    - "error"
    - "drizzleObjectName": 
      - "db"
```

```typescript
class MyClass {
  public delete() {
    return {}
  }
}

const myClassObj = new MyClass();

// ✅ No ESLint Error: not a Drizzle object
myClassObj.delete()

const db = drizzle(...)
// ❌ ESLint Error: Drizzle delete without where
await db.delete(users)
// ✅ ESLint OK: has where clause
await db.delete(users).where(eq(users.id, 1))
```

**Multiple object names:**

```yml
rules:
  'drizzle/enforce-delete-with-where':
    - "error"
    - "drizzleObjectName": 
      - "db"
      - "database"
      - "connection"
```

### enforce-update-with-where

**Purpose:** Prevents accidental updates to all table rows.

**Rule:** Requires `.where()` clause in `.update()` statements.

**Problem:** Most of the time, you don't need to update all rows and require some kind of `WHERE` condition.

#### Configuration 1: Without drizzleObjectName

```yml
rules:
  'drizzle/enforce-update-with-where': "error"
```

```typescript
class MyClass {
  public update() {
    return {}
  }
}

const myClassObj = new MyClass();

// ❌ ESLint Error: triggered on any .update() call
myClassObj.update()

const db = drizzle(...)
// ❌ ESLint Error: update without where
await db.update(users).set({ name: 'John' })
```

#### Configuration 2: With drizzleObjectName

```yml
rules:
  'drizzle/enforce-update-with-where':
    - "error"
    - "drizzleObjectName": 
      - "db"
```

```typescript
class MyClass {
  public update() {
    return {}
  }
}

const myClassObj = new MyClass();

// ✅ No ESLint Error: not a Drizzle object
myClassObj.update()

const db = drizzle(...)
// ❌ ESLint Error: Drizzle update without where
await db.update(users).set({ name: 'John' })
// ✅ ESLint OK: has where clause
await db.update(users).set({ name: 'John' }).where(eq(users.id, 1))
```

## Complete ESLint Config Example

```yml
# .eslintrc.yml
root: true
env:
  node: true
  es2022: true
parser: '@typescript-eslint/parser'
parserOptions:
  project: './tsconfig.json'
  ecmaVersion: 2022
  sourceType: module
plugins:
  - '@typescript-eslint'
  - drizzle
extends:
  - 'eslint:recommended'
  - 'plugin:@typescript-eslint/recommended'
  - 'plugin:drizzle/recommended'
rules:
  # Your other rules...
  
  # Drizzle specific (overrides recommended if needed)
  'drizzle/enforce-delete-with-where':
    - "error"
    - "drizzleObjectName": 
      - "db"
      - "transaction"
  'drizzle/enforce-update-with-where':
    - "error"
    - "drizzleObjectName": 
      - "db"
      - "transaction"
```

## Why Use This Plugin?

### Prevent Data Loss

Without the plugin:
```typescript
// Accidental full table delete
await db.delete(users)  // Deletes ALL users!

// Accidental full table update
await db.update(users).set({ active: false })  // Deactivates ALL users!
```

With the plugin:
```typescript
// ❌ ESLint Error: Missing where clause
await db.delete(users)

// ✅ ESLint OK: Properly constrained
await db.delete(users).where(eq(users.id, userId))
```

### Best Practices

1. **Always use `drizzleObjectName`** to avoid false positives on non-Drizzle methods
2. **Use "error" level** in production, "warn" in development if needed
3. **Configure for your naming conventions** (db, database, connection, etc.)

## Integration with CI/CD

```yml
# .github/workflows/lint.yml
name: Lint
on: [push, pull_request]

jobs:
  eslint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '18'
      - run: npm ci
      - run: npx eslint . --ext .ts
```

The build will fail if anyone tries to commit delete/update without where clauses.
