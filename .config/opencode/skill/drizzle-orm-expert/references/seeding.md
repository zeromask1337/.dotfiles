# Drizzle Seed

TypeScript library for generating deterministic, realistic fake data.

**Features:**
- Deterministic data generation (same seed = same data)
- Reproducible across different runs
- Supports all major databases

**Requirements:**
- `drizzle-orm@0.36.4` or higher (required for identity columns and type fixes)

## Installation

```bash
npm i drizzle-seed
```

## Basic Usage

Create 10 users with random names and IDs:

```typescript
import { pgTable, integer, text } from "drizzle-orm/pg-core";
import { drizzle } from "drizzle-orm/node-postgres";
import { seed } from "drizzle-seed";

const users = pgTable("users", {
  id: integer().primaryKey(),
  name: text().notNull(),
});

async function main() {
  const db = drizzle(process.env.DATABASE_URL!);
  await seed(db, { users });
}

main();
```

## Options

### Count

Default is 10 entities. Override with `count` option:

```typescript
await seed(db, schema, { count: 1000 });
```

### Seed

Use different seed numbers for different data sets:

```typescript
await seed(db, schema, { seed: 12345 });
```

## Reset Database

Reset database before seeding (useful in test suites):

```typescript
import { reset } from "drizzle-seed";
import * as schema from "./schema.ts";

async function main() {
  const db = drizzle(process.env.DATABASE_URL!);
  await reset(db, schema);
}

main();
```

### Database-Specific Reset Strategies

**PostgreSQL:**
```sql
TRUNCATE tableName1, tableName2, ... CASCADE;
```

**MySQL:**
```sql
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE tableName1;
TRUNCATE tableName2;
...
SET FOREIGN_KEY_CHECKS = 1;
```

**SQLite:**
```sql
PRAGMA foreign_keys = OFF;
DELETE FROM tableName1;
DELETE FROM tableName2;
...
PRAGMA foreign_keys = ON;
```

**SingleStore:**
```sql
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE tableName1;
TRUNCATE tableName2;
...
SET FOREIGN_KEY_CHECKS = 1;
```

**CockroachDB:**
```sql
TRUNCATE tableName1, tableName2, ... CASCADE;
```

**MS SQL:**
```sql
-- Gather FK constraints info
ALTER TABLE [<schemaName>].[<tableName>] DROP CONSTRAINT [<fkName>];
TRUNCATE TABLE [<schemaName>].[<tableName>];
ALTER TABLE [<schemaName>].[<tableName>] 
ADD CONSTRAINT [<fkName>] 
FOREIGN KEY([<columnName>])
REFERENCES [<refSchemaName>].[<refTableName>] ([<refColumnName>])
ON DELETE <onDeleteAction>
ON UPDATE <onUpdateAction>;
```

## Refinements

Customize seed generation with `.refine()`:

```typescript
await seed(db, schema).refine((f) => ({
  users: {
    columns: {},
    count: 10,
    with: {
        posts: 10
    }
  },
}));
```

### Refinement Options

- `columns`: Generator function per column
- `count`: Number of rows (overrides global count)
- `with`: Number of related entities to create

### Example 1: Seed Only Users with Custom Names

```typescript
import { drizzle } from "drizzle-orm/node-postgres";
import { seed } from "drizzle-seed";
import * as schema from './schema.ts'

async function main() {
  const db = drizzle(process.env.DATABASE_URL!);

  await seed(db, { users: schema.users }).refine((f) => ({
    users: {
        columns: {
            name: f.fullName(),
        },
        count: 20
    }
  }));
}

main();
```

### Example 2: Seed Users with Posts

```typescript
await seed(db, schema).refine((f) => ({
  users: {
      count: 20,
      with: {
          posts: 10
      }
  }
}));
```

### Example 3: Custom ID Range and Values

```typescript
await seed(db, schema).refine((f) => ({
  users: {
      count: 5,
      columns: {
          id: f.int({
            minValue: 10000,
            maxValue: 20000,
            isUnique: true,
          }),
      }
  },
  posts: {
      count: 100,
      columns: {
          description: f.valuesFromArray({
          values: [
              "The sun set behind the mountains...", 
              "I can't believe how good this homemade pizza turned out!", 
              "Sometimes, all you need is a good book...", 
              // ...
          ],
        })
      }
  }
}));
```

## Weighted Random

Use multiple datasets with different priorities:

### Column Weighted Random

Generate 5000 random prices:
- 30% chance: prices between 10-100
- 70% chance: prices between 100-300

```typescript
await seed(db, schema).refine((f) => ({
  orders: {
     count: 5000,
     columns: {
         unitPrice: f.weightedRandom(
             [
                 {
                     weight: 0.3,
                     value: f.int({ minValue: 10, maxValue: 100 })
                 },
                 {
                     weight: 0.7,
                     value: f.number({ minValue: 100, maxValue: 300, precision: 100 })
                 }
             ]
         ),
     }
  }
}));
```

