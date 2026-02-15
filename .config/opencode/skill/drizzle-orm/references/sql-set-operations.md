# Set Operations Reference

SQL set operations combine results from multiple queries into a single result.

**Operations:** `UNION`, `UNION ALL`, `INTERSECT`, `INTERSECT ALL`, `EXCEPT`, `EXCEPT ALL`

## Union

Combines results from two queries, **omitting duplicates**.

### Usage Pattern (Import)

```typescript
import { union } from 'drizzle-orm/pg-core';
import { users, customers } from './schema';

const userNames = db.select({ name: users.name }).from(users);
const customerNames = db.select({ name: customers.name }).from(customers);

const result = await union(userNames, customerNames).limit(10);
```

```sql
(SELECT "name" FROM "users")
UNION
(SELECT "name" FROM "customers")
LIMIT $1
```

### Builder Pattern

```typescript
const result = await db
  .select({ name: users.name })
  .from(users)
  .union(db.select({ name: customers.name }).from(customers))
  .limit(10);
```

## Union All

Combines results from two queries, **including duplicates**.

### Use Case: Combining Sales Data

When you have online and in-store sales in separate tables and want all transactions:

```typescript
import { unionAll } from 'drizzle-orm/pg-core';

const onlineTransactions = db
  .select({ transaction: onlineSales.transactionId })
  .from(onlineSales);

const inStoreTransactions = db
  .select({ transaction: inStoreSales.transactionId })
  .from(inStoreSales);

const result = await unionAll(onlineTransactions, inStoreTransactions);
```

```sql
SELECT "transaction_id" FROM "online_sales"
UNION ALL
SELECT "transaction_id" FROM "in_store_sales"
```

### Builder Pattern

```typescript
const result = await db
  .select({ transaction: onlineSales.transactionId })
  .from(onlineSales)
  .unionAll(
    db.select({ transaction: inStoreSales.transactionId }).from(inStoreSales)
  );
```

## Intersect

Returns only rows that exist in **both** query results, omitting duplicates.

### Use Case: Common Course Enrollments

Find courses common to both departments:

```typescript
import { intersect } from 'drizzle-orm/pg-core';

const departmentACourses = db
  .select({ courseName: depA.courseName })
  .from(depA);

const departmentBCourses = db
  .select({ courseName: depB.courseName })
  .from(depB);

const result = await intersect(departmentACourses, departmentBCourses);
```

```sql
SELECT "course_name" FROM "department_a_courses"
INTERSECT
SELECT "course_name" FROM "department_b_courses"
```

## Intersect All

Returns rows that exist in both query results, **including duplicates**.

```typescript
import { intersectAll } from 'drizzle-orm/pg-core';

const result = await intersectAll(
  db.select({ name: students.name }).from(students),
  db.select({ name: teachers.name }).from(teachers)
);
```

## Except

Returns rows from first query that **don't exist** in second query, omitting duplicates.

### Use Case: Students Without Grades

Find students who haven't received grades:

```typescript
import { except } from 'drizzle-orm/pg-core';

const allStudents = db
  .select({ studentId: students.studentId })
  .from(students);

const studentsWithGrades = db
  .select({ studentId: grades.studentId })
  .from(grades);

const result = await except(allStudents, studentsWithGrades);
```

```sql
SELECT "student_id" FROM "students"
EXCEPT
SELECT "student_id" FROM "grades"
```

## Except All

Returns rows from first query that don't exist in second query, **including duplicates**.

```typescript
import { exceptAll } from 'drizzle-orm/pg-core';

const result = await exceptAll(
  db.select({ name: allUsers.name }).from(allUsers),
  db.select({ name: bannedUsers.name }).from(bannedUsers)
);
```

## Database-Specific Imports

### PostgreSQL
```typescript
import { union, unionAll, intersect, intersectAll, except, exceptAll } from 'drizzle-orm/pg-core';
```

### MySQL
```typescript
import { union, unionAll, intersect, except } from 'drizzle-orm/mysql-core';
```

