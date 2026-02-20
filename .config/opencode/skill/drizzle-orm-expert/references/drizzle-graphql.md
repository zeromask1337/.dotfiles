# Drizzle GraphQL

Create a GraphQL server from a Drizzle schema in one line, with easy customization.

**Requirements:** `drizzle-orm@0.30.9` or higher

## Installation

```bash
npm i drizzle-orm@latest
```

## Quick Start

### Apollo Server

```bash
npm i drizzle-graphql @apollo/server graphql
```

**server.ts:**
```typescript
import { buildSchema } from 'drizzle-graphql';
import { drizzle } from 'drizzle-orm/…';
import { ApolloServer } from '@apollo/server';
import { startStandaloneServer } from '@apollo/server/standalone';

import * as dbSchema from './schema';

const db = drizzle({ client, schema: dbSchema });

const { schema } = buildSchema(db);

const server = new ApolloServer({ schema });
const { url } = await startStandaloneServer(server);

console.log(`🚀 Server ready at ${url}`);
```

**schema.ts:**
```typescript
import { integer, serial, text, pgTable } from 'drizzle-orm/pg-core';
import { relations } from 'drizzle-orm';

export const users = pgTable('users', {
  id: serial('id').primaryKey(),
  name: text('name').notNull(),
});

export const usersRelations = relations(users, ({ many }) => ({
  posts: many(posts),
}));

export const posts = pgTable('posts', {
  id: serial('id').primaryKey(),
  content: text('content').notNull(),
  authorId: integer('author_id').notNull(),
});

export const postsRelations = relations(posts, ({ one }) => ({
  author: one(users, { fields: [posts.authorId], references: [users.id] }),
}));
```

### GraphQL Yoga

```bash
npm i drizzle-graphql graphql-yoga graphql
```

**server.ts:**
```typescript
import { buildSchema } from 'drizzle-graphql';
import { drizzle } from 'drizzle-orm/…';
import { createYoga } from 'graphql-yoga';
import { createServer } from 'node:http';

import * as dbSchema from './schema';

const db = drizzle({ schema: dbSchema });

const { schema } = buildSchema(db);

const yoga = createYoga({ schema });
const server = createServer(yoga);

server.listen(4000, () => {
  console.info('Server is running on http://localhost:4000/graphql');
});
```

## Customizing Schema

The `buildSchema()` output uses standard `graphql` SDK and is compatible with any library supporting it.

Use `entities` object to build custom schema:

```typescript
import { buildSchema } from 'drizzle-graphql';
import { GraphQLList, GraphQLNonNull, GraphQLObjectType, GraphQLSchema } from 'graphql';
import { drizzle } from 'drizzle-orm/…';
import { createYoga } from 'graphql-yoga';
import { createServer } from 'node:http';

import * as dbSchema from './schema';

const db = drizzle({ schema: dbSchema });

const { entities } = buildSchema(db);

// Build custom schema
const schema = new GraphQLSchema({
  query: new GraphQLObjectType({
    name: 'Query',
    fields: {
      // Select specific queries from generated
      users: entities.queries.users,
      customer: entities.queries.customersSingle,

      // Create custom query
      customUsers: {
        type: new GraphQLList(new GraphQLNonNull(entities.types.UsersItem)),
        args: {
          where: {
            type: entities.inputs.UsersFilters
          },
        },
        resolve: async (source, args, context, info) => {
          // Custom logic
          const result = await db.select()
            .from(dbSchema.users)
            .where(...);

          return result;
        },
      },
    },
  }),
  // Customize mutations
  mutation: new GraphQLObjectType({
    name: 'Mutation',
    fields: entities.mutations,
  }),
  // Expose types for use
  types: [
    ...Object.values(entities.types),
    ...Object.values(entities.inputs)
  ],
});

const yoga = createYoga({ schema });
const server = createServer(yoga);

server.listen(4000, () => {
  console.info('Server is running on http://localhost:4000/graphql');
});
```

## Generated Schema Structure

`buildSchema()` generates:

### Types

- Table types (e.g., `UsersItem`, `PostsItem`)
- Filter input types (e.g., `UsersFilters`, `PostsFilters`)
- Order by enums

### Queries

- `tableName`: Get single item by primary key
- `tableNameSingle`: Get single item with filters
- `tableNameMany`: Get list with pagination, filters, ordering

### Mutations

- `insertIntoTableName`: Insert single item
- `insertIntoTableNameValues`: Insert multiple items
- `updateTableName`: Update items
- `deleteFromTableName`: Delete items

### Example Generated Queries

```graphql
# Get user by ID
query {
  users(id: 1) {
    id
    name
    posts {
      id
      content
    }
  }
}

# Get many users with filters
query {
  usersMany(where: { name: { ilike: "%John%" } }, orderBy: { name: ASC }) {
    id
    name
  }
}

# Get posts with author
query {
  postsMany {
    id
    content
    author {
      id
      name
    }
  }
}
```

### Example Generated Mutations

