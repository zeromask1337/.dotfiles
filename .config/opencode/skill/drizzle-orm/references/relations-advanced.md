# Advanced Relations (v2)

**Requirements:** `drizzle-orm@1.0.0-beta.1` or higher

The new relations API uses `defineRelations()` for declarative, type-safe relational queries.

## Quick Start

```typescript
import { drizzle } from 'drizzle-orm/…';
import { defineRelations } from 'drizzle-orm';
import * as p from 'drizzle-orm/pg-core';

// Define schema
export const users = p.pgTable('users', {
  id: p.integer().primaryKey(),
  name: p.text().notNull()
});

export const posts = p.pgTable('posts', {
  id: p.integer().primaryKey(),
  content: p.text().notNull(),
  ownerId: p.integer('owner_id'),
});

// Define relations
const relations = defineRelations({ users, posts }, (r) => ({
  posts: {
    author: r.one.users({
      from: r.posts.ownerId,
      to: r.users.id,
    }),
  }
}))

// Use with drizzle
const db = drizzle(client, { relations });

// Query with relations
const result = db.query.posts.findMany({
  with: {
    author: true,
  },
});
```

Result:
```typescript
[{
  id: 10,
  content: "My first post!",
  author: {
    id: 1,
    name: "Alex"
  }
}]
```

## One-to-One Relations

### Self-Referencing (User Invites User)

```typescript
export const users = pgTable('users', {
  id: integer().primaryKey(),
  name: text(),
  invitedBy: integer('invited_by'),
});

export const relations = defineRelations({ users }, (r) => ({
  users: {
    invitee: r.one.users({
      from: r.users.invitedBy,
      to: r.users.id,
    })
  }
}));
```

### User to Profile (Separate Tables)

```typescript
export const users = pgTable('users', {
  id: integer().primaryKey(),
  name: text(),
});

export const profileInfo = pgTable('profile_info', {
  id: serial().primaryKey(),
  userId: integer('user_id').references(() => users.id),
  metadata: jsonb(),
});

export const relations = defineRelations({ users, profileInfo }, (r) => ({
  users: {
    profileInfo: r.one.profileInfo({
      from: r.users.id,
      to: r.profileInfo.userId,
    })
  }
}));

// Result type: { id: number, profileInfo: { ... } | null }
const user = await db.query.users.findFirst({ 
  with: { profileInfo: true } 
});
```

## One-to-Many Relations

```typescript
export const users = pgTable('users', {
  id: integer('id').primaryKey(),
  name: text('name'),
});

export const posts = pgTable('posts', {
  id: integer('id').primaryKey(),
  content: text('content'),
  authorId: integer('author_id'),
});

export const relations = defineRelations({ users, posts }, (r) => ({
  posts: {
    author: r.one.users({
      from: r.posts.authorId,
      to: r.users.id,
    }),
  },
  users: {
    posts: r.many.posts(),
  },
}));
```

### With Comments (Nested Relations)

```typescript
export const comments = pgTable("comments", {
  id: integer().primaryKey(),
  text: text(),
  authorId: integer("author_id"),
  postId: integer("post_id"),
});

export const relations = defineRelations({ users, posts, comments }, (r) => ({
  posts: {
    author: r.one.users({
      from: r.posts.authorId,
      to: r.users.id,
    }),
    comments: r.many.comments(),
  },
  users: {
    posts: r.many.posts(),
  },
  comments: {
    post: r.one.posts({
      from: r.comments.postId,
      to: r.posts.id,
    }),
  },
}));
```

## Many-to-Many Relations

Use `through()` to bypass junction tables:

```typescript
export const users = pgTable('users', {
  id: integer().primaryKey(),
  name: text(),
});

export const groups = pgTable('groups', {
  id: integer().primaryKey(),
  name: text(),
});

export const usersToGroups = pgTable(
  'users_to_groups',
  {
    userId: integer('user_id')
      .notNull()
      .references(() => users.id),
    groupId: integer('group_id')
      .notNull()
      .references(() => groups.id),
  },
  (t) => [primaryKey({ columns: [t.userId, t.groupId] })],
);

export const relations = defineRelations({ users, groups, usersToGroups },
  (r) => ({
    users: {
      groups: r.many.groups({
        from: r.users.id.through(r.usersToGroups.userId),
        to: r.groups.id.through(r.usersToGroups.groupId),
      }),
    },
    groups: {
      participants: r.many.users(),
    },
  })
);
```

