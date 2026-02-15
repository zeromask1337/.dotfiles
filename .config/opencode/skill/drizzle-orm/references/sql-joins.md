# SQL Joins Reference

Comprehensive guide to SQL joins in Drizzle ORM.

## Join Types

Drizzle ORM supports: `INNER JOIN [LATERAL]`, `FULL JOIN`, `LEFT JOIN [LATERAL]`, `RIGHT JOIN`, `CROSS JOIN [LATERAL]`.

### Schema Setup

```typescript
export const users = pgTable('users', {
  id: serial('id').primaryKey(),
  name: text('name').notNull(),
});

export const pets = pgTable('pets', {
  id: serial('id').primaryKey(),
  name: text('name').notNull(),
  ownerId: integer('owner_id').notNull().references(() => users.id),
});
```

## Left Join

Returns all records from the left table and matched records from the right table. Unmatched records will have `null` values.

```typescript
const result = await db
  .select()
  .from(users)
  .leftJoin(pets, eq(users.id, pets.ownerId));
```

```sql
SELECT * FROM "users" 
LEFT JOIN "pets" ON "users"."id" = "pets"."owner_id"
```

**Result type:**
```typescript
{
  user: { id: number; name: string };
  pets: { id: number; name: string; ownerId: number } | null;
}[]
```

### Left Join Lateral

PostgreSQL-specific feature allowing subqueries to reference columns from the outer query.

```typescript
const subquery = db
  .select()
  .from(pets)
  .where(gte(users.age, 16))
  .as('userPets');

const result = await db
  .select()
  .from(users)
  .leftJoinLateral(subquery, sql`true`);
```

```sql
SELECT * FROM "users" 
LEFT JOIN LATERAL (
  SELECT * FROM "pets" WHERE "users"."age" >= 16
) "userPets" ON true
```

## Right Join

Returns all records from the right table and matched records from the left table.

```typescript
const result = await db
  .select()
  .from(users)
  .rightJoin(pets, eq(users.id, pets.ownerId));
```

```sql
SELECT * FROM "users" 
RIGHT JOIN "pets" ON "users"."id" = "pets"."owner_id"
```

**Result type:**
```typescript
{
  user: { id: number; name: string } | null;
  pets: { id: number; name: string; ownerId: number };
}[]
```

## Inner Join

Returns only records that have matching values in both tables.

```typescript
const result = await db
  .select()
  .from(users)
  .innerJoin(pets, eq(users.id, pets.ownerId));
```

```sql
SELECT * FROM "users" 
INNER JOIN "pets" ON "users"."id" = "pets"."owner_id"
```

**Result type:**
```typescript
{
  user: { id: number; name: string };
  pets: { id: number; name: string; ownerId: number };
}[]
```

### Inner Join Lateral

```typescript
const subquery = db
  .select()
  .from(pets)
  .where(gte(users.age, 16))
  .as('userPets');

const result = await db
  .select()
  .from(users)
  .innerJoinLateral(subquery, sql`true`);
```

## Full Join

Returns all records when there's a match in either left or right table. Non-matching fields will be `null`.

```typescript
const result = await db
  .select()
  .from(users)
  .fullJoin(pets, eq(users.id, pets.ownerId));
```

```sql
SELECT * FROM "users" 
FULL JOIN "pets" ON "users"."id" = "pets"."owner_id"
```

**Result type:**
```typescript
{
  user: { id: number; name: string } | null;
  pets: { id: number; name: string; ownerId: number } | null;
}[]
```

## Cross Join

Returns the Cartesian product of both tables (all combinations).

```typescript
const result = await db
  .select()
  .from(users)
  .crossJoin(pets);
```

```sql
SELECT * FROM "users" 
CROSS JOIN "pets"
```

### Cross Join Lateral

```typescript
const subquery = db
  .select()
  .from(pets)
  .where(gte(users.age, 16))
  .as('userPets');

const result = await db
  .select()
  .from(users)
  .crossJoinLateral(subquery);
```

## Partial Select with Joins

Select specific columns while joining:

```typescript
await db
  .select({
    userId: users.id,
    petId: pets.id,
  })
  .from(users)
  .leftJoin(pets, eq(users.id, pets.ownerId));
```

```sql
SELECT "users"."id", "pets"."id" 
FROM "users" 
LEFT JOIN "pets" ON "users"."id" = "pets"."owner_id"
```

**Result type:**
```typescript
{
  userId: number;
  petId: number | null;  // nullable because of left join
}[]
```

### Nested Select Object

When joining tables with many columns, use nested select to make the whole object nullable:

