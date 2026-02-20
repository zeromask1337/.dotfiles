# Generated Columns

**Requirements:**
- `drizzle-orm@0.32.0` or higher
- `drizzle-kit@0.23.0` or higher

Generated columns are computed from other columns and can be:
- **Virtual**: Computed on read (no storage)
- **Stored**: Computed on write (persisted, indexable)

## PostgreSQL

**Type:** `STORED` only

**How It Works:**
- Automatically computes values during INSERT or UPDATE

**Capabilities:**
- Precomputes complex expressions
- Indexable for better query performance

**Limitations:**
- Cannot specify default values
- Cannot reference other generated columns
- Cannot use subqueries in expression
- Cannot be primary/foreign keys or unique constraints

### Usage

Use `.generatedAlwaysAs()` on any column type:

```typescript
import { pgTable, serial, text, integer, sql } from 'drizzle-orm/pg-core';

const products = pgTable('products', {
  id: serial('id').primaryKey(),
  name: text('name').notNull(),
  price: integer('price').notNull(),
  taxRate: integer('tax_rate').notNull().default(10),
  
  // Stored generated column
  totalPrice: integer('total_price')
    .generatedAlwaysAs(sql`${products.price} + (${products.price} * ${products.taxRate} / 100)`),
});
```

```sql
CREATE TABLE "products" (
  "id" serial PRIMARY KEY,
  "name" text NOT NULL,
  "price" integer NOT NULL,
  "tax_rate" integer NOT NULL DEFAULT 10,
  "total_price" integer GENERATED ALWAYS AS ("price" + ("price" * "tax_rate" / 100)) STORED
);
```

### Indexing Generated Columns

```typescript
import { index, pgTable, serial, text, integer, sql } from 'drizzle-orm/pg-core';

const products = pgTable('products', {
  id: serial('id').primaryKey(),
  name: text('name').notNull(),
  price: integer('price').notNull(),
  totalPrice: integer('total_price')
    .generatedAlwaysAs(sql`${products.price} * 1.1`),
}, (table) => [
  // Index on generated column
  index('total_price_idx').on(table.totalPrice),
]);
```

## MySQL

**Types:** `VIRTUAL` (default) or `STORED`

### Virtual Generated Column

Computed on-the-fly when reading:

```typescript
import { mysqlTable, serial, text, int, sql } from 'drizzle-orm/mysql-core';

const products = mysqlTable('products', {
  id: serial('id').primaryKey(),
  name: text('name').notNull(),
  price: int('price').notNull(),
  
  // Virtual column (computed on read)
  priceWithTax: int('price_with_tax')
    .generatedAlwaysAs(sql`${products.price} * 1.1`),
});
```

```sql
CREATE TABLE `products` (
  `id` serial PRIMARY KEY,
  `name` text NOT NULL,
  `price` int NOT NULL,
  `price_with_tax` int AS (`price` * 1.1) VIRTUAL
);
```

### Stored Generated Column

Computed on INSERT/UPDATE and persisted:

```typescript
const products = mysqlTable('products', {
  id: serial('id').primaryKey(),
  name: text('name').notNull(),
  price: int('price').notNull(),
  
  // Stored column (computed on write, persisted)
  priceWithTax: int('price_with_tax')
    .generatedAlwaysAs(sql`${products.price} * 1.1`, { mode: 'stored' }),
});
```

```sql
CREATE TABLE `products` (
  `id` serial PRIMARY KEY,
  `name` text NOT NULL,
  `price` int NOT NULL,
  `price_with_tax` int AS (`price` * 1.1) STORED
);
```

**MySQL Capabilities:**
- Both VIRTUAL and STORED supported
- Can be indexed (especially STORED)
- Can reference other generated columns
- Cannot be part of primary key or foreign key

## SQLite

**Types:** `VIRTUAL` (default) or `STORED`

### Virtual Generated Column

```typescript
import { sqliteTable, integer, text, sql } from 'drizzle-orm/sqlite-core';

const products = sqliteTable('products', {
  id: integer('id').primaryKey(),
  name: text('name').notNull(),
  price: integer('price').notNull(),
  
  // Virtual column
  priceWithTax: integer('price_with_tax')
    .generatedAlwaysAs(sql`${products.price} * 110 / 100`),
});
```

```sql
CREATE TABLE "products" (
  "id" integer PRIMARY KEY,
  "name" text NOT NULL,
  "price" integer NOT NULL,
  "price_with_tax" integer GENERATED ALWAYS AS ("price" * 110 / 100) VIRTUAL
);
```

### Stored Generated Column

```typescript
const products = sqliteTable('products', {
  id: integer('id').primaryKey(),
  name: text('name').notNull(),
  price: integer('price').notNull(),
  
  // Stored column
  priceWithTax: integer('price_with_tax')
    .generatedAlwaysAs(sql`${products.price} * 110 / 100`, { mode: 'stored' }),
});
```

