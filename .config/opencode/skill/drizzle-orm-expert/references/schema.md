# Schema Declaration Reference

## PostgreSQL Column Types

### Numeric
```typescript
import { pgTable, serial, integer, smallint, bigint, real, doublePrecision, numeric } from 'drizzle-orm/pg-core';

pgTable('table', {
  id: serial('id').primaryKey(),           // Auto-increment integer
  small: smallint('small'),                 // 16-bit integer
  normal: integer('normal'),                // 32-bit integer
  big: bigint('big', { mode: 'number' }),   // 64-bit as number
  bigInt: bigint('big_int', { mode: 'bigint' }), // 64-bit as bigint
  real: real('real'),                       // Single precision float
  double: doublePrecision('double'),        // Double precision float
  decimal: numeric('decimal', { precision: 10, scale: 2 }), // Exact decimal
  serial: serial('serial').primaryKey(),    // Auto-increment
  smallserial: smallserial('smallserial').primaryKey(),
  bigserial: bigserial('bigserial').primaryKey(),
});
```

### String
```typescript
import { varchar, char, text } from 'drizzle-orm/pg-core';

pgTable('table', {
  varchar: varchar('varchar', { length: 255 }),     // Variable-length with limit
  char: char('char', { length: 10 }),               // Fixed-length, space-padded
  text: text('text'),                               // Unlimited length
  textWithEnum: text('role', { enum: ['admin', 'user'] }),
  charWithEnum: char('status', { length: 20, enum: ['active', 'inactive'] }),
  varcharWithEnum: varchar('type', { length: 50, enum: ['a', 'b', 'c'] }),
});
```

### Boolean
```typescript
import { boolean } from 'drizzle-orm/pg-core';

pgTable('table', {
  active: boolean('active').default(false),
});
```

### Date/Time
```typescript
import { timestamp, date, time, interval } from 'drizzle-orm/pg-core';

pgTable('table', {
  // Timestamp - stores both date and time
  ts: timestamp('ts'),                          // Without timezone
  tsTz: timestamp('ts_tz', { withTimezone: true }), // With timezone
  tsModeDate: timestamp('ts_date', { mode: 'date' }), // Returns JS Date
  tsModeString: timestamp('ts_string', { mode: 'string' }), // Returns string
  
  // Date - stores date only
  date: date('date'),                           // Returns JS Date
  dateString: date('date_str', { mode: 'string' }), // Returns string
  
  // Time - stores time only
  time: time('time'),                           // Without timezone
  timeTz: time('time_tz', { withTimezone: true }),
  
  // Interval
  duration: interval('duration'),
});
```

### Binary
```typescript
import { bytea } from 'drizzle-orm/pg-core';

pgTable('table', {
  data: bytea('data'), // Binary data
});
```

### JSON
```typescript
import { json, jsonb } from 'drizzle-orm/pg-core';

pgTable('table', {
  json: json('json'),     // JSON stored as text
  jsonb: jsonb('jsonb'),  // Binary JSON with indexing support
});
```

### UUID
```typescript
import { uuid } from 'drizzle-orm/pg-core';

pgTable('table', {
  id: uuid('id').defaultRandom().primaryKey(),
});
```

### Network
```typescript
import { cidr, inet, macaddr, macaddr8 } from 'drizzle-orm/pg-core';

pgTable('table', {
  network: cidr('network'),     // IPv4/v6 network
  address: inet('address'),       // IPv4/v6 host or network
  mac: macaddr('mac'),            // MAC address
  mac8: macaddr8('mac8'),         // MAC address (EUI-64)
});
```

### Bit String
```typescript
import { bit, varbit } from 'drizzle-orm/pg-core';

pgTable('table', {
  fixed: bit('fixed', { dimensions: 8 }),    // Fixed-length bit string
  variable: varbit('variable', { dimensions: 16 }), // Variable-length
});
```

