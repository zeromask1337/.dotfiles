# Database Connections Reference

## PostgreSQL

### node-postgres (pg)
```typescript
import { drizzle } from 'drizzle-orm/node-postgres';
import { Pool, Client } from 'pg';

// Using connection string
const db = drizzle(process.env.DATABASE_URL!);

// Using Pool (recommended for apps)
const pool = new Pool({ connectionString: process.env.DATABASE_URL });
const db = drizzle({ client: pool });

// Using Client (single connection)
const client = new Client({ connectionString: process.env.DATABASE_URL });
await client.connect();
const db = drizzle({ client });

// With options
const db = drizzle({
  client: pool,
  logger: true, // Log queries
});
```

### postgres.js
```typescript
import { drizzle } from 'drizzle-orm/postgres-js';
import postgres from 'postgres';

// Connection string
const client = postgres(process.env.DATABASE_URL!);
const db = drizzle(client);

// With options
const client = postgres(process.env.DATABASE_URL!, {
  prepare: false, // Disable prepared statements (for some providers)
  max: 10,        // Connection pool size
});
const db = drizzle(client);
```

### Neon (Serverless)
```typescript
import { drizzle } from 'drizzle-orm/neon-serverless';
import { Pool, neonConfig } from '@neondatabase/serverless';

// Enable WebSocket for serverless
neonConfig.fetchConnectionCache = true;

const pool = new Pool({ connectionString: process.env.DATABASE_URL });
const db = drizzle(pool);

// Or using config object
const db = drizzle({
  connection: process.env.DATABASE_URL,
});
```

### Vercel Postgres
```typescript
import { drizzle } from 'drizzle-orm/vercel-postgres';
import { sql } from '@vercel/postgres';

const db = drizzle(sql);

// Or with Pool
import { createPool } from '@vercel/postgres';
const pool = createPool({ connectionString: process.env.DATABASE_URL });
const db = drizzle(pool);
```

### Supabase
```typescript
import { drizzle } from 'drizzle-orm/postgres-js';
import postgres from 'postgres';

// Use connection pooler for serverless
const client = postgres(process.env.DATABASE_URL!, {
  prepare: false,
});
const db = drizzle(client);
```

### PlanetScale (MySQL-compatible but uses this driver)
```typescript
import { drizzle } from 'drizzle-orm/planetscale-serverless';
import { connect } from '@planetscale/database';

const client = connect({
  host: process.env.DATABASE_HOST,
  username: process.env.DATABASE_USERNAME,
  password: process.env.DATABASE_PASSWORD,
});

const db = drizzle(client);
```

### Railway, Render, etc.
```typescript
import { drizzle } from 'drizzle-orm/node-postgres';
import { Pool } from 'pg';

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: process.env.NODE_ENV === 'production', // Enable SSL in prod
});

const db = drizzle(pool);
```

### PGlite (Embedded PostgreSQL)
```typescript
import { drizzle } from 'drizzle-orm/pglite';
import { PGlite } from '@electric-sql/pglite';

// In-memory
const client = new PGlite();
const db = drizzle(client);

// With persistence
const client = new PGlite('./path/to/db');
const db = drizzle(client);

// Using existing instance
const db = drizzle({ client });
```

## MySQL

### mysql2
```typescript
import { drizzle } from 'drizzle-orm/mysql2';
import mysql from 'mysql2/promise';

// Connection string
const db = drizzle(process.env.DATABASE_URL!);

// Using Pool (recommended)
const pool = mysql.createPool({
  host: 'localhost',
  user: 'root',
  password: 'password',
  database: 'mydb',
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0,
});
const db = drizzle(pool);

// Using single connection
const connection = await mysql.createConnection(process.env.DATABASE_URL!);
const db = drizzle(connection);

// With options
const db = drizzle(pool, { logger: true });
```

### PlanetScale
```typescript
import { drizzle } from 'drizzle-orm/planetscale-serverless';
import { Client } from '@planetscale/database';

const client = new Client({
  host: process.env.DATABASE_HOST,
  username: process.env.DATABASE_USERNAME,
  password: process.env.DATABASE_PASSWORD,
});

const db = drizzle(client);
```

