# Transactions

SQL transactions group one or more SQL statements into a single logical unit that either commits entirely or rolls back (undone) entirely.

## Basic Usage

```typescript
const db = drizzle(...)

await db.transaction(async (tx) => {
  await tx.update(accounts).set({ balance: sql`${accounts.balance} - 100.00` }).where(eq(users.name, 'Dan'));
  await tx.update(accounts).set({ balance: sql`${accounts.balance} + 100.00` }).where(eq(users.name, 'Andrew'));
});
```

## Nested Transactions (Savepoints)

Drizzle supports savepoints with nested transactions:

```typescript
await db.transaction(async (tx) => {
  await tx.update(accounts).set({ balance: sql`${accounts.balance} - 100.00` }).where(eq(users.name, 'Dan'));
  await tx.update(accounts).set({ balance: sql`${accounts.balance} + 100.00` }).where(eq(users.name, 'Andrew'));

  await tx.transaction(async (tx2) => {
    await tx2.update(users).set({ name: "Mr. Dan" }).where(eq(users.name, "Dan"));
  });
});
```

## Conditional Rollback

Embed business logic and rollback when needed:

```typescript
await db.transaction(async (tx) => {
  const [account] = await tx.select({ balance: accounts.balance }).from(accounts).where(eq(users.name, 'Dan'));
  if (account.balance < 100) {
    // This throws an exception that rollbacks the transaction
    tx.rollback()
  }

  await tx.update(accounts).set({ balance: sql`${accounts.balance} - 100.00` }).where(eq(users.name, 'Dan'));
  await tx.update(accounts).set({ balance: sql`${accounts.balance} + 100.00` }).where(eq(users.name, 'Andrew'));
});
```

## Return Values

Return values from transactions:

```typescript
const newBalance: number = await db.transaction(async (tx) => {
  await tx.update(accounts).set({ balance: sql`${accounts.balance} - 100.00` }).where(eq(users.name, 'Dan'));
  await tx.update(accounts).set({ balance: sql`${accounts.balance} + 100.00` }).where(eq(users.name, 'Andrew'));

  const [account] = await tx.select({ balance: accounts.balance }).from(accounts).where(eq(users.name, 'Dan'));
  return account.balance;
});
```

## Relational Queries in Transactions

Use relational queries within transactions:

```typescript
const db = drizzle({ schema })

await db.transaction(async (tx) => {
  await tx.query.users.findMany({
    with: {
      accounts: true
    }
  });
});
```

## Database-Specific Configurations

### PostgreSQL

```typescript
await db.transaction(
  async (tx) => {
    await tx.update(accounts).set({ balance: sql`${accounts.balance} - 100.00` }).where(eq(users.name, "Dan"));
    await tx.update(accounts).set({ balance: sql`${accounts.balance} + 100.00` }).where(eq(users.name, "Andrew"));
  }, {
    isolationLevel: "read committed",
    accessMode: "read write",
    deferrable: true,
  }
);

interface PgTransactionConfig {
  isolationLevel?:
    | "read uncommitted"
    | "read committed"
    | "repeatable read"
    | "serializable";
  accessMode?: "read only" | "read write";
  deferrable?: boolean;
}
```

### MySQL

```typescript
await db.transaction(
  async (tx) => {
    await tx.update(accounts).set({ balance: sql`${accounts.balance} - 100.00` }).where(eq(users.name, "Dan"));
    await tx.update(accounts).set({ balance: sql`${accounts.balance} + 100.00` }).where(eq(users.name, "Andrew"));
  }, {
    isolationLevel: "read committed",
    accessMode: "read write",
    withConsistentSnapshot: true,
  }
);

interface MySqlTransactionConfig {
  isolationLevel?:
    | "read uncommitted"
    | "read committed"
    | "repeatable read"
    | "serializable";
  accessMode?: "read only" | "read write";
  withConsistentSnapshot?: boolean;
}
```

### SQLite

```typescript
await db.transaction(
  async (tx) => {
    await tx.update(accounts).set({ balance: sql`${accounts.balance} - 100.00` }).where(eq(users.name, "Dan"));
    await tx.update(accounts).set({ balance: sql`${accounts.balance} + 100.00` }).where(eq(users.name, "Andrew"));
  }, {
    behavior: "deferred",
  }
);

interface SQLiteTransactionConfig {
    behavior?: 'deferred' | 'immediate' | 'exclusive';
}
```

