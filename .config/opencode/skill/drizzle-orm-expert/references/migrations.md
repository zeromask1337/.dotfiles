# Migrations & Drizzle Kit Reference

## Configuration File

### Basic Config
```typescript
// drizzle.config.ts
import { defineConfig } from 'drizzle-kit';

export default defineConfig({
  dialect: 'postgresql', // 'postgresql' | 'mysql' | 'sqlite' | 'turso' | 'singlestore' | 'mssql'
  schema: './src/schema.ts',
  out: './drizzle',
});
```

### Full Config Options
```typescript
import { defineConfig } from 'drizzle-kit';

export default defineConfig({
  // Required
  dialect: 'postgresql',
  schema: './src/schema.ts',
  
  // Optional
  out: './drizzle',              // Migrations output folder
  
  // Database credentials (one of these)
  dbCredentials: {
    url: process.env.DATABASE_URL!,           // Connection string
    // OR
    host: 'localhost',
    port: 5432,
    user: 'postgres',
    password: 'password',
    database: 'mydb',
  },
  
  // For specific drivers
  driver: 'pglite', // 'pglite' | 'aws-data-api' | 'd1-http' | 'expo' | 'op-sqlite' | 'sqlite' | 'turso' | 'web-worker'
  
  // Schema filtering
  schemaFilter: 'public',        // Schema to use (PostgreSQL)
  tablesFilter: '*',            // Table filter pattern
  
  // Extensions (PostgreSQL)
  extensionsFilters: ['postgis'], // Filter which extensions to introspect
  
  // Introspection options
  introspect: {
    casing: 'camel',            // 'camel' | 'preserve'
  },
  
  // Migration options
  migrations: {
    prefix: 'timestamp',        // 'timestamp' | 'index' | 'supabase'
    table: '__drizzle_migrations__', // Migrations tracking table
    schema: 'public',           // Schema for migrations table
  },
  
  // Entity management
  entities: {
    roles: {
      provider: '',
      exclude: [],
      include: [],
    },
  },
  
  // Development options
  breakpoints: true,            // Enable SQL statement breakpoints
  strict: true,                 // Strict mode
  verbose: true,                // Verbose logging
});
```

### Multiple Config Files
```bash
# Use specific config
npx drizzle-kit generate --config=drizzle-dev.config.ts
npx drizzle-kit generate --config=drizzle-prod.config.ts
```

## CLI Commands

### generate - Create Migration
```bash
# Generate from schema changes
npx drizzle-kit generate

# With custom config
npx drizzle-kit generate --config=./configs/drizzle.config.ts
```

Generates SQL migration files in the `out` folder:
```
drizzle/
├── 0000_fuzzy_arnim_zola.sql    # Migration file
├── 0000_snapshot.json          # Schema snapshot
└── meta/
    ├── _journal.json           # Migration history
    └── 0000_snapshot.json
```

### push - Apply Schema Changes (Dev)
```bash
# Push schema changes directly (good for development)
npx drizzle-kit push

# Push with specific config
npx drizzle-kit push --config=drizzle.config.ts
```

**Warning:** Push directly alters the database. Use only in development.

### pull - Introspect Existing Database
```bash
# Generate schema from existing database
npx drizzle-kit pull

# Pull with specific schema filter
npx drizzle-kit pull --schemaFilter=public
```

Generates `schema.ts` file from existing database tables.

### migrate - Run Migrations
```bash
# Run pending migrations
npx drizzle-kit migrate

# This executes migration files in order
```

### studio - Visual Database Editor
```bash
# Open Drizzle Studio
npx drizzle-kit studio

# With custom port
npx drizzle-kit studio --port 3000

# With custom host
npx drizzle-kit studio --host 0.0.0.0
```

### check - Verify Migrations
```bash
# Check if migrations are up to date
npx drizzle-kit check
```

### up - Upgrade Snapshots
```bash
# Upgrade old snapshots to new format
npx drizzle-kit up
```

### export - Export Schema
```bash
# Export schema as SQL
npx drizzle-kit export
```

## Programmatic Migrations

### Using migrate() function
```typescript
import { migrate } from 'drizzle-orm/node-postgres/migrator';
import { drizzle } from 'drizzle-orm/node-postgres';
import { Pool } from 'pg';

const pool = new Pool({ connectionString: process.env.DATABASE_URL });
const db = drizzle(pool);

// Run migrations
await migrate(db, { migrationsFolder: './drizzle' });
```

### Custom Migration Flow
```typescript
import { drizzle } from 'drizzle-orm/node-postgres';
import { migrate } from 'drizzle-orm/node-postgres/migrator';

async function runMigrations() {
  const db = drizzle(process.env.DATABASE_URL!);
  
  console.log('Running migrations...');
  await migrate(db, { migrationsFolder: './drizzle' });
  console.log('Migrations complete!');
  
  await db.$client.end();
}

runMigrations();
```