### SQLite
```typescript
import { union, unionAll, intersect, except } from 'drizzle-orm/sqlite-core';
```

### SingleStore
```typescript
import { union, unionAll, intersect, except } from 'drizzle-orm/singlestore-core';
```

**Note:** SingleStore UNION ALL with ORDER BY behaves differently from MySQL:
```sql
-- Valid in SingleStore, invalid in MySQL
SELECT ... UNION ALL SELECT ... ORDER BY ...
```

### MSSQL
```typescript
import { union, unionAll, intersect, except } from 'drizzle-orm/mssql-core';
```

### CockroachDB
```typescript
import { union, unionAll, intersect, intersectAll, except, exceptAll } from 'drizzle-orm/cockroach-core';
```

## Chaining Set Operations

Combine multiple operations:

```typescript
const result = await union(
  intersect(
    db.select({ id: activeUsers.id }).from(activeUsers),
    db.select({ id: premiumUsers.id }).from(premiumUsers)
  ),
  db.select({ id: adminUsers.id }).from(adminUsers)
).limit(100);
```

## With Ordering and Pagination

All set operations support `.orderBy()`, `.limit()`, and `.offset()`:

```typescript
const result = await union(
  db.select({ name: users.name }).from(users),
  db.select({ name: customers.name }).from(customers)
)
  .orderBy(sql`name`)
  .limit(20)
  .offset(40);
```

## Type Requirements

Set operations require matching column types:

```typescript
// ✅ Correct: same column name and type
const result = await union(
  db.select({ name: users.name }).from(users),      // varchar(255)
  db.select({ name: customers.name }).from(customers) // varchar(255)
);

// ❌ Error: different column names
const result = await union(
  db.select({ name: users.name }).from(users),
  db.select({ fullName: customers.name }).from(customers)
);
```

## Database Support

| Operation | PostgreSQL | MySQL | SQLite | SingleStore | MSSQL | CockroachDB |
|-----------|-----------|-------|---------|-------------|-------|-------------|
| UNION | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| UNION ALL | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| INTERSECT | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| INTERSECT ALL | ✅ | ❌ | ❌ | ❌ | ❌ | ✅ |
| EXCEPT | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| EXCEPT ALL | ✅ | ❌ | ❌ | ❌ | ❌ | ✅ |

## Practical Examples

### Combined User Search

Search across multiple user tables:

```typescript
const searchTerm = 'john';

const result = await union(
  db.select({ 
    id: users.id, 
    name: users.name, 
    source: sql<string litral>'users'` 
  }).from(users).where(ilike(users.name, `%${searchTerm}%`)),
  db.select({ 
    id: archivedUsers.id, 
    name: archivedUsers.name, 
    source: sql<string litral>'archived'` 
  }).from(archivedUsers).where(ilike(archivedUsers.name, `%${searchTerm}%`))
).orderBy(sql`name`);
```

### Finding New vs Returning Customers

```typescript
// New customers: registered in last 30 days, no previous orders
const newCustomers = except(
  db.select({ id: users.id }).from(users)
    .where(gte(users.createdAt, sql`now() - interval '30 days'`)),
  db.select({ id: orders.userId }).from(orders)
);

// Returning customers: have orders in both this month and last month
const returningCustomers = intersect(
  db.select({ userId: orders.userId }).from(orders)
    .where(gte(orders.createdAt, sql`date_trunc('month', now())`)),
  db.select({ userId: orders.userId }).from(orders)
    .where(between(orders.createdAt, 
      sql`date_trunc('month', now() - interval '1 month')`,
      sql`date_trunc('month', now())`
    ))
);
```

### Duplicate Detection

Find records that appear multiple times:

```typescript
// Using EXCEPT ALL to find true duplicates
const baseQuery = db.select({ email: users.email }).from(users);
const distinctQuery = db.select({ email: users.email }).from(users).groupBy(users.email);

// Emails that appear more than once
const duplicates = await exceptAll(baseQuery, distinctQuery);
```