```typescript
await db
  .select({
    userId: users.id,
    userName: users.name,
    pet: {
      id: pets.id,
      name: pets.name,
      upperName: sql<string>`upper(${pets.name})`
    }
  })
  .from(users)
  .fullJoin(pets, eq(users.id, pets.ownerId));
```

**Result type:**
```typescript
{
  userId: number | null;
  userName: string | null;
  pet: {
    id: number;
    name: string;
    upperName: string;
  } | null;  // whole object nullable, not individual fields
}[]
```

**Important:** When using `sql` in partial select with joins, explicitly specify nullable types:

```typescript
const result = await db.select({
  userId: users.id,
  petId: pets.id,
  petName1: sql`upper(${pets.name})`,                    // type: unknown
  petName2: sql<string | null>`upper(${pets.name})`,    // type: string | null
}).from(users).leftJoin(pets, eq(users.id, pets.ownerId));
```

## Aliases & Self Joins

Use aliases for self joins or joining the same table multiple times:

```typescript
import { alias } from 'drizzle-orm/pg-core';

const parent = alias(user, 'parent');

const result = await db
  .select()
  .from(user)
  .leftJoin(parent, eq(parent.id, user.parentId));
```

```sql
SELECT * FROM "user" 
LEFT JOIN "user" "parent" ON "parent"."id" = "user"."parent_id"
```

**Schema for self join:**
```typescript
export const user = pgTable('user', {
  id: integer('id').primaryKey({ autoIncrement: true }),
  name: text('name').notNull(),
  parentId: integer('parent_id').notNull()
    .references((): AnyPgColumn => user.id)
});
```

## Multiple Joins

Chain multiple joins together:

```typescript
const result = await db
  .select()
  .from(users)
  .leftJoin(pets, eq(users.id, pets.ownerId))
  .leftJoin(veterinarians, eq(pets.vetId, veterinarians.id))
  .innerJoin(clinics, eq(veterinarians.clinicId, clinics.id));
```

## Aggregating Results

Drizzle returns name-mapped results. Aggregate many-to-one relationships:

```typescript
type User = typeof users.$inferSelect;
type Pet = typeof pets.$inferSelect;

const rows = await db
  .select({
    user: users,
    pet: pets,
  })
  .from(users)
  .leftJoin(pets, eq(users.id, pets.ownerId));

// Group results by user
const result = rows.reduce<Record<number, { user: User; pets: Pet[] }>>(
  (acc, row) => {
    const user = row.user;
    const pet = row.pet;

    if (!acc[user.id]) {
      acc[user.id] = { user, pets: [] };
    }

    if (pet) {
      acc[user.id].pets.push(pet);
    }

    return acc;
  },
  {}
);
```

## Complex Join Conditions

Join with multiple conditions:

```typescript
await db
  .select()
  .from(users)
  .leftJoin(
    pets,
    and(
      eq(users.id, pets.ownerId),
      eq(pets.active, true),
      gte(pets.age, 2)
    )
  );
```

## Database Support

| Join Type | PostgreSQL | MySQL | SQLite | SingleStore | MSSQL | CockroachDB |
|-----------|-----------|-------|---------|-------------|-------|-------------|
| LEFT JOIN | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| LEFT JOIN LATERAL | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| RIGHT JOIN | ✅ | ✅ | ❌ | ✅ | ✅ | ✅ |
| INNER JOIN | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| INNER JOIN LATERAL | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| FULL JOIN | ✅ | ❌ | ❌ | ❌ | ✅ | ✅ |
| CROSS JOIN | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| CROSS JOIN LATERAL | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |

## Practical Examples

### Many-to-One

```typescript
const cities = sqliteTable('cities', {
  id: integer('id').primaryKey(),
  name: text('name'),
});

const users = sqliteTable('users', {
  id: integer('id').primaryKey(),
  name: text('name'),
  cityId: integer('city_id').references(() => cities.id)
});

const result = await db
  .select()
  .from(cities)
  .leftJoin(users, eq(cities.id, users.cityId));
```

### Many-to-Many

```typescript
const users = sqliteTable('users', {
  id: integer('id').primaryKey(),
  name: text('name'),
});

const groups = sqliteTable('groups', {
  id: integer('id').primaryKey(),
  name: text('name'),
});

const usersToGroups = sqliteTable('users_to_groups', {
  userId: integer('user_id').references(() => users.id),
  groupId: integer('group_id').references(() => groups.id),
});

// Query users with their groups
const result = await db
  .select({
    user: users,
    group: groups,
  })
  .from(users)
  .leftJoin(usersToGroups, eq(users.id, usersToGroups.userId))
  .leftJoin(groups, eq(usersToGroups.groupId, groups.id));
```