### TiDB Serverless
```typescript
import { drizzle } from 'drizzle-orm/mysql2';
import mysql from 'mysql2/promise';

const connection = await mysql.createConnection({
  host: process.env.TIDB_HOST,
  port: 4000,
  user: process.env.TIDB_USER,
  password: process.env.TIDB_PASSWORD,
  database: process.env.TIDB_DATABASE,
  ssl: { minVersion: 'TLSv1.2', rejectUnauthorized: true },
});

const db = drizzle(connection);
```

### SingleStore
```typescript
import { drizzle } from 'drizzle-orm/mysql2';
import mysql from 'mysql2/promise';

const pool = mysql.createPool(process.env.DATABASE_URL!);
const db = drizzle(pool);
```

## SQLite

### better-sqlite3 (Recommended for sync)
```typescript
import { drizzle } from 'drizzle-orm/better-sqlite3';
import Database from 'better-sqlite3';

const client = new Database('sqlite.db');
const db = drizzle(client);

// In-memory
const client = new Database(':memory:');
const db = drizzle(client);
```

### libsql / Turso
```typescript
import { drizzle } from 'drizzle-orm/libsql';
import { createClient } from '@libsql/client';

// Local SQLite file
const client = createClient({ url: 'file:sqlite.db' });
const db = drizzle(client);

// Remote Turso database
const client = createClient({
  url: process.env.TURSO_URL!,
  authToken: process.env.TURSO_AUTH_TOKEN!,
});
const db = drizzle(client);

// Embedded replica (synced local copy)
const client = createClient({
  url: 'file:local.db',
  syncUrl: process.env.TURSO_URL!,
  authToken: process.env.TURSO_AUTH_TOKEN!,
});
const db = drizzle(client);
```

### Bun SQLite
```typescript
import { drizzle } from 'drizzle-orm/bun-sqlite';
import { Database } from 'bun:sqlite';

const client = new Database('sqlite.db');
const db = drizzle(client);

// In-memory
const client = new Database(':memory:');
const db = drizzle(client);
```

### Cloudflare D1
```typescript
import { drizzle } from 'drizzle-orm/d1';

// In Cloudflare Worker
export interface Env {
  DB: D1Database;
}

export default {
  async fetch(request: Request, env: Env) {
    const db = drizzle(env.DB);
    const result = await db.select().from(users);
    return new Response(JSON.stringify(result));
  },
};
```

### Expo SQLite (React Native)
```typescript
import { drizzle } from 'drizzle-orm/expo-sqlite';
import { openDatabaseSync } from 'expo-sqlite/next';

const client = openDatabaseSync('db.db');
const db = drizzle(client);

// Use async API
const result = await db.select().from(users);
```

### OP SQLite (React Native - high performance)
```typescript
import { drizzle } from 'drizzle-orm/op-sqlite';
import { open } from '@op-engineering/op-sqlite';

const client = open({
  name: 'mydb.sqlite',
  encryptionKey: 'your-encryption-key', // Optional encryption
});

const db = drizzle(client);
```

### React Native Quick SQLite
```typescript
import { drizzle } from 'drizzle-orm/react-native-quick-sqlite';
import { open } from 'react-native-quick-sqlite';

const client = open({ name: 'mydb.sqlite' });
const db = drizzle(client);
```

### SQLite Cloud
```typescript
import { drizzle } from 'drizzle-orm/sqlite-cloud';
import { Database } from '@sqlitecloud/drivers';

const client = new Database(process.env.SQLITE_CLOUD_URL!);
const db = drizzle(client);
```

### Durable Objects (Cloudflare)
```typescript
import { drizzle } from 'drizzle-orm/durable-sqlite';

export class MyDurableObject extends DurableObject {
  private db: ReturnType<typeof drizzle>;
  
  constructor(ctx: DurableObjectState, env: Env) {
    super(ctx, env);
    this.db = drizzle(ctx.storage);
  }
  
  async fetch(request: Request) {
    const result = await this.db.select().from(users);
    return new Response(JSON.stringify(result));
  }
}
```

## Microsoft SQL Server

```typescript
import { drizzle } from 'drizzle-orm/node-mssql';
import sql from 'mssql';

// Connection string
const db = drizzle(process.env.DATABASE_URL!);

// With config
const db = drizzle({
  connection: {
    server: 'localhost',
    database: 'mydb',
    user: 'sa',
    password: 'password',
    options: {
      trustServerCertificate: true,
    },
  },
});

// Using existing pool
const pool = await sql.connect(process.env.DATABASE_URL!);
const db = drizzle({ client: pool });
```