## Migration File Format

### Generated SQL Migration
```sql
-- 0000_cool_migration_name.sql

CREATE TABLE IF NOT EXISTS "users" (
	"id" serial PRIMARY KEY NOT NULL,
	"name" varchar(255) NOT NULL,
	"email" varchar(255) NOT NULL,
	"created_at" timestamp DEFAULT now()
);

CREATE UNIQUE INDEX IF NOT EXISTS "email_idx" ON "users" ("email");

--> statement-breakpoint

CREATE TABLE IF NOT EXISTS "posts" (
	"id" serial PRIMARY KEY NOT NULL,
	"title" varchar(255) NOT NULL,
	"content" text,
	"user_id" integer NOT NULL
);

DO $$ BEGIN
 ALTER TABLE "posts" ADD CONSTRAINT "posts_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE no action ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
```

### Journal File (meta/_journal.json)
```json
{
  "version": "7",
  "dialect": "postgresql",
  "entries": [
    {
      "idx": 0,
      "version": "7",
      "when": 1712345678901,
      "tag": "0000_initial",
      "breakpoints": true
    },
    {
      "idx": 1,
      "version": "7",
      "when": 1712345689012,
      "tag": "0001_add_posts",
      "breakpoints": true
    }
  ]
}
```

## Migration Patterns

### Baseline Existing Database
```bash
# 1. Pull existing schema
npx drizzle-kit pull

# 2. This generates schema.ts - move it to src/schema.ts

# 3. Mark as baseline (create initial snapshot without applying)
npx drizzle-kit generate --custom

# 4. Mark the migration as applied without running it
-- manually insert into __drizzle_migrations__ table
```

### Rolling Back
Drizzle doesn't have built-in rollback. Options:

1. **Create reverse migration:**
```typescript
// Schema change
export const users = pgTable('users', {
  // removed: oldColumn: text('old_column')
  newColumn: text('new_column'),
});
```

Then generate new migration that removes the column.

2. **Manual rollback script:**
```bash
# Restore from backup or use git to restore previous schema
# Then regenerate
```

### Seeding After Migration
```typescript
import { drizzle } from 'drizzle-orm/node-postgres';
import { migrate } from 'drizzle-orm/node-postgres/migrator';

async function migrateAndSeed() {
  const db = drizzle(process.env.DATABASE_URL!);
  
  // Run migrations
  await migrate(db, { migrationsFolder: './drizzle' });
  
  // Seed data
  await db.insert(users).values([
    { name: 'Admin', email: 'admin@example.com' },
  ]);
  
  console.log('Migrations and seed complete');
}
```

## Best Practices

### 1. Never Modify Generated Migrations
Always modify schema and regenerate:
```bash
# Wrong: editing 0001_add_users.sql
# Right: edit schema.ts -> npx drizzle-kit generate
```

### 2. Use Prefix Strategy
```typescript
// drizzle.config.ts
migrations: {
  prefix: 'timestamp', // or 'index' for sequential
}
```

### 3. Keep Migrations in Version Control
```bash
git add drizzle/
git commit -m "add: user and post tables"
```

### 4. Test Migrations Locally
```bash
# Drop and recreate local DB
# Run full migration chain
npx drizzle-kit migrate
```

### 5. Environment-Specific Configs
```typescript
// drizzle.config.ts
import { defineConfig } from 'drizzle-kit';

const isProd = process.env.NODE_ENV === 'production';

export default defineConfig({
  dialect: 'postgresql',
  schema: './src/schema.ts',
  out: isProd ? './drizzle-prod' : './drizzle',
  dbCredentials: {
    url: isProd 
      ? process.env.PROD_DATABASE_URL! 
      : process.env.DATABASE_URL!,
  },
});
```

### 6. Handle Data Migrations
For complex data migrations, add custom SQL:

```sql
-- In generated migration, add custom statements after -->

--> statement-breakpoint

-- Custom data migration
UPDATE users SET new_field = old_field;

--> statement-breakpoint

-- Then alter table
ALTER TABLE users DROP COLUMN old_field;
```

### 7. Use Breakpoints
```typescript
// drizzle.config.ts
breakpoints: true, // Adds --> statement-breakpoint between statements
```

This helps debug partial migration failures.

## Troubleshooting

### Migration Already Applied Error
```bash
# Check journal
 cat drizzle/meta/_journal.json

# If manually fixed database, reset journal or mark as applied
```

### Divergent Migration History
When team members create migrations simultaneously:

1. Regenerate from schema:
```bash
rm -rf drizzle/
npx drizzle-kit generate
```

2. Or merge manually by editing journal.

### Schema Drift
When database and schema are out of sync:

```bash
# Pull current state
npx drizzle-kit pull

# Compare and reconcile manually
# Then regenerate migrations
```