Query:
```typescript
const res = await db.query.users.findMany({
  with: { 
    groups: true 
  },
});

// Response type
{
  id: number;
  name: string | null;
  groups: {
    id: number;
    name: string | null;
  }[];
}[]
```

## Relation Configuration

### One() Configuration

```typescript
const relations = defineRelations({ users, posts }, (r) => ({
  posts: {
    author: r.one.users({
      from: r.posts.ownerId,
      to: r.users.id,
      optional: false,          // Make required (default: true)
      alias: 'custom_name',     // Differentiate multiple relations
      where: {                  // Polymorphic filter
        verified: true,
      }
    }),
  }
}))
```

| Option | Description |
|--------|-------------|
| `from` | Source table and column for the relation |
| `to` | Target table and column for the relation |
| `optional` | When `false`, makes relation required at type level |
| `alias` | Differentiate multiple relations between same tables |
| `where` | Filter condition for polymorphic relations |

### Many() Configuration

```typescript
const relations = defineRelations({ users, posts }, (r) => ({
  users: {
    feed: r.many.posts({
      from: r.users.id,
      to: r.posts.ownerId,
      optional: false,
      alias: 'custom_name',
      where: {
        approved: true,
      }
    }),
  }
}))
```

## Polymorphic Relations with Filters

Get only verified users in a group:

```typescript
export const relations = defineRelations(schema,(r) => ({
    groups: {
      verifiedUsers: r.many.users({
        from: r.groups.id.through(r.usersToGroups.groupId),
        to: r.users.id.through(r.usersToGroups.userId),
        where: {
          verified: true,
        },
      }),
    },
  })
);

await db.query.groups.findMany({
    with: {
      verifiedUsers: true,
    },
});
```

**Note:** Filters only apply to target (to) table columns.

## Separating Relations into Parts

Use `defineRelationsPart` for modular relations:

```typescript
import { defineRelations, defineRelationsPart } from 'drizzle-orm';
import * as schema from "./schema";

// Main relations
export const relations = defineRelations(schema, (r) => ({
  users: {
    invitee: r.one.users({
      from: r.users.invitedBy,
      to: r.users.id,
    }),
    posts: r.many.posts(),
  }
}));

// Separate part
export const part = defineRelationsPart(schema, (r) => ({
  posts: {
    author: r.one.users({
      from: r.posts.authorId,
      to: r.users.id,
    }),
  }
}));

// Combine
const db = drizzle(process.env.DB_URL, { 
  relations: { ...relations, ...part } 
})
```

## Comparison: Relations vs Joins

### Relations Approach
```typescript
const relations = defineRelations({ users, posts }, (r) => ({
  posts: {
    author: r.one.users({
      from: r.posts.ownerId,
      to: r.users.id,
    }),
  },
}));

const db = drizzle(client, { relations });

const result = await db.query.posts.findMany({
  with: { author: true },
});

// Result: [{ id, content, author: { id, name } }]
```

### Joins Approach
```typescript
const db = drizzle(client);

const res = await db.select()
  .from(posts)
  .leftJoin(users, eq(posts.ownerId, users.id));

// Manual mapping required
const mappedResult = res.map(row => ({
  ...row.posts,
  author: row.users
}));
```

## Migration from v1

### v1 (Old)
```typescript
import { relations } from 'drizzle-orm';

export const usersRelations = relations(users, ({ many, one }) => ({
  posts: many(posts),
  profile: one(profiles, {
    fields: [users.id],
    references: [profiles.userId],
  }),
}));
```

### v2 (New)
```typescript
import { defineRelations } from 'drizzle-orm';

export const relations = defineRelations({ users, profiles, posts }, (r) => ({
  users: {
    posts: r.many.posts(),
    profile: r.one.profiles({
      from: r.users.id,
      to: r.profiles.userId,
    }),
  },
}));
```

Key differences:
- `relations()` → `defineRelations()`
- `one()`/`many()` params → `r.one.table()`/`r.many.table()`
- `fields`/`references` → `from`/`to`
- No separate `relations` files needed - define in one place
