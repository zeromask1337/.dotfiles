# Row-Level Security (RLS)

Row-Level Security enables fine-grained access control at the row level in PostgreSQL.

**Supported providers:** Neon, Supabase, and any PostgreSQL database.

## Enable RLS

### Modern API (v1.0.0-beta.1+)

```typescript
import { integer, pgTable } from 'drizzle-orm/pg-core';

export const users = pgTable.withRLS('users', {
  id: integer(),
});
```

### Legacy API (deprecated)

```typescript
export const users = pgTable('users', {
  id: integer(),
}).enableRLS();
```

**Note:** Adding a policy to a table automatically enables RLS.

## Roles

Define database roles with specific permissions:

```typescript
import { pgRole } from 'drizzle-orm/pg-core';

// Create new role
export const admin = pgRole('admin', { 
  createRole: true, 
  createDb: true, 
  inherit: true 
});

// Reference existing role
export const existingAdmin = pgRole('admin').existing();
```

## Policies

Policies define access rules for tables.

### Basic Policy

```typescript
import { sql } from 'drizzle-orm';
import { integer, pgPolicy, pgRole, pgTable } from 'drizzle-orm/pg-core';

export const admin = pgRole('admin');

export const users = pgTable('users', {
  id: integer(),
}, (t) => [
  pgPolicy('policy', {
    as: 'permissive',
    to: admin,
    for: 'delete',
    using: sql``,
    withCheck: sql``,
  }),
]);
```

### Policy Options

| Option | Description |
|--------|-------------|
| `as` | `permissive` or `restrictive` |
| `to` | Role: `public`, `current_role`, `current_user`, `session_user`, or role name |
| `for` | Command: `all`, `select`, `insert`, `update`, `delete` |
| `using` | SQL for `USING` clause (checks existing rows) |
| `withCheck` | SQL for `WITH CHECK` clause (checks new rows) |

### Link to Existing Table

Add policy to provider-managed tables:

```typescript
import { sql } from "drizzle-orm";
import { pgPolicy } from "drizzle-orm/pg-core";
import { authenticatedRole, realtimeMessages } from "drizzle-orm/supabase";

export const policy = pgPolicy("authenticated role insert policy", {
  for: "insert",
  to: authenticatedRole,
  using: sql``,
}).link(realtimeMessages);
```

## Configuration

Enable role management in `drizzle.config.ts`:

```typescript
import { defineConfig } from "drizzle-kit";

export default defineConfig({
  dialect: 'postgresql',
  schema: "./drizzle/schema.ts",
  dbCredentials: {
    url: process.env.DATABASE_URL!
  },
  entities: {
    roles: true  // Enable role management
  }
});
```

### Exclude Specific Roles

```typescript
export default defineConfig({
  ...
  entities: {
    roles: {
      exclude: ['admin']
    }
  }
});
```

### Include Specific Roles

```typescript
export default defineConfig({
  ...
  entities: {
    roles: {
      include: ['admin']
    }
  }
});
```

### Provider-Specific Roles

**Neon:**
```typescript
export default defineConfig({
  ...
  entities: {
    roles: {
      provider: 'neon'
    }
  }
});
```

**Supabase:**
```typescript
export default defineConfig({
  ...
  entities: {
    roles: {
      provider: 'supabase',
      exclude: ['new_supabase_role']  // Exclude additional roles
    }
  }
});
```

## RLS on Views

Enable RLS on views using `security_invoker`:

```typescript
import { getColumns } from 'drizzle-orm';

export const roomsUsersProfiles = pgView("rooms_users_profiles")
  .with({
    securityInvoker: true,
  })
  .as((qb) =>
    qb
      .select({
        ...getColumns(roomsUsers),
        email: profiles.email,
      })
      .from(roomsUsers)
      .innerJoin(profiles, eq(roomsUsers.userId, profiles.id))
  );
```

## Neon Integration

Use `crudPolicy` for simplified policy creation:

```typescript
import { crudPolicy } from 'drizzle-orm/neon';
import { integer, pgRole, pgTable } from 'drizzle-orm/pg-core';

export const admin = pgRole('admin');

export const users = pgTable('users', {
  id: integer(),
}, (t) => [
  crudPolicy({ role: admin, read: true, modify: false }),
]);
```

Equivalent to:

```typescript
pgPolicy(`crud-${admin.name}-policy-insert`, {
  for: 'insert',
  to: admin,
  withCheck: sql`false`,
}),
pgPolicy(`crud-${admin.name}-policy-update`, {
  for: 'update',
  to: admin,
  using: sql`false`,
  withCheck: sql`false`,
}),
pgPolicy(`crud-${admin.name}-policy-delete`, {
  for: 'delete',
  to: admin,
  using: sql`false`,
}),
pgPolicy(`crud-${admin.name}-policy-select`, {
  for: 'select',
  to: admin,
  using: sql`true`,
}),
```

### Predefined Neon Roles and Functions

```typescript
import { authenticatedRole, anonymousRole, authUid, usersSync } from 'drizzle-orm/neon';

// Use in policies
export const users = pgTable('users', {
  id: integer(),
}, (t) => [
  pgPolicy('policy-insert', {
    for: 'insert',
    to: authenticatedRole,
    withCheck: sql`false`,
  }),
]);

// Check user ownership
const isOwner = authUid(users.id);  // (select auth.user_id() = users.id)
```

## Supabase Integration

### Predefined Roles

```typescript
import { 
  anonRole, 
  authenticatedRole, 
  serviceRole, 
  postgresRole, 
  supabaseAuthAdminRole 
} from 'drizzle-orm/supabase';
```

