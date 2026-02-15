# Drizzle Extension for Prisma

Use Drizzle ORM alongside your existing Prisma project, reusing your database connection.

## When to Use

- Gradually migrate from Prisma to Drizzle
- Try Drizzle in an existing Prisma project
- Access Drizzle's SQL-like query API while keeping Prisma

## How to Use

### 1. Install Dependencies

```bash
npm i drizzle-orm@latest
npm i -D drizzle-prisma-generator
```

### 2. Update Prisma Schema

Add Drizzle generator to your `schema.prisma`:

```prisma
// schema.prisma
generator client {
  provider = "prisma-client-js"
}

// Add this generator
 generator drizzle {
  provider = "drizzle-prisma-generator"
  output   = "./drizzle"  // Where to put generated Drizzle tables
}

datasource db {
  provider = "postgresql"
  url      = env("DB_URL")
}

model User {
  id    Int     @id @default(autoincrement())
  email String  @unique
  name  String?
}

// ... rest of your models
```

### 3. Generate Drizzle Schema

```bash
prisma generate
```

This creates Drizzle table definitions in `./drizzle` folder.

### 4. Add Drizzle Extension to Prisma Client

**PostgreSQL:**
```typescript
import { PrismaClient } from '@prisma/client';
import { drizzle } from 'drizzle-orm/prisma/pg';

const prisma = new PrismaClient().$extends(drizzle());
```

**MySQL:**
```typescript
import { PrismaClient } from '@prisma/client';
import { drizzle } from 'drizzle-orm/prisma/mysql';

const prisma = new PrismaClient().$extends(drizzle());
```

**SQLite:**
```typescript
import { PrismaClient } from '@prisma/client';
import { drizzle } from 'drizzle-orm/prisma/sqlite';

const prisma = new PrismaClient().$extends(drizzle());
```

### 5. Run Drizzle Queries via `prisma.$drizzle`

Import Drizzle tables from the generated output path:

```typescript
import { User } from './drizzle';

// Insert with Drizzle
await prisma.$drizzle.insert().into(User).values({
  email: 'sorenbs@drizzle.team',
  name: 'Søren'
});

// Select with Drizzle
const users = await prisma.$drizzle.select().from(User);

// Use Drizzle's SQL-like syntax
const activeUsers = await prisma.$drizzle
  .select()
  .from(User)
  .where(eq(User.active, true));
```

## Complete Example

```typescript
import { PrismaClient } from '@prisma/client';
import { drizzle } from 'drizzle-orm/prisma/pg';
import { eq, like } from 'drizzle-orm';
import { User, Post } from './drizzle';

const prisma = new PrismaClient().$extends(drizzle());

async function main() {
  // Prisma query
  const prismaUsers = await prisma.user.findMany({
    where: { email: { contains: '@drizzle.team' } },
  });

  // Drizzle query on same connection
  const drizzleUsers = await prisma.$drizzle
    .select()
    .from(User)
    .where(like(User.email, '%@drizzle.team%'));

  // Drizzle insert
  await prisma.$drizzle.insert().into(User).values({
    email: 'new@example.com',
    name: 'New User',
  });

  // Drizzle with joins
  const usersWithPosts = await prisma.$drizzle
    .select()
    .from(User)
    .leftJoin(Post, eq(User.id, Post.authorId));

  console.log({ prismaUsers, drizzleUsers, usersWithPosts });
}

main();
```

## Limitations

### 1. Relational Queries Not Supported

