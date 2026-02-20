# PostgreSQL Extensions

Drizzle ORM supports popular PostgreSQL extensions like `pg_vector` and `postgis`.

**Note:** You need to install extensions in your database first. Drizzle doesn't create extensions, only uses them.

## pg_vector

[pg_vector](https://github.com/pgvector/pgvector) - Open-source vector similarity search for Postgres.

**Features:**
- Exact and approximate nearest neighbor search
- Single-precision, half-precision, binary, and sparse vectors
- L2 distance, inner product, cosine distance, L1 distance, Hamming distance, Jaccard distance

### Installation

```sql
-- In your PostgreSQL database
CREATE EXTENSION IF NOT EXISTS vector;
```

### Column Types

**Vector:**

```typescript
import { vector, halfvec, sparsevec } from 'drizzle-orm/pg-core';

const table = pgTable('items', {
  id: serial('id').primaryKey(),
  embedding: vector({ dimensions: 3 }),
  halfEmbedding: halfvec({ dimensions: 1536 }),
  sparse: sparsevec({ dimensions: 1000 }),
});
```

```sql
CREATE TABLE IF NOT EXISTS "items" (
  "id" serial PRIMARY KEY,
  "embedding" vector(3),
  "half_embedding" halfvec(1536),
  "sparse" sparsevec(1000)
);
```

### Vector Indexes

Create HNSW indexes for fast similarity search:

```typescript
import { index, pgTable, serial, vector } from 'drizzle-orm/pg-core';

const table = pgTable('items', {
  id: serial('id').primaryKey(),
  embedding: vector({ dimensions: 3 })
}, (table) => [
  // L2 distance index
  index('l2_index').using('hnsw', table.embedding.op('vector_l2_ops')),
  // Inner product index
  index('ip_index').using('hnsw', table.embedding.op('vector_ip_ops')),
  // Cosine distance index
  index('cosine_index').using('hnsw', table.embedding.op('vector_cosine_ops')),
  // L1 distance (pg_vector 0.7.0+)
  index('l1_index').using('hnsw', table.embedding.op('vector_l1_ops')),
  // Hamming distance for bit vectors
  index('hamming_index').using('hnsw', table.embedding.op('bit_hamming_ops')),
  // Jaccard distance
  index('jaccard_index').using('hnsw', table.embedding.op('bit_jaccard_ops')),
]);
```

Generated SQL:
```sql
CREATE INDEX "l2_index" ON "items" USING hnsw ("embedding" vector_l2_ops);
CREATE INDEX "ip_index" ON "items" USING hnsw ("embedding" vector_ip_ops);
CREATE INDEX "cosine_index" ON "items" USING hnsw ("embedding" vector_cosine_ops);
```

### Distance Functions

Drizzle provides helper functions for vector operations:

```typescript
import { 
  l2Distance,      // <->  L2/Euclidean distance
  l1Distance,      // <+>  L1/Manhattan distance
  innerProduct,    // <#>  Inner product
  cosineDistance,  // <=>  Cosine distance
  hammingDistance, // <~>  Hamming distance
  jaccardDistance  // <%>  Jaccard distance
} from 'drizzle-orm';

// L2 distance: table.column <-> '[3, 1, 2]'
l2Distance(table.embedding, [3, 1, 2])

// L1 distance: table.column <+> '[3, 1, 2]'
l1Distance(table.column, [3, 1, 2])

// Inner product: table.column <#> '[3, 1, 2]'
innerProduct(table.column, [3, 1, 2])

// Cosine distance: table.column <=> '[3, 1, 2]'
cosineDistance(table.column, [3, 1, 2])

// Hamming distance (for bit vectors)
hammingDistance(table.column, '101')

// Jaccard distance (for bit vectors)
jaccardDistance(table.column, '101')
```

### Query Examples

**Find 5 nearest neighbors:**

```typescript
import { l2Distance } from 'drizzle-orm';

// SELECT * FROM items ORDER BY embedding <-> '[3,1,2]' LIMIT 5;
const results = await db
  .select()
  .from(items)
  .orderBy(l2Distance(items.embedding, [3, 1, 2]))
  .limit(5);
```

**Get distances as column:**

```typescript
// SELECT embedding <-> '[3,1,2]' AS distance FROM items;
const results = await db.select({
  distance: l2Distance(items.embedding, [3, 1, 2])
}).from(items);
```

**Search with subquery:**

```typescript
// SELECT * FROM items ORDER BY embedding <-> 
//   (SELECT embedding FROM items WHERE id = 1) LIMIT 5;
const subquery = db
  .select({ embedding: items.embedding })
  .from(items)
  .where(eq(items.id, 1));

const results = await db
  .select()
  .from(items)
  .orderBy(l2Distance(items.embedding, subquery))
  .limit(5);
```

**Calculate inner product:**

```typescript
// SELECT (embedding <#> '[3,1,2]') * -1 AS inner_product FROM items;
const results = await db.select({
  innerProduct: sql`(${maxInnerProduct(items.embedding, [3, 1, 2])}) * -1`
}).from(items);
```

### Custom Vector Functions

If you need custom operators, replicate the existing implementations:

```typescript
import { sql, SQL, AnyColumn, SQLWrapper, TypedQueryBuilder, is } from 'drizzle-orm';

export function customDistance(
  column: SQLWrapper | AnyColumn,
  value: number[] | string[] | TypedQueryBuilder<any> | string,
): SQL {
  if (is(value, TypedQueryBuilder<any>) || typeof value === 'string') {
    return sql`${column} <~> ${value}`;  // Custom operator
  }
  return sql`${column} <~> ${JSON.stringify(value)}`;
}
```

## PostGIS

[PostGIS](https://postgis.net/) - Spatial database extender for PostgreSQL.

**Features:**
- Store, index, query geospatial data
- Geometry and geography types
- Spatial indexes (GIST)
- Distance calculations

### Installation

```sql
-- In your PostgreSQL database
CREATE EXTENSION IF NOT EXISTS postgis;
```

### Column Types

**Geometry:**

```typescript
import { geometry, pgTable, serial } from 'drizzle-orm/pg-core';

const items = pgTable('items', {
  id: serial('id').primaryKey(),
  // Simple point as tuple [x, y]
  geo: geometry('geo', { type: 'point' }),
  
  // Point as object { x, y }
  geoObj: geometry('geo_obj', { type: 'point', mode: 'xy' }),
  
  // With specific SRID
  geoSrid: geometry('geo_options', { 
    type: 'point', 
    mode: 'xy', 
    srid: 4326  // WGS 84
  }),
});
```

**Modes:**
- `tuple`: Maps to `[x, y]` array
- `xy`: Maps to `{ x, y }` object

**Types:**
Predefined type `point` available (maps to `geometry(Point)`). Specify any string for other PostGIS types.

### Spatial Indexes

```typescript
import { index, geometry, pgTable, serial } from 'drizzle-orm/pg-core';

const table = pgTable('table', {
  id: serial('id').primaryKey(),
  geom: geometry({ type: 'point' }),
}, (table) => [
  // GIST index for geometry
  index('custom_idx').using('gist', table.geom)
]);
```

Generated SQL:
```sql
CREATE INDEX "custom_idx" ON "table" USING GIST (geom);
```

### Querying Spatial Data

```typescript
// Find points within distance
const nearby = await db
  .select()
  .from(locations)
  .where(
    sql`ST_DWithin(
      ${locations.coordinates},
      ST_SetSRID(ST_MakePoint(${lng}, ${lat}), 4326),
      ${radiusInMeters}
    )`
  );

// Calculate distance
const withDistance = await db.select({
  id: locations.id,
  name: locations.name,
  distance: sql<number>`ST_Distance(
    ${locations.coordinates}::geography,
    ST_SetSRID(ST_MakePoint(${lng}, ${lat}), 4326)::geography
  )`.as('distance')
}).from(locations);

// Bounding box query
const inBounds = await db
  .select()
  .from(locations)
  .where(
    sql`${locations.coordinates} && ST_MakeEnvelope(${minX}, ${minY}, ${maxX}, ${maxY}, 4326)`
  );
```

### Configuration Options

Ignore PostGIS tables during introspection:

```typescript
// drizzle.config.ts
export default defineConfig({
  dialect: 'postgresql',
  schema: './schema.ts',
  extensionsFilters: ['postgis'],  // Ignore PostGIS internal tables
});
```

## Extension Support by Database

| Extension | PostgreSQL | MySQL | SQLite | SingleStore |
|-----------|-----------|-------|---------|-------------|
| pg_vector | ✅ | ❌ | ❌ | ❌ |
| postgis | ✅ | ❌ | ❌ | ❌ |

## Best Practices

### pg_vector

1. **Use HNSW indexes** for large datasets (10k+ vectors)
2. **Choose appropriate dimensions** - higher = more accurate but slower
3. **Use halfvec** for large-scale applications to save memory
4. **Pre-filter before vector search** when possible

```typescript
// Good: Filter first, then vector search
const results = await db
  .select()
  .from(products)
  .where(and(
    eq(products.category, 'electronics'),
    gt(products.price, 100)
  ))
  .orderBy(cosineDistance(products.embedding, queryVector))
  .limit(10);
```

### PostGIS

1. **Always use indexes** on geometry columns
2. **Choose appropriate SRID** (4326 for GPS, local projections for precision)
3. **Use `::geography` for accurate distance** on large scales
4. **Filter with bounding box** before exact distance calculation

```typescript
// Good: BBox filter first, then exact distance
const nearby = await db
  .select()
  .from(locations)
  .where(
    and(
      // Fast index-based BBox check
      sql`${locations.geom} && ST_Expand(ST_MakePoint(${lng}, ${lat})::geography, ${radius})::geometry`,
      // Precise distance calculation
      sql`ST_DWithin(
        ${locations.geom}::geography,
        ST_MakePoint(${lng}, ${lat})::geography,
        ${radius}
      )`
    )
  );
```
