# Query Utilities

## $count

Count rows in a table with various conditions.

### Basic Count

```typescript
import { count } from 'drizzle-orm';

// Count all rows
const result = await db
  .select({ count: count() })
  .from(products);

// Result: { count: number }[]
```

```sql
SELECT count(*) FROM products;
```

### Count Non-Null Values

```typescript
// Count rows where column is not null
const result = await db
  .select({ count: count(products.discount) })
  .from(products);
```

```sql
SELECT count("discount") FROM products;
```

### Count with Condition

```typescript
import { count, gt } from 'drizzle-orm';

const result = await db
  .select({ count: count() })
  .from(products)
  .where(gt(products.price, 100));
```

```sql
SELECT count(*) FROM products WHERE price > 100;
```

### Count with Joins

```typescript
import { count, eq } from 'drizzle-orm';

const result = await db
  .select({ count: count(orders.id) })
  .from(orders)
  .leftJoin(customers, eq(orders.customerId, customers.id))
  .where(eq(customers.country, 'USA'));
```

### Count with SQL Operator

For PostgreSQL and MySQL, `count()` returns `bigint` interpreted as string. Cast to number:

```typescript
import { sql } from 'drizzle-orm';

// PostgreSQL - cast to integer
const result = await db.select({
  count: sql<number>`cast(count(*) as integer)`
}).from(products);

// MySQL - cast to unsigned integer
const result = await db.select({
  count: sql<number>`cast(count(*) as unsigned)`
}).from(products);

// SQLite - returns integer natively
const result = await db.select({
  count: sql<number>`count(*)`
}).from(products);
```

### Custom Count Function

```typescript
import { AnyColumn, sql } from 'drizzle-orm';

const customCount = (column?: AnyColumn) => {
  if (column) {
    return sql<number>`cast(count(${column}) as integer)`;
  }
  return sql<number>`cast(count(*) as integer)`;
};

// Usage
await db.select({ count: customCount() }).from(products);
await db.select({ count: customCount(products.discount) }).from(products);
```

## Conditional Filters

Apply filters conditionally based on runtime values.

### Basic Conditional Filter

```typescript
import { ilike } from 'drizzle-orm';

const searchPosts = async (term?: string) => {
  await db
    .select()
    .from(posts)
    .where(term ? ilike(posts.title, term) : undefined);
};

// No filter when term is undefined
await searchPosts();
// SELECT * FROM posts;

// With filter
await searchPosts('AI');
// SELECT * FROM posts WHERE title ilike 'AI';
```

### Multiple Conditional Filters

```typescript
import { and, gt, ilike, inArray } from 'drizzle-orm';

const searchPosts = async (
  term?: string,
  categories: string[] = [],
  views = 0
) => {
  await db
    .select()
    .from(posts)
    .where(
      and(
        term ? ilike(posts.title, term) : undefined,
        categories.length > 0 ? inArray(posts.category, categories) : undefined,
        views > 100 ? gt(posts.views, views) : undefined,
      ),
    );
};

// All conditions
await searchPosts('AI', ['Tech', 'Art', 'Science'], 200);
```

```sql
SELECT * FROM posts
WHERE (
  title ilike 'AI'
  AND category in ('Tech', 'Science', 'Art')
  AND views > 200
);
```

### Dynamic Filter Array

```typescript
import { SQL } from 'drizzle-orm';

const searchPosts = async (filters: SQL[]) => {
  await db
    .select()
    .from(posts)
    .where(and(...filters));
};

// Build filters dynamically
const filters: SQL[] = [];
filters.push(ilike(posts.title, 'AI'));
filters.push(inArray(posts.category, ['Tech', 'Art', 'Science']));
filters.push(gt(posts.views, 200));

await searchPosts(filters);
```

### Custom Filter Operator

Create reusable custom operators:

```typescript
import { AnyColumn, sql } from 'drizzle-orm';

// Length less than operator
const lenlt = (column: AnyColumn, value: number) => {
  return sql`length(${column}) < ${value}`;
};

const searchPosts = async (maxLen = 0, views = 0) => {
  await db
    .select()
    .from(posts)
    .where(
      and(
        maxLen ? lenlt(posts.title, maxLen) : undefined,
        views > 100 ? gt(posts.views, views) : undefined,
      ),
    );
};

await searchPosts(8);
// SELECT * FROM posts WHERE length(title) < 8;

await searchPosts(8, 200);
// SELECT * FROM posts WHERE (length(title) < 8 AND views > 200);
```