### Geometric
```typescript
import { point, line, lseg, box, path, polygon, circle } from 'drizzle-orm/pg-core';

pgTable('table', {
  pt: point('pt', { mode: 'xy' }),           // Point as {x, y}
  ptTuple: point('pt_tuple', { mode: 'tuple' }), // Point as [x, y]
  ln: line('ln', { mode: 'abc' }),            // Line as {a, b, c}
  lnTuple: line('ln_tuple', { mode: 'tuple' }), // Line as [a, b, c]
  segment: lseg('segment'),                   // Line segment
  boundingBox: box('box'),                    // Rectangular box
  closedPath: path('closed_path'),            // Closed path
  openPath: path('open_path'),                // Open path
  poly: polygon('polygon'),                     // Polygon
  circ: circle('circle'),                       // Circle
});
```

### Vectors (pgvector extension)
```typescript
import { vector, halfvec, sparsevec } from 'drizzle-orm/pg-core';

pgTable('table', {
  embedding: vector('embedding', { dimensions: 1536 }),
  halfEmbedding: halfvec('half_embedding', { dimensions: 1536 }),
  sparse: sparsevec('sparse', { dimensions: 1000 }),
});
```

### Arrays
```typescript
pgTable('table', {
  tags: text('tags').array(),                 // text[]
  scores: integer('scores').array().default([]), // integer[]
  matrix: integer('matrix').array(2),          // 2D array
});
```

### Enums
```typescript
import { pgEnum } from 'drizzle-orm/pg-core';

export const roleEnum = pgEnum('role', ['admin', 'user', 'guest']);

pgTable('table', {
  role: roleEnum('role').default('user'),
});
```

## MySQL Column Types

### Numeric
```typescript
import { mysqlTable, tinyint, smallint, mediumint, int, bigint, float, double, decimal, serial } from 'drizzle-orm/mysql-core';

mysqlTable('table', {
  tiny: tinyint('tiny'),                      // 8-bit integer (-128 to 127)
  tinyUnsigned: tinyint('tiny_unsigned', { unsigned: true }), // 0 to 255
  small: smallint('small'),                   // 16-bit
  smallUnsigned: smallint('small_unsigned', { unsigned: true }),
  medium: mediumint('medium'),                // 24-bit
  mediumUnsigned: mediumint('medium_unsigned', { unsigned: true }),
  normal: int('normal'),                      // 32-bit
  normalUnsigned: int('normal_unsigned', { unsigned: true }),
  big: bigint('big', { mode: 'number' }),     // 64-bit as number
  bigUnsigned: bigint('big_unsigned', { mode: 'number', unsigned: true }),
  bigIntMode: bigint('big_int', { mode: 'bigint' }), // As bigint
  float: float('float'),
  floatUnsigned: float('float_unsigned', { unsigned: true }),
  double: double('double'),
  doubleUnsigned: double('double_unsigned', { unsigned: true }),
  decimal: decimal('decimal', { precision: 10, scale: 2 }),
  autoId: serial('id').primaryKey(),          // Alias for bigint unsigned auto_increment
});
```

### String
```typescript
import { char, varchar, text, tinytext, mediumtext, longtext, binary, varbinary, blob, tinyblob, mediumblob, longblob } from 'drizzle-orm/mysql-core';

mysqlTable('table', {
  fixed: char('fixed', { length: 10 }),
  variable: varchar('variable', { length: 255 }),
  tiny: tinytext('tiny'),                     // Max 255 bytes
  normal: text('normal'),                     // Max 65535 bytes
  medium: mediumtext('medium'),               // Max 16MB
  long: longtext('long'),                     // Max 4GB
  binFixed: binary('bin_fixed', { length: 64 }),
  binVariable: varbinary('bin_variable', { length: 255 }),
  blobTiny: tinyblob('blob_tiny'),
  blobNormal: blob('blob_normal'),
  blobMedium: mediumblob('blob_medium'),
  blobLong: longblob('blob_long'),
});
```

### Date/Time
```typescript
import { date, datetime, time, timestamp, year } from 'drizzle-orm/mysql-core';

mysqlTable('table', {
  date: date('date', { mode: 'date' }),
  dateString: date('date_str', { mode: 'string' }),
  datetime: datetime('datetime', { mode: 'date' }),
  datetimeString: datetime('datetime_str', { mode: 'string' }),
  timestamp: timestamp('timestamp', { mode: 'date' }),
  time: time('time'),
  year: year('year'),                         // 1901 to 2155
});
```

