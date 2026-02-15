# Read Replicas

The `withReplicas()` function provides automatic read/write splitting for database clusters with read replicas.

**How it works:**
- `SELECT` queries route to read replicas
- `INSERT`, `UPDATE`, `DELETE` queries route to primary instance

## Setup

### PostgreSQL

```typescript
import { drizzle } from 'drizzle-orm/node-postgres';
import { pgTable, serial, text, boolean, jsonb, timestamp, withReplicas } from 'drizzle-orm/pg-core';

const usersTable = pgTable('users', {
  id: serial('id').primaryKey(),
  name: text('name').notNull(),
  verified: boolean('verified').notNull().default(false),
  jsonb: jsonb('jsonb').$type<string[]>(),
  createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
});

const primaryDb = drizzle("postgres://user:password@host:port/primary_db");
const read1 = drizzle("postgres://user:password@host:port/read_replica_1");
const read2 = drizzle("postgres://user:password@host:port/read_replica_2");

const db = withReplicas(primaryDb, [read1, read2]);
```

### MySQL

```typescript
import { drizzle } from "drizzle-orm/mysql2";
import mysql from "mysql2/promise";
import { mysqlTable, serial, text, boolean, withReplicas } from 'drizzle-orm/mysql-core';

const usersTable = mysqlTable('users', {
  id: serial('id').primaryKey(),
  name: text('name').notNull(),
  verified: boolean('verified').notNull().default(false),
});

const primaryClient = await mysql.createConnection({
  host: "host",
  user: "user",
  database: "primary_db",
});
const primaryDb = drizzle({ client: primaryClient });

const read1Client = await mysql.createConnection({
  host: "host",
  user: "user",
  database: "read_1",
});
const read1 = drizzle({ client: read1Client });

const read2Client = await mysql.createConnection({
  host: "host",
  user: "user",
  database: "read_2",
});
const read2 = drizzle({ client: read2Client });

const db = withReplicas(primaryDb, [read1, read2]);
```

### SQLite (Turso)

```typescript
import { sqliteTable, int, text, withReplicas } from 'drizzle-orm/sqlite-core';
import { createClient } from '@libsql/client';
import { drizzle } from 'drizzle-orm/libsql';

const usersTable = sqliteTable('users', {
  id: int('id').primaryKey(),
  name: text('name').notNull(),
});

const primaryDb = drizzle({ 
  client: createClient({ url: 'DATABASE_URL', authToken: 'DATABASE_AUTH_TOKEN' }) 
});

const read1 = drizzle({ 
  client: createClient({ url: 'REPLICA1_URL', authToken: 'DATABASE_AUTH_TOKEN' }) 
});

const read2 = drizzle({ 
  client: createClient({ url: 'REPLICA2_URL', authToken: 'DATABASE_AUTH_TOKEN' }) 
});

const db = withReplicas(primaryDb, [read1, read2]);
```

### SingleStore

```typescript
import { drizzle } from "drizzle-orm/singlestore";
import mysql from "mysql2/promise";
import { singlestoreTable, serial, text, boolean, withReplicas } from 'drizzle-orm/singlestore-core';

const usersTable = singlestoreTable('users', {
  id: serial('id').primaryKey(),
  name: text('name').notNull(),
  verified: boolean('verified').notNull().default(false),
});

const primaryClient = await mysql.createConnection({
  host: "host",
  user: "user",
  database: "primary_db",
});
const primaryDb = drizzle({ client: primaryClient });

const read1Client = await mysql.createConnection({
  host: "host",
  user: "user",
  database: "read_1",
});
const read1 = drizzle({ client: read1Client });

const db = withReplicas(primaryDb, [read1]);
```

### MSSQL

```typescript
import { drizzle } from 'drizzle-orm/mssql-postgres';
import { mssqlTable, int, text, boolean, timestamp, withReplicas } from 'drizzle-orm/mssql-core';

const usersTable = mssqlTable('users', {
  id: int().primaryKey(),
  name: text().notNull(),
  verified: boolean().notNull().default(false),
  createdAt: timestamp('created_at').notNull(),
});

const primaryDb = drizzle("postgres://user:password@host:port/primary_db");
const read1 = drizzle("postgres://user:password@host:port/read_replica_1");
const read2 = drizzle("postgres://user:password@host:port/read_replica_2");

const db = withReplicas(primaryDb, [read1, read2]);
```

### CockroachDB