```sql
CREATE TABLE "products" (
  "id" integer PRIMARY KEY,
  "name" text NOT NULL,
  "price" integer NOT NULL,
  "price_with_tax" integer GENERATED ALWAYS AS ("price" * 110 / 100) STORED
);
```

**SQLite Capabilities:**
- VIRTUAL: Computed on read, no storage
- STORED: Computed on write, uses storage
- Cannot use STORED on PRIMARY KEY columns
- Can reference other columns but not other generated columns

## SingleStore

**Status:** Work in progress (WIP)

## MSSQL

**Status:** Coming soon

## CockroachDB

**Status:** Coming soon

## Practical Examples

### 1. Price Calculation

```typescript
const orderItems = pgTable('order_items', {
  id: serial('id').primaryKey(),
  unitPrice: integer('unit_price').notNull(),
  quantity: integer('quantity').notNull(),
  discount: integer('discount').notNull().default(0),
  
  // Calculated total (stored)
  totalAmount: integer('total_amount')
    .generatedAlwaysAs(
      sql`(${orderItems.unitPrice} * ${orderItems.quantity}) - ${orderItems.discount}`
    ),
});
```

### 2. Full Name from Parts

```typescript
const users = pgTable('users', {
  id: serial('id').primaryKey(),
  firstName: text('first_name').notNull(),
  lastName: text('last_name').notNull(),
  
  // Combined full name
  fullName: text('full_name')
    .generatedAlwaysAs(
      sql`${users.firstName} || ' ' || ${users.lastName}`
    ),
}, (table) => [
  // Index for searching
  index('full_name_idx').on(table.fullName),
]);
```

### 3. Lowercase Search Column

```typescript
const products = pgTable('products', {
  id: serial('id').primaryKey(),
  name: text('name').notNull(),
  
  // Lowercase for case-insensitive search
  nameLower: text('name_lower')
    .generatedAlwaysAs(sql`lower(${products.name})`),
}, (table) => [
  // Index for fast case-insensitive lookup
  index('name_lower_idx').on(table.nameLower),
]);

// Query using generated column
const searchResults = await db
  .select()
  .from(products)
  .where(eq(products.nameLower, searchTerm.toLowerCase()));
```

### 4. JSON Extraction

```typescript
const users = pgTable('users', {
  id: serial('id').primaryKey(),
  metadata: jsonb('metadata').notNull(),
  
  // Extract specific field from JSON
  email: text('email')
    .generatedAlwaysAs(sql`${users.metadata}->>'email'`),
}, (table) => [
  index('email_idx').on(table.email),
]);
```

### 5. Date Manipulation

```typescript
const events = pgTable('events', {
  id: serial('id').primaryKey(),
  startDate: timestamp('start_date').notNull(),
  duration: integer('duration').notNull(),  -- in minutes
  
  // Calculate end date
  endDate: timestamp('end_date')
    .generatedAlwaysAs(
      sql`${events.startDate} + (${events.duration} || ' minutes')::interval`
    ),
});
```

## Best Practices

### 1. Use STORED for Indexable Data

```typescript
// ✅ Good: STORED for searchable columns
searchableField: text('searchable')
  .generatedAlwaysAs(sql`lower(${table.name})`),

// ❌ Avoid: VIRTUAL can't be easily indexed in PostgreSQL
```

### 2. Keep Expressions Simple

```typescript
// ✅ Good: Simple calculation
priceWithTax: integer('price_with_tax')
  .generatedAlwaysAs(sql`${products.price} * 1.1`),

// ❌ Avoid: Complex logic with subqueries
complexField: text('complex')
  .generatedAlwaysAs(sql`(SELECT ... FROM other_table)`),  // Not allowed
```

### 3. Index Frequently Queried Generated Columns

```typescript
const table = pgTable('table', {
  // ... columns
  searchable: text('searchable')
    .generatedAlwaysAs(sql`lower(${table.name})`),
}, (t) => [
  // ✅ Index for fast lookups
  index('searchable_idx').on(t.searchable),
]);
```

### 4. Don't Reference Other Generated Columns

```typescript
const table = pgTable('table', {
  price: integer('price').notNull(),
  
  // ✅ Good: Reference base columns
  tax: integer('tax')
    .generatedAlwaysAs(sql`${table.price} * 0.1`),
  
  // ❌ Avoid: PostgreSQL doesn't allow this
  total: integer('total')
    .generatedAlwaysAs(sql`${table.price} + ${table.tax}`),  // Error!
});
```

## Database Comparison

| Feature | PostgreSQL | MySQL | SQLite |
|---------|-----------|-------|---------|
| VIRTUAL | ❌ | ✅ | ✅ |
| STORED | ✅ | ✅ | ✅ |
| Indexable | ✅ | ✅ (both) | ✅ (both) |
| Reference other generated | ❌ | ✅ | ❌ |
| Foreign key | ❌ | ❌ | ❌ |
| Primary key | ❌ | ❌ | ❌ (for STORED) |