### Predefined Tables and Functions

```typescript
import { authUsers, realtimeMessages, authUid, realtimeTopic } from 'drizzle-orm/supabase';

// Reference auth.users table
foreignKey({
  columns: [table.id],
  foreignColumns: [authUsers.id],  // Reference to Supabase auth table
  name: "profiles_id_fk",
}).onDelete("cascade"),
```

### Complete Supabase Example

```typescript
import { foreignKey, pgPolicy, pgTable, text, uuid } from "drizzle-orm/pg-core";
import { sql } from "drizzle-orm/sql";
import { authenticatedRole, authUsers } from "drizzle-orm/supabase";

export const profiles = pgTable(
  "profiles",
  {
    id: uuid().primaryKey().notNull(),
    email: text().notNull(),
  },
  (table) => [
    foreignKey({
      columns: [table.id],
      foreignColumns: [authUsers.id],
      name: "profiles_id_fk",
    }).onDelete("cascade"),
    pgPolicy("authenticated can view all profiles", {
      for: "select",
      to: authenticatedRole,
      using: sql`true`,
    }),
  ]
);

// Add policy to existing Supabase table
export const policy = pgPolicy("authenticated role insert policy", {
  for: "insert",
  to: authenticatedRole,
  using: sql``,
}).link(realtimeMessages);
```

### Transaction Wrapper for Supabase

```typescript
type SupabaseToken = {
  iss?: string;
  sub?: string;
  aud?: string[] | string;
  exp?: number;
  nbf?: number;
  iat?: number;
  jti?: string;
  role?: string;
};

export function createDrizzle(
  token: SupabaseToken, 
  { admin, client }: { admin: PgDatabase<any>; client: PgDatabase<any> }
) {
  return {
    admin,
    rls: (async (transaction, ...rest) => {
      return await client.transaction(async (tx) => {
        try {
          // Set JWT claims
          await tx.execute(sql`
            select set_config('request.jwt.claims', '${sql.raw(
              JSON.stringify(token)
            )}', TRUE);
          `);
          
          // Set user ID
          await tx.execute(sql`
            select set_config('request.jwt.claim.sub', '${sql.raw(
              token.sub ?? ''
            )}', TRUE);
          `);
          
          return await transaction(tx);
        } finally {
          // Cleanup
          await tx.execute(sql`select set_config('request.jwt.claims', '', TRUE)`);
          await tx.execute(sql`select set_config('request.jwt.claim.sub', '', TRUE)`);
        }
      });
    }) as typeof admin.transaction,
  };
}
```

## Common Patterns

### User-Owned Data

```typescript
export const todos = pgTable('todos', {
  id: integer(),
  userId: integer().notNull(),
  title: text().notNull(),
}, (t) => [
  pgPolicy('Users can only access their own todos', {
    for: 'all',
    to: authenticatedRole,
    using: sql`${t.userId} = auth.uid()`,
    withCheck: sql`${t.userId} = auth.uid()`,
  }),
]);
```

### Public Read, Authenticated Write

```typescript
export const posts = pgTable('posts', {
  id: integer(),
  authorId: integer().notNull(),
  title: text().notNull(),
  content: text().notNull(),
}, (t) => [
  // Anyone can read
  pgPolicy('Public read access', {
    for: 'select',
    to: 'public',
    using: sql`true`,
  }),
  // Only author can modify
  pgPolicy('Author can modify', {
    for: 'all',
    to: authenticatedRole,
    using: sql`${t.authorId} = auth.uid()`,
    withCheck: sql`${t.authorId} = auth.uid()`,
  }),
]);
```

### Admin Override

```typescript
export const sensitiveData = pgTable('sensitive_data', {
  id: integer(),
  orgId: integer().notNull(),
  data: text().notNull(),
}, (t) => [
  // Organization members can access
  pgPolicy('Org members access', {
    for: 'all',
    to: authenticatedRole,
    using: sql`
      ${t.orgId} IN (
        SELECT org_id FROM org_members 
        WHERE user_id = auth.uid()
      )
    `,
  }),
  // Admins can access all
  pgPolicy('Admin full access', {
    for: 'all',
    to: adminRole,
    using: sql`true`,
    withCheck: sql`true`,
  }),
]);
```

## Best Practices

### 1. Always Test Policies

```typescript
// Test as different users
await db.execute(sql`SET ROLE authenticated`);
const result = await db.select().from(todos);  // Should only see user's todos

await db.execute(sql`SET ROLE admin`);
const allTodos = await db.select().from(todos);  // Should see all
```

### 2. Use Restrictive for Sensitive Data

```typescript
pgPolicy('Strict org isolation', {
  as: 'restrictive',  // Cannot be bypassed
  for: 'all',
  to: 'public',
  using: sql`${table.orgId} = current_setting('app.current_org')::int`,
}),
```

### 3. Enable RLS on All Tables

```typescript
// Use a helper function
const createRLSTable = (name: string, columns: TableConfig) => {
  return pgTable.withRLS(name, columns, (t) => [
    pgPolicy('authenticated_full_access', {
      for: 'all',
      to: authenticatedRole,
      using: sql`true`,
      withCheck: sql`true`,
    }),
  ]);
};
```

### 4. Document Policies

```typescript
pgPolicy('Allow users to update own profile', {
  for: 'update',
  to: authenticatedRole,
  using: sql`id = auth.uid()`,  // Can only update own row
  withCheck: sql`id = auth.uid()`,  // Must maintain ownership
}),
```