### JSON
```typescript
import { json } from 'drizzle-orm/mysql-core';

mysqlTable('table', {
  data: json('data'),
});
```

### MySQL Enums
```typescript
import { mysqlEnum } from 'drizzle-orm/mysql-core';

mysqlTable('table', {
  status: mysqlEnum('status', ['active', 'inactive', 'pending']),
});
```

## SQLite Column Types

SQLite uses dynamic typing but Drizzle provides type constraints:

```typescript
import { sqliteTable, integer, real, text, blob, numeric } from 'drizzle-orm/sqlite-core';

sqliteTable('table', {
  // Integer (can store boolean, date, timestamp)
  id: integer('id', { mode: 'number' }).primaryKey({ autoIncrement: true }),
  bool: integer('bool', { mode: 'boolean' }),
  timestamp: integer('timestamp', { mode: 'timestamp' }),
  timestampMs: integer('timestamp_ms', { mode: 'timestamp_ms' }),
  
  // Real (floating point)
  float: real('float'),
  
  // Text
  name: text('name'),
  nameLimited: text('name_limited', { length: 255 }),
  json: text('json', { mode: 'json' }),
  
  // Blob
  data: blob('data'),
  dataJson: blob('data_json', { mode: 'json' }),
  dataBigInt: blob('data_bigint', { mode: 'bigint' }),
  
  // Numeric
  decimal: numeric('decimal'),
});
```

## Column Modifiers

All dialects support these modifiers:

```typescript
pgTable('table', {
  // Constraints
  id: integer('id').primaryKey(),
  email: varchar('email').unique(),
  ref: integer('ref').references(() => otherTable.id),
  refNamed: integer('ref_named').references(() => otherTable.id, { onDelete: 'cascade', onUpdate: 'cascade' }),
  
  // Nullability
  required: varchar('required').notNull(),
  optional: varchar('optional'),              // Nullable by default
  
  // Defaults
  withDefault: varchar('with_default').default('value'),
  withDefaultExpr: timestamp('with_expr').defaultNow(),
  withDefaultUuid: uuid('with_uuid').defaultRandom(),
  withDefaultSql: varchar('with_sql').default(sql`'generated'::text`),
  
  // Generated columns
  computed: integer('computed').generatedAlwaysAs(sql`${table.a} + ${table.b}`),
  stored: integer('stored').generatedAlwaysAs(sql"a + b", { stored: true }),
});
```

## Custom Types

```typescript
import { customType } from 'drizzle-orm/pg-core';

const customJsonb = <TData>(name: string) =>
  customType<{ data: TData; driverData: string }>({
    dataType() {
      return 'jsonb';
    },
    toDriver(value: TData): string {
      return JSON.stringify(value);
    },
    fromDriver(value: string): TData {
      return JSON.parse(value);
    },
  })(name);

pgTable('table', {
  customData: customJsonb<MyType>('custom_data'),
});
```

## Views

```typescript
import { pgView, pgMaterializedView } from 'drizzle-orm/pg-core';

// Regular view
export const usersView = pgView('users_view').as((qb) =>
  qb.select().from(users).where(gt(users.age, 18))
);

// Materialized view
export const usersMatView = pgMaterializedView('users_mat_view').as((qb) =>
  qb.select().from(users).where(gt(users.age, 18))
);
```

## Indexes

```typescript
import { index, uniqueIndex } from 'drizzle-orm/pg-core';

pgTable('table', {
  id: serial('id').primaryKey(),
  email: varchar('email').notNull(),
  name: varchar('name').notNull(),
  search: text('search'),
}, (table) => ({
  // Simple index
  emailIdx: index('email_idx').on(table.email),
  
  // Unique index
  emailUnique: uniqueIndex('email_unique').on(table.email),
  
  // Composite index
  nameEmailIdx: index('name_email_idx').on(table.name, table.email),
  
  // Partial index
  partialIdx: index('partial_idx').on(table.email).where(sql`${table.active} = true`),
  
  // Using SQL expression
  searchIdx: index('search_idx').using('gin', sql`to_tsvector('english', ${table.search})`),
}));
```
