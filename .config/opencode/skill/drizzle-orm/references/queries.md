# Query Patterns Reference

## Import Operators

```typescript
import {
  eq, ne, gt, gte, lt, lte,
  and, or, not,
  like, ilike, notLike, notIlike,
  inArray, notInArray,
  between, notBetween,
  isNull, isNotNull,
  exists, notExists,
  sql, asc, desc
} from 'drizzle-orm';
```

## SELECT Queries

### Basic Select
```typescript
// All columns
const allUsers = await db.select().from(users);

// Specific columns
const userNames = await db.select({ name: users.name, email: users.email }).from(users);

// Count
const count = await db.select({ count: count() }).from(users);

// Distinct
const uniqueNames = await db.selectDistinct({ name: users.name }).from(users);
```

### Filtering (WHERE)
```typescript
// Equality
await db.select().from(users).where(eq(users.id, 1));

// Inequality
await db.select().from(users).where(ne(users.status, 'deleted'));

// Comparison
await db.select().from(users).where(gt(users.age, 18));
await db.select().from(users).where(gte(users.age, 18));
await db.select().from(users).where(lt(users.age, 65));
await db.select().from(users).where(lte(users.age, 65));

// AND conditions
await db.select().from(users).where(
  and(
    eq(users.status, 'active'),
    gt(users.age, 18)
  )
);

// OR conditions
await db.select().from(users).where(
  or(
    eq(users.role, 'admin'),
    eq(users.role, 'moderator')
  )
);

// Complex combinations
await db.select().from(users).where(
  and(
    eq(users.status, 'active'),
    or(
      gt(users.age, 18),
      eq(users.parentalConsent, true)
    )
  )
);

// IN / NOT IN
await db.select().from(users).where(inArray(users.role, ['admin', 'user']));
await db.select().from(users).where(notInArray(users.status, ['banned', 'deleted']));

// BETWEEN
await db.select().from(users).where(between(users.age, 18, 65));

// NULL checks
await db.select().from(users).where(isNull(users.deletedAt));
await db.select().from(users).where(isNotNull(users.emailVerified));

// LIKE / ILIKE (case-insensitive)
await db.select().from(users).where(like(users.name, '%John%'));
await db.select().from(users).where(ilike(users.email, '%@gmail.com'));

// NOT conditions
await db.select().from(users).where(not(eq(users.status, 'inactive')));
```

### Ordering
```typescript
// Ascending (default)
await db.select().from(users).orderBy(users.createdAt);

// Descending
await db.select().from(users).orderBy(desc(users.createdAt));

// Multiple columns
await db.select().from(users).orderBy(desc(users.role), asc(users.name));
```

### Pagination
```typescript
// Limit
await db.select().from(users).limit(10);

// Offset
await db.select().from(users).offset(20);

// Limit + Offset
await db.select().from(users).limit(10).offset(20);
```

## JOINs

```typescript
import { eq, and, or } from 'drizzle-orm';

// INNER JOIN
await db
  .select()
  .from(users)
  .innerJoin(posts, eq(users.id, posts.userId));

// LEFT JOIN
await db
  .select()
  .from(users)
  .leftJoin(posts, eq(users.id, posts.userId));

// RIGHT JOIN
await db
  .select()
  .from(users)
  .rightJoin(posts, eq(users.id, posts.userId));

// FULL JOIN
await db
  .select()
  .from(users)
  .fullJoin(posts, eq(users.id, posts.userId));

// Multiple JOINs
await db
  .select()
  .from(users)
  .leftJoin(posts, eq(users.id, posts.userId))
  .leftJoin(comments, eq(posts.id, comments.postId));

// JOIN with aliases
const author = alias(users, 'author');
await db
  .select()
  .from(posts)
  .leftJoin(author, eq(author.id, posts.authorId));

// Complex JOIN conditions
await db
  .select()
  .from(users)
  .leftJoin(
    posts,
    and(
      eq(users.id, posts.userId),
      eq(posts.published, true)
    )
  );
```

## Aggregations