```graphql
# Insert user
mutation {
  insertIntoUsers(values: { name: "John Doe" }) {
    id
    name
  }
}

# Insert multiple users
mutation {
  insertIntoUsersValues(values: [
    { name: "John" },
    { name: "Jane" }
  ]) {
    id
    name
  }
}

# Update user
mutation {
  updateUsers(
    set: { name: "John Updated" }
    where: { id: { eq: 1 } }
  ) {
    id
    name
  }
}

# Delete users
mutation {
  deleteFromUsers(where: { id: { eq: 1 } }) {
    id
    name
  }
}
```

## Advanced Customization

### Custom Resolvers

```typescript
const { entities } = buildSchema(db);

const schema = new GraphQLSchema({
  query: new GraphQLObjectType({
    name: 'Query',
    fields: {
      // Use generated resolver
      users: entities.queries.users,
      
      // Custom resolver with business logic
      activeUsers: {
        type: new GraphQLList(entities.types.UsersItem),
        resolve: async () => {
          return await db.select()
            .from(users)
            .where(eq(users.active, true));
        },
      },
      
      // Custom with arguments
      searchUsers: {
        type: new GraphQLList(entities.types.UsersItem),
        args: {
          query: { type: GraphQLString },
        },
        resolve: async (_, { query }) => {
          return await db.select()
            .from(users)
            .where(ilike(users.name, `%${query}%`));
        },
      },
    },
  }),
});
```

### Adding Custom Types

```typescript
import { GraphQLObjectType, GraphQLString, GraphQLInt } from 'graphql';

const DashboardStatsType = new GraphQLObjectType({
  name: 'DashboardStats',
  fields: {
    totalUsers: { type: GraphQLInt },
    totalPosts: { type: GraphQLInt },
    activeToday: { type: GraphQLInt },
  },
});

const schema = new GraphQLSchema({
  query: new GraphQLObjectType({
    name: 'Query',
    fields: {
      ...entities.queries,
      dashboardStats: {
        type: DashboardStatsType,
        resolve: async () => {
          const [users, posts, active] = await Promise.all([
            db.select({ count: count() }).from(users),
            db.select({ count: count() }).from(posts),
            db.select({ count: count() }).from(users).where(
              gt(users.lastLogin, sql`now() - interval '1 day'`)
            ),
          ]);
          
          return {
            totalUsers: users[0].count,
            totalPosts: posts[0].count,
            activeToday: active[0].count,
          };
        },
      },
    },
  }),
});
```

### Authentication & Context

```typescript
import { ApolloServer } from '@apollo/server';
import { startStandaloneServer } from '@apollo/server/standalone';

const { schema } = buildSchema(db);

const server = new ApolloServer({ schema });

const { url } = await startStandaloneServer(server, {
  context: async ({ req }) => {
    // Extract auth token
    const token = req.headers.authorization?.replace('Bearer ', '');
    
    // Verify and get user
    const user = await verifyToken(token);
    
    return { user, db };
  },
});

// Use in custom resolvers
const customSchema = new GraphQLSchema({
  query: new GraphQLObjectType({
    name: 'Query',
    fields: {
      me: {
        type: entities.types.UsersItem,
        resolve: async (_, __, context) => {
          if (!context.user) throw new Error('Not authenticated');
          
          return await context.db.query.users.findFirst({
            where: eq(users.id, context.user.id),
          });
        },
      },
    },
  }),
});
```

## Best Practices

### 1. Use Relations for Nested Data

```typescript
// schema.ts
export const users = pgTable('users', {
  id: serial('id').primaryKey(),
  name: text('name').notNull(),
});

export const usersRelations = relations(users, ({ many }) => ({
  posts: many(posts),
  comments: many(comments),
}));

// Generated GraphQL allows:
query {
  users(id: 1) {
    id
    name
    posts { id content }
    comments { id text }
  }
}
```

### 2. Combine with Validation

```typescript
import { z } from 'zod';

const CreateUserInput = z.object({
  name: z.string().min(2),
  email: z.string().email(),
});

const schema = new GraphQLSchema({
  mutation: new GraphQLObjectType({
    name: 'Mutation',
    fields: {
      createUser: {
        type: entities.types.UsersItem,
        args: {
          input: { type: entities.inputs.UsersInsertInput },
        },
        resolve: async (_, { input }) => {
          // Validate input
          const validated = CreateUserInput.parse(input);
          
          return await db.insert(users).values(validated).returning();
        },
      },
    },
  }),
});
```

### 3. Add Pagination

```typescript
query {
  usersMany(
    limit: 10
    offset: 20
    orderBy: { createdAt: DESC }
  ) {
    id
    name
  }
}
```

### 4. Use Transactions for Complex Mutations

```typescript
const schema = new GraphQLSchema({
  mutation: new GraphQLObjectType({
    name: 'Mutation',
    fields: {
      createPostWithTags: {
        type: entities.types.PostsItem,
        args: {
          post: { type: entities.inputs.PostsInsertInput },
          tags: { type: new GraphQLList(GraphQLString) },
        },
        resolve: async (_, { post, tags }) => {
          return await db.transaction(async (tx) => {
            // Insert post
            const [newPost] = await tx.insert(posts).values(post).returning();
            
            // Insert tags
            if (tags?.length) {
              const tagRecords = tags.map(name => ({ name }));
              await tx.insert(tagsTable).values(tagRecords);
            }
            
            return newPost;
          });
        },
      },
    },
  }),
});
```