## CockroachDB

```typescript
import { drizzle } from 'drizzle-orm/node-postgres';
import { Pool } from 'pg';

const pool = new Pool({ connectionString: process.env.DATABASE_URL });
const db = drizzle(pool);
```

## Gel (formerly EdgeDB)

```typescript
import { drizzle } from 'drizzle-orm/gel';
import { createClient } from 'gel';

// With connection string
const db = drizzle(process.env.GEL_DSN!);

// With config
const db = drizzle({
  connection: {
    dsn: process.env.GEL_DSN,
    tlsSecurity: 'default',
  },
});

// Using existing client
const gelClient = createClient();
const db = drizzle({ client: gelClient });
```

## AWS Data API

### PostgreSQL
```typescript
import { drizzle } from 'drizzle-orm/aws-data-api-pg';
import { RDSDataClient } from '@aws-sdk/client-rds-data';

const client = new RDSDataClient({ region: 'us-east-1' });

const db = drizzle(client, {
  database: 'mydb',
  resourceArn: process.env.CLUSTER_ARN!,
  secretArn: process.env.SECRET_ARN!,
});
```

### MySQL
```typescript
import { drizzle } from 'drizzle-orm/aws-data-api-mysql';
import { RDSDataClient } from '@aws-sdk/client-rds-data';

const client = new RDSDataClient({ region: 'us-east-1' });

const db = drizzle(client, {
  database: 'mydb',
  resourceArn: process.env.CLUSTER_ARN!,
  secretArn: process.env.SECRET_ARN!,
});
```

## Connection Patterns

### Connection Pool Management
```typescript
import { drizzle } from 'drizzle-orm/node-postgres';
import { Pool } from 'pg';

// Create pool once, reuse
let pool: Pool | null = null;

function getDb() {
  if (!pool) {
    pool = new Pool({
      connectionString: process.env.DATABASE_URL,
      max: 20, // Maximum pool size
      idleTimeoutMillis: 30000, // Close idle clients after 30s
      connectionTimeoutMillis: 2000, // Timeout connecting
    });
  }
  return drizzle(pool);
}

// Graceful shutdown
async function closePool() {
  if (pool) {
    await pool.end();
    pool = null;
  }
}
```

### Environment-Based Configuration
```typescript
// db.ts
import { drizzle } from 'drizzle-orm/node-postgres';
import { Pool } from 'pg';

const isProd = process.env.NODE_ENV === 'production';

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: isProd ? { rejectUnauthorized: false } : false,
  max: isProd ? 20 : 10,
});

export const db = drizzle(pool, {
  logger: !isProd, // Log queries in development
});
```

### Transaction Wrapper
```typescript
async function withTransaction<T>(
  callback: (tx: typeof db) => Promise<T>
): Promise<T> {
  return await db.transaction(async (tx) => {
    return await callback(tx);
  });
}

// Usage
await withTransaction(async (tx) => {
  await tx.insert(users).values({ name: 'John' });
  await tx.insert(posts).values({ title: 'Hello' });
});
```

## Connection Options Reference

| Option | Description |
|--------|-------------|
| `client` | Existing driver client instance |
| `connection` | Connection string or config object |
| `logger` | Enable query logging (boolean) |
| `casing` | Column name casing strategy |

## Troubleshooting

### SSL/TLS Issues
```typescript
// PostgreSQL with self-signed cert
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: {
    rejectUnauthorized: false, // Accept self-signed certs
  },
});

// MySQL SSL
const pool = mysql.createPool({
  uri: process.env.DATABASE_URL,
  ssl: { rejectUnauthorized: false },
});
```

### Prepared Statement Issues (Serverless)
```typescript
import { drizzle } from 'drizzle-orm/postgres-js';
import postgres from 'postgres';

// Disable prepared statements for some providers
const client = postgres(process.env.DATABASE_URL!, {
  prepare: false,
});
const db = drizzle(client);
```

### Connection Timeouts
```typescript
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  connectionTimeoutMillis: 5000, // 5 seconds
  idleTimeoutMillis: 30000, // 30 seconds
  max: 20,
});
```