```typescript
import { count, sum, avg, max, min, sql } from 'drizzle-orm';

// Count all
await db.select({ count: count() }).from(users);

// Count specific column
await db.select({ count: count(users.id) }).from(users);

// Count distinct
await db.select({ count: countDistinct(users.country) }).from(users);

// SUM
await db.select({ total: sum(orders.amount) }).from(orders);

// AVG
await db.select({ average: avg(ratings.value) }).from(ratings);

// MIN / MAX
await db.select({ earliest: min(users.createdAt) }).from(users);
await db.select({ latest: max(users.createdAt) }).from(users);

// GROUP BY with aggregations
await db
  .select({
    role: users.role,
    count: count(),
    avgAge: avg(users.age),
  })
  .from(users)
  .groupBy(users.role);

// HAVING
await db
  .select({
    role: users.role,
    count: count(),
  })
  .from(users)
  .groupBy(users.role)
  .having(({ count }) => gt(count, 5));
```

## Subqueries

```typescript
// Subquery in WHERE with EXISTS
await db
  .select()
  .from(users)
  .where(
    exists(
      db.select().from(posts).where(eq(posts.userId, users.id))
    )
  );

// Subquery in SELECT
await db
  .select({
    id: users.id,
    name: users.name,
    postCount: sql<number>`(select count(*) from ${posts} where ${posts.userId} = ${users.id})`,
  })
  .from(users);

// Subquery in FROM
const subquery = db.select().from(users).where(eq(users.active, true)).as('active_users');
await db.select().from(subquery);
```

## WITH Clauses (CTEs)

```typescript
// Simple CTE
const cte = db.$with('cte').as(
  db.select().from(users).where(eq(users.active, true))
);
await db.with(cte).select().from(cte);

// Multiple CTEs
const activeUsers = db.$with('active_users').as(
  db.select().from(users).where(eq(users.active, true))
);
const userStats = db.$with('user_stats').as(
  db
    .select({ userId: posts.userId, count: count() })
    .from(posts)
    .groupBy(posts.userId)
);

await db
  .with(activeUsers, userStats)
  .select()
  .from(activeUsers)
  .leftJoin(userStats, eq(userStats.userId, activeUsers.id));

// Recursive CTE
const recursiveCte = db.$with('tree', { recursive: true }).as(
  db
    .select({ id: categories.id, name: categories.name, depth: sql<number>`1` })
    .from(categories)
    .where(isNull(categories.parentId))
    .unionAll(
      db
        .select({
          id: categories.id,
          name: categories.name,
          depth: sql`${recursiveCte.depth} + 1`,
        })
        .from(categories)
        .innerJoin(recursiveCte, eq(categories.parentId, recursiveCte.id))
    )
);
```

## INSERT

```typescript
// Single row
await db.insert(users).values({ name: 'John', email: 'john@example.com' });

// Multiple rows
await db.insert(users).values([
  { name: 'John', email: 'john@example.com' },
  { name: 'Jane', email: 'jane@example.com' },
]);

// Insert with returning (PostgreSQL)
const newUser = await db
  .insert(users)
  .values({ name: 'John', email: 'john@example.com' })
  .returning();

// Insert returning specific columns
const inserted = await db
  .insert(users)
  .values({ name: 'John', email: 'john@example.com' })
  .returning({ id: users.id, name: users.name });

// Insert from select
await db.insert(users).select(db.select().from(oldUsers));

// On conflict / Upsert (PostgreSQL)
await db
  .insert(users)
  .values({ id: 1, name: 'John', email: 'john@example.com' })
  .onConflictDoUpdate({
    target: users.id,
    set: { name: 'John Updated' },
  });

// On conflict do nothing
await db
  .insert(users)
  .values({ id: 1, name: 'John', email: 'john@example.com' })
  .onConflictDoNothing();
```

## UPDATE

```typescript
// Simple update
await db
  .update(users)
  .set({ name: 'John Updated' })
  .where(eq(users.id, 1));

// Update multiple columns
await db
  .update(users)
  .set({ name: 'John', email: 'new@example.com' })
  .where(eq(users.id, 1));

// Update with returning (PostgreSQL)
const updated = await db
  .update(users)
  .set({ name: 'John' })
  .where(eq(users.id, 1))
  .returning();

// Update from another table
await db
  .update(users)
  .set({ lastLogin: sql`CURRENT_TIMESTAMP` })
  .where(inArray(users.id, db.select({ id: userLogins.userId }).from(userLogins)));
```

## DELETE