### Related Entities Weighted Random

For each order, generate:
- 60% chance: 1-3 details
- 30% chance: 5-7 details
- 10% chance: 8-10 details

```typescript
await seed(db, schema).refine((f) => ({
  orders: {
     with: {
         details:
             [
                 { weight: 0.6, count: [1, 2, 3] },
                 { weight: 0.3, count: [5, 6, 7] },
                 { weight: 0.1, count: [8, 9, 10] },
             ]
     }
  }
}));
```

## Complex Example

```typescript
const main = async () => {
    const titlesOfCourtesy = ["Ms.", "Mrs.", "Dr."];
    const unitsOnOrders = [0, 10, 20, 30, 50, 60, 70, 80, 100];
    const reorderLevels = [0, 5, 10, 15, 20, 25, 30];
    const quantityPerUnit = [
        "100 - 100 g pieces",
        "100 - 250 g bags",
        "10 - 200 g glasses",
    ];
    const discounts = [0.05, 0.15, 0.2, 0.25];

    await seed(db, schema).refine((funcs) => ({
        customers: {
            count: 10000,
            columns: {
                companyName: funcs.companyName(),
                contactName: funcs.fullName(),
                contactTitle: funcs.jobTitle(),
                address: funcs.streetAddress(),
                city: funcs.city(),
                postalCode: funcs.postcode(),
                region: funcs.state(),
                country: funcs.country(),
                phone: funcs.phoneNumber({ template: "(###) ###-####" }),
                fax: funcs.phoneNumber({ template: "(###) ###-####" })
            }
        },
        employees: {
            count: 200,
            columns: {
                firstName: funcs.firstName(),
                lastName: funcs.lastName(),
                title: funcs.jobTitle(),
                titleOfCourtesy: funcs.valuesFromArray({ values: titlesOfCourtesy }),
                birthDate: funcs.date({ minDate: "2010-12-31", maxDate: "2010-12-31" }),
                hireDate: funcs.date({ minDate: "2010-12-31", maxDate: "2024-08-26" }),
                address: funcs.streetAddress(),
                city: funcs.city(),
                postalCode: funcs.postcode(),
                country: funcs.country(),
                homePhone: funcs.phoneNumber({ template: "(###) ###-####" }),
                extension: funcs.int({ minValue: 428, maxValue: 5467 }),
                notes: funcs.loremIpsum()
            }
        },
        orders: {
            count: 50000,
            columns: {
                shipVia: funcs.int({ minValue: 1, maxValue: 3 }),
                freight: funcs.number({ minValue: 0, maxValue: 1000, precision: 100 }),
                shipName: funcs.streetAddress(),
                shipCity: funcs.city(),
                shipRegion: funcs.state(),
                shipPostalCode: funcs.postcode(),
                shipCountry: funcs.country()
            },
            with: {
                details: [
                    { weight: 0.6, count: [1, 2, 3] },
                    { weight: 0.3, count: [4, 5, 6] },
                    { weight: 0.1, count: [7, 8, 9, 10] }
                ]
            }
        }
    }));
};

main();
```

## Database Support

| Database | Support |
|----------|---------|
| PostgreSQL | ✅ |
| MySQL | ✅ |
| SQLite | ✅ |
| SingleStore | ✅ |
| CockroachDB | ✅ |
| MS SQL | ✅ |

## Best Practices

### 1. Use Deterministic Seeds for Tests

```typescript
// Same seed = same data every test run
await seed(db, schema, { seed: 12345 });
```

### 2. Reset Before Seeding in Tests

```typescript
beforeEach(async () => {
  await reset(db, schema);
  await seed(db, schema, { seed: 12345 });
});
```

### 3. Use Weighted Random for Realistic Data

```typescript
// Realistic order distribution
await seed(db, schema).refine((f) => ({
  orders: {
    with: {
      // Most orders have 1-2 items, some have many
      items: [
        { weight: 0.7, count: [1, 2] },
        { weight: 0.2, count: [3, 4, 5] },
        { weight: 0.1, count: [6, 7, 8, 9, 10] }
      ]
    }
  }
}));
```

### 4. Generate Consistent Foreign Key References

```typescript
// Ensure referential integrity
await seed(db, schema).refine((f) => ({
  users: {
    count: 100,
    columns: {
      id: f.int({ minValue: 1, maxValue: 100, isUnique: true }),
    }
  },
  posts: {
    count: 500,
    columns: {
      userId: f.int({ minValue: 1, maxValue: 100 }), // References users 1-100
    }
  }
}));
```