Due to a [Prisma driver limitation](https://github.com/prisma/prisma/issues/17576), relational queries (`with`) don't work because Prisma can't return results in array format.

```typescript
// ❌ Not supported
await prisma.$drizzle.query.users.findMany({
  with: {
    posts: true,  // This won't work
  },
});

// ✅ Use joins instead
await prisma.$drizzle
  .select()
  .from(User)
  .leftJoin(Post, eq(User.id, Post.authorId));
```

### 2. SQLite `.values()` Not Supported

```typescript
// ❌ Not supported in SQLite
await prisma.$drizzle.select().from(User).values();

// ✅ Use standard select
await prisma.$drizzle.select().from(User);
```

### 3. Limited Prepared Statement Support

`.prepare()` only builds SQL on Drizzle side - no Prisma API for true prepared queries:

```typescript
// ⚠️ Limited: only builds SQL, doesn't use Prisma prepared statements
const prepared = await prisma.$drizzle
  .select()
  .from(User)
  .where(eq(User.id, sql.placeholder('id')))
  .prepare();
```

## Use Cases

### 1. Gradual Migration

Move queries from Prisma to Drizzle one at a time:

```typescript
// Before: Prisma
const user = await prisma.user.findUnique({
  where: { id: userId },
  include: { posts: true },
});

// After: Drizzle
const user = await prisma.$drizzle
  .select()
  .from(User)
  .where(eq(User.id, userId));

const posts = await prisma.$drizzle
  .select()
  .from(Post)
  .where(eq(Post.authorId, userId));
```

### 2. Complex Queries

Use Drizzle for SQL-heavy operations:

```typescript
// Complex aggregation with Drizzle
const stats = await prisma.$drizzle
  .select({
    month: sql<string>`date_trunc('month', ${Post.createdAt})`,
    count: sql<number>`count(*)`,
    avgViews: sql<number>`avg(${Post.views})`,
  })
  .from(Post)
  .groupBy(sql`date_trunc('month', ${Post.createdAt})`);
```

### 3. Raw SQL When Needed

```typescript
// Use Drizzle's sql template
const result = await prisma.$drizzle.execute(
  sql`SELECT * FROM users WHERE email LIKE ${'%@example.com%'}`
);
```

## Best Practices

### 1. Keep Prisma for Simple CRUD

```typescript
// Simple operations: use Prisma
const user = await prisma.user.create({
  data: { email, name },
});

// Complex SQL: use Drizzle
const report = await prisma.$drizzle
  .select({
    userId: User.id,
    postCount: sql<number>`count(${Post.id})`,
  })
  .from(User)
  .leftJoin(Post, eq(User.id, Post.authorId))
  .groupBy(User.id);
```

### 2. Share Transaction Logic

```typescript
// Use Prisma transactions for Prisma + Drizzle mix
await prisma.$transaction(async (tx) => {
  // Prisma operation
  await tx.user.update({
    where: { id: userId },
    data: { lastLogin: new Date() },
  });

  // Drizzle operation on same transaction
  await prisma.$drizzle
    .insert()
    .into(LoginEvent)
    .values({ userId, timestamp: new Date() });
});
```

### 3. Type Safety

Generated Drizzle types match your Prisma schema:

```typescript
import { User } from './drizzle';

// Full type safety
const newUser: typeof User.$inferInsert = {
  email: 'test@example.com',
  name: 'Test',
};

await prisma.$drizzle.insert().into(User).values(newUser);
```

### 4. Generator Configuration

Customize output location:

```prisma
 generator drizzle {
  provider = "drizzle-prisma-generator"
  output   = "./src/db/drizzle"  // Custom path
}
```

Regenerate after Prisma schema changes:

```bash
prisma generate
```

## Comparison: Prisma vs Drizzle Syntax

### Select

```typescript
// Prisma
const users = await prisma.user.findMany({
  where: { active: true },
  select: { id: true, email: true },
});

// Drizzle
const users = await prisma.$drizzle
  .select({ id: User.id, email: User.email })
  .from(User)
  .where(eq(User.active, true));
```

### Insert

```typescript
// Prisma
await prisma.user.create({
  data: { email: 'test@example.com', name: 'Test' },
});

// Drizzle
await prisma.$drizzle
  .insert()
  .into(User)
  .values({ email: 'test@example.com', name: 'Test' });
```

### Update

```typescript
// Prisma
await prisma.user.update({
  where: { id: 1 },
  data: { name: 'Updated' },
});

// Drizzle
await prisma.$drizzle
  .update(User)
  .set({ name: 'Updated' })
  .where(eq(User.id, 1));
```

### Delete

```typescript
// Prisma
await prisma.user.delete({
  where: { id: 1 },
});

// Drizzle
await prisma.$drizzle
  .delete(User)
  .where(eq(User.id, 1));
```

## Migration Path

### Phase 1: Add Drizzle Extension

1. Install dependencies
2. Add generator to Prisma schema
3. Generate Drizzle types
4. Start using `prisma.$drizzle` for new queries

### Phase 2: Migrate Complex Queries

Move complex aggregations and SQL-heavy operations to Drizzle:

```typescript
// Migrate from Prisma raw queries
const result = await prisma.$queryRaw`SELECT ...`;

// To Drizzle typed queries
const result = await prisma.$drizzle.select()...;
```

### Phase 3: Full Migration (Optional)

When ready, completely switch to Drizzle:

```typescript
// Replace Prisma client entirely
import { drizzle } from 'drizzle-orm/node-postgres';
import { Pool } from 'pg';

const pool = new Pool({ connectionString: process.env.DATABASE_URL });
const db = drizzle(pool, { schema: drizzleSchema });
```