```typescript
// Simple delete
await db.delete(users).where(eq(users.id, 1));

// Delete with returning (PostgreSQL)
const deleted = await db.delete(users).where(eq(users.id, 1)).returning();

// Delete all (be careful!)
await db.delete(users);
```

## Relational Queries

```typescript
// Enable relations in schema
import { relations } from 'drizzle-orm';

export const usersRelations = relations(users, ({ many, one }) => ({
  posts: many(posts),
  profile: one(profiles, {
    fields: [users.id],
    references: [profiles.userId],
  }),
}));

export const postsRelations = relations(posts, ({ one, many }) => ({
  user: one(users, {
    fields: [posts.userId],
    references: [users.id],
  }),
  comments: many(comments),
}));

// Find one with relations
const user = await db.query.users.findFirst({
  where: eq(users.id, 1),
  with: {
    posts: true,
    profile: true,
  },
});

// Find many with relations
const allUsers = await db.query.users.findMany({
  with: {
    posts: {
      with: {
        comments: true,
      },
    },
  },
});

// With column selection
const usersWithPosts = await db.query.users.findMany({
  columns: {
    id: true,
    name: true,
  },
  with: {
    posts: {
      columns: {
        title: true,
        published: true,
      },
    },
  },
});

// With where on relations
const usersWithPublishedPosts = await db.query.users.findMany({
  with: {
    posts: {
      where: eq(posts.published, true),
    },
  },
});

// With orderBy on relations
const usersWithOrderedPosts = await db.query.users.findMany({
  with: {
    posts: {
      orderBy: desc(posts.createdAt),
    },
  },
});

// With limit on relations
const usersWithLimitedPosts = await db.query.users.findMany({
  with: {
    posts: {
      limit: 5,
      orderBy: desc(posts.createdAt),
    },
  },
});

// Extras (computed fields)
const usersWithExtras = await db.query.users.findMany({
  extras: {
    lowerCaseName: sql<string>`lower(${users.name})`.as('lower_case_name'),
  },
});
```

## Dynamic Query Building

```typescript
// Enable dynamic mode with .$dynamic()
function withPagination<T extends PgSelect>(
  qb: T,
  page: number = 1,
  pageSize: number = 10
) {
  return qb.limit(pageSize).offset((page - 1) * pageSize);
}

function withFilter<T extends PgSelect>(qb: T, search?: string) {
  if (!search) return qb;
  return qb.where(ilike(users.name, `%${search}%`));
}

// Build query dynamically
let query = db.select().from(users).$dynamic();
query = withFilter(query, searchTerm);
query = withPagination(query, page, pageSize);

const results = await query;

// Conditional building
function buildUserQuery(filters: { name?: string; email?: string; active?: boolean }) {
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

  return query;
}
```

## Prepared Statements

```typescript
// Prepare a query for reuse
const getUserById = db
  .select()
  .from(users)
  .where(eq(users.id, sql.placeholder('id')))
  .prepare('get_user_by_id');

// Execute multiple times
const user1 = await getUserById.execute({ id: 1 });
const user2 = await getUserById.execute({ id: 2 });

// Prepared insert
const insertUser = db
  .insert(users)
  .values({
    name: sql.placeholder('name'),
    email: sql.placeholder('email'),
  })
  .prepare('insert_user');

await insertUser.execute({ name: 'John', email: 'john@example.com' });
```

## Raw SQL

```typescript
import { sql } from 'drizzle-orm';

// Execute raw query
await db.execute(sql`SELECT * FROM users WHERE id = ${userId}`);

// SQL in select
await db
  .select({
    id: users.id,
    name: users.name,
    upperName: sql<string>`upper(${users.name})`,
  })
  .from(users);

// SQL in where
await db
  .select()
  .from(users)
  .where(sql`${users.createdAt} > NOW() - INTERVAL '7 days'`);

// SQL template with conditions
const tableName = 'users';
await db.execute(sql`SELECT * FROM ${sql.identifier(tableName)}`);

// Raw values
await db.execute(sql`SELECT * FROM users WHERE id = ${sql.raw(userId)}`);

// Join SQL fragments
const baseQuery = sql`SELECT * FROM users`;
const whereClause = sql`WHERE active = true`;
await db.execute(sql`${baseQuery} ${whereClause}`);
```