### How Operators Work

Drizzle operators are SQL expressions:

```typescript
// lt implementation example
const lt = (left, right) => {
  return sql`${left} < ${bindIfParam(right, left)}`;
};
```

## Query Building Patterns

### Pagination Helper

```typescript
function withPagination<T extends PgSelect>(
  qb: T,
  page: number = 1,
  pageSize: number = 10
) {
  return qb.limit(pageSize).offset((page - 1) * pageSize);
}

// Usage
const results = await withPagination(
  db.select().from(users),
  2,  // page 2
  20  // 20 per page
);
```

### Search Helper

```typescript
function withSearch<T extends PgSelect>(
  qb: T,
  table: typeof users,
  searchTerm?: string
) {
  if (!searchTerm) return qb;
  return qb.where(
    or(
      ilike(table.name, `%${searchTerm}%`),
      ilike(table.email, `%${searchTerm}%`)
    )
  );
}

// Usage
const results = await withSearch(
  db.select().from(users),
  users,
  'john'
);
```

### Dynamic Query Builder

```typescript
function buildUserQuery(filters: {
  name?: string;
  email?: string;
  active?: boolean;
  page?: number;
}) {
  let query = db.select().from(users).$dynamic();
  const conditions = [];

  if (filters.name) {
    conditions.push(ilike(users.name, `%${filters.name}%`));
  }
  if (filters.email) {
    conditions.push(ilike(users.email, `%${filters.email}%`));
  }
  if (filters.active !== undefined) {
    conditions.push(eq(users.active, filters.active));
  }

  if (conditions.length > 0) {
    query = query.where(and(...conditions));
  }

  if (filters.page) {
    query = query.limit(20).offset((filters.page - 1) * 20);
  }

  return query;
}

// Usage
const results = await buildUserQuery({
  name: 'john',
  active: true,
  page: 1
});
```

## Ordering Utilities

### Dynamic Order By

```typescript
import { asc, desc } from 'drizzle-orm';

function withOrderBy<T extends PgSelect>(
  qb: T,
  table: typeof users,
  sortBy?: string,
  sortOrder: 'asc' | 'desc' = 'asc'
) {
  if (!sortBy) return qb;
  
  const column = table[sortBy as keyof typeof table];
  if (!column) return qb;
  
  return qb.orderBy(sortOrder === 'asc' ? asc(column) : desc(column));
}

// Usage
await withOrderBy(
  db.select().from(users),
  users,
  'createdAt',
  'desc'
);
```

## Aggregation Helpers

### Common Aggregations

```typescript
import { count, sum, avg, max, min } from 'drizzle-orm';

const stats = await db
  .select({
    totalProducts: count(),
    totalValue: sum(products.price),
    avgPrice: avg(products.price),
    maxPrice: max(products.price),
    minPrice: min(products.price),
  })
  .from(products);
```

### Group By with Aggregates

```typescript
const categoryStats = await db
  .select({
    category: products.category,
    count: count(),
    avgPrice: avg(products.price),
    totalStock: sum(products.stock),
  })
  .from(products)
  .groupBy(products.category);
```

### Having Clause

```typescript
const popularCategories = await db
  .select({
    category: products.category,
    productCount: count(),
  })
  .from(products)
  .groupBy(products.category)
  .having(({ productCount }) => gt(productCount, 10));
```

## Best Practices

### 1. Type Safety

Always specify types for custom SQL:

```typescript
// ✅ Good
sql<number>`count(*)`

// ❌ Avoid
sql`count(*)`  // Returns unknown
```

### 2. Null Safety

Handle optional filters properly:

```typescript
// ✅ Good
.where(
  and(
    term ? ilike(posts.title, term) : undefined,
    category ? eq(posts.category, category) : undefined,
  )
)

// ❌ Avoid - can cause issues with empty and()
.where(
  and(...filters)  // Empty array fails
)
```

### 3. Performance

Use indexes for frequently filtered columns:

```typescript
const table = pgTable('table', {
  name: text('name').notNull(),
  // ...
}, (t) => [
  index('name_idx').on(t.name),  // For ilike filters
]);
```

### 4. Sanitize Input

Never use raw user input in SQL:

```typescript
// ❌ Dangerous
.where(sql`name = '${userInput}'`)  // SQL injection risk!

// ✅ Safe
.where(eq(table.name, userInput))  // Parameterized
```