### SingleStore

```typescript
await db.transaction(
  async (tx) => {
    await tx.update(accounts).set({ balance: sql`${accounts.balance} - 100.00` }).where(eq(users.name, "Dan"));
    await tx.update(accounts).set({ balance: sql`${accounts.balance} + 100.00` }).where(eq(users.name, "Andrew"));
  }, {
    isolationLevel: "read committed",
    accessMode: "read write",
    withConsistentSnapshot: true,
  }
);

interface SingleStoreTransactionConfig {
  isolationLevel?:
    | "read uncommitted"
    | "read committed"
    | "repeatable read"
    | "serializable";
  accessMode?: "read only" | "read write";
  withConsistentSnapshot?: boolean;
}
```

### MSSQL

```typescript
await db.transaction(
  async (tx) => {
    await tx.update(accounts).set({ balance: sql`${accounts.balance} - 100.00` }).where(eq(users.name, "Dan"));
    await tx.update(accounts).set({ balance: sql`${accounts.balance} + 100.00` }).where(eq(users.name, "Andrew"));
  }, {
    isolationLevel: "read committed",
  }
);

interface MsSqlTransactionConfig {
  isolationLevel?: 'read uncommitted' | 'read committed' | 'repeatable read' | 'serializable' | 'snapshot';
}
```

### CockroachDB

```typescript
await db.transaction(
  async (tx) => {
    await tx.update(accounts).set({ balance: sql`${accounts.balance} - 100.00` }).where(eq(users.name, "Dan"));
    await tx.update(accounts).set({ balance: sql`${accounts.balance} + 100.00` }).where(eq(users.name, "Andrew"));
  }, {
    isolationLevel: "read committed",
    accessMode: "read write",
    deferrable: true,
  }
);

interface CockroachTransactionConfig {
  isolationLevel?:
    | "read uncommitted"
    | "read committed"
    | "repeatable read"
    | "serializable";
  accessMode?: "read only" | "read write";
  deferrable?: boolean;
}
```

## Best Practices

### 1. Keep Transactions Short

```typescript
// ✅ Good - minimal work in transaction
await db.transaction(async (tx) => {
  await tx.insert(orders).values(orderData);
  await tx.insert(orderItems).values(itemsData);
});

// ❌ Bad - too much work in transaction
await db.transaction(async (tx) => {
  // Fetch external API data
  const data = await fetchExternalAPI();
  // Process data
  const processed = processData(data);
  // Then insert
  await tx.insert(orders).values(processed);
});
```

### 2. Handle Errors Properly

```typescript
try {
  await db.transaction(async (tx) => {
    await tx.insert(accounts).values({ balance: 100 });
    await tx.insert(transactions).values({ amount: 100 });
  });
} catch (error) {
  // Transaction automatically rolled back
  console.error('Transaction failed:', error);
  // Handle error appropriately
}
```

### 3. Use Read-Only Mode When Possible

```typescript
// For read-only operations, use read-only mode
await db.transaction(
  async (tx) => {
    const accounts = await tx.select().from(accountsTable);
    const transactions = await tx.select().from(transactionsTable);
    return { accounts, transactions };
  }, {
    accessMode: "read only",
  }
);
```

### 4. Choose Appropriate Isolation Level

```typescript
// For critical financial operations, use serializable
await db.transaction(
  async (tx) => {
    await transferFunds(tx, fromAccount, toAccount, amount);
  }, {
    isolationLevel: "serializable",
  }
);

// For simple reads, read committed is sufficient
await db.transaction(
  async (tx) => {
    return await tx.select().from(users);
  }, {
    isolationLevel: "read committed",
  }
);
```

### 5. Use Savepoints for Complex Operations

```typescript
await db.transaction(async (tx) => {
  // Main operation
  await tx.insert(orders).values(orderData);
  
  // Sub-operation that might fail independently
  await tx.transaction(async (tx2) => {
    try {
      await tx2.insert(orderItems).values(itemsData);
    } catch (error) {
      // Only rollbacks this nested transaction
      tx2.rollback();
      // Try alternative
      await tx2.insert(fallbackItems).values(fallbackData);
    }
  });
});
```