```typescript
import { drizzle } from 'drizzle-orm/cockroach';
import { cockroachTable, int4, text, boolean, jsonb, timestamp, withReplicas } from 'drizzle-orm/cockroach-core';

const usersTable = cockroachTable('users', {
  id: int4().primaryKey(),
  name: text().notNull(),
  verified: boolean().notNull().default(false),
  jsonb: jsonb().$type<string[]>(),
  createdAt: timestamp({ withTimezone: true }).notNull().defaultNow(),
});

const primaryDb = drizzle("postgres://user:password@host:port/primary_db");
const read1 = drizzle("postgres://user:password@host:port/read_replica_1");
const read2 = drizzle("postgres://user:password@host:port/read_replica_2");

const db = withReplicas(primaryDb, [read1, read2]);
```

## Usage

### Automatic Routing

```typescript
// Read from either read1 or read2 connection
await db.select().from(usersTable);

// Use primary database for delete operation
await db.delete(usersTable).where(eq(usersTable.id, 1));

// Insert uses primary
await db.insert(usersTable).values({ name: 'John' });

// Update uses primary
await db.update(usersTable).set({ name: 'Jane' }).where(eq(usersTable.id, 1));
```

### Force Primary for Reads

Use `$primary` key to force using primary instance even for read operations:

```typescript
// Read from primary (for fresh data)
await db.$primary.select().from(usersTable);
```

## Custom Replica Selection Logic

Implement weighted or custom logic for choosing read replicas:

### Weighted Selection

```typescript
const db = withReplicas(primaryDb, [read1, read2], (replicas) => {
  const weight = [0.7, 0.3];  // 70% to first, 30% to second
  let cumulativeProbability = 0;
  const rand = Math.random();

  for (const [i, replica] of replicas.entries()) {
    cumulativeProbability += weight[i]!;
    if (rand < cumulativeProbability) return replica;
  }
  return replicas[0]!;
});

await db.select().from(usersTable);
```

### Round-Robin

```typescript
let currentReplica = 0;

const db = withReplicas(primaryDb, [read1, read2, read3], (replicas) => {
  const replica = replicas[currentReplica];
  currentReplica = (currentReplica + 1) % replicas.length;
  return replica;
});
```

### Geographic Selection

```typescript
const db = withReplicas(primaryDb, [usReplica, euReplica, asiaReplica], (replicas, query) => {
  // Select based on user's region
  const userRegion = getUserRegion();
  
  switch (userRegion) {
    case 'US': return replicas[0];
    case 'EU': return replicas[1];
    case 'ASIA': return replicas[2];
    default: return replicas[0];
  }
});
```

## Health Checks

Add health checks to avoid routing to unhealthy replicas:

```typescript
const healthyReplicas = new Set();

// Check health periodically
async function checkReplicaHealth() {
  for (const replica of [read1, read2, read3]) {
    try {
      await replica.execute(sql`SELECT 1`);
      healthyReplicas.add(replica);
    } catch {
      healthyReplicas.delete(replica);
    }
  }
}

const db = withReplicas(primaryDb, [read1, read2, read3], (replicas) => {
  const healthy = replicas.filter(r => healthyReplicas.has(r));
  if (healthy.length === 0) return primaryDb;  // Fallback to primary
  
  return healthy[Math.floor(Math.random() * healthy.length)];
});
```

## Database Support

| Database | Read Replicas Support |
|----------|----------------------|
| PostgreSQL | ✅ |
| MySQL | ✅ |
| SQLite (Turso) | ✅ |
| SingleStore | ✅ |
| MSSQL | ✅ |
| CockroachDB | ✅ |

## Best Practices

### 1. Monitor Replica Lag

```typescript
// Force primary for time-sensitive reads
const recentOrders = await db.$primary
  .select()
  .from(orders)
  .where(gte(orders.createdAt, sql`now() - interval '5 minutes'`));
```

### 2. Handle Replica Lag in UI

```typescript
// Show stale data warning
const data = await db.select().from(users);
const isFresh = await checkIfFresh(data);

if (!isFresh) {
  // Re-fetch from primary
  const freshData = await db.$primary.select().from(users);
}
```

### 3. Transaction Consistency

```typescript
// Transactions always use primary for consistency
await db.transaction(async (tx) => {
  const user = await tx.insert(users).values({ name: 'John' }).returning();
  await tx.insert(posts).values({ userId: user[0].id, title: 'Hello' });
});
```

### 4. Fallback Strategy

```typescript
const db = withReplicas(primaryDb, [read1, read2], (replicas) => {
  try {
    return selectRandomReplica(replicas);
  } catch {
    // Fallback to primary if all replicas fail
    return primaryDb;
  }
});
```
