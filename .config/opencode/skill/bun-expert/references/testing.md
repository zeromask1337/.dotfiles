# Test runner
Source: https://bun.com/docs/test/index

Bun's fast, built-in, Jest-compatible test runner with TypeScript support, lifecycle hooks, mocking, and watch mode

Bun ships with a fast, built-in, Jest-compatible test runner. Tests are executed with the Bun runtime, and support the following features.

* TypeScript and JSX
* Lifecycle hooks
* Snapshot testing
* UI & DOM testing
* Watch mode with `--watch`
* Script pre-loading with `--preload`

<Note>
  Bun aims for compatibility with Jest, but not everything is implemented. To track compatibility, see [this tracking
  issue](https://github.com/oven-sh/bun/issues/1825).
</Note>

## Run tests

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun test
```

Tests are written in JavaScript or TypeScript with a Jest-like API. Refer to [Writing tests](/test/writing-tests) for full documentation.

```ts math.test.ts icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { expect, test } from "bun:test";

test("2 + 2", () => {
  expect(2 + 2).toBe(4);
});
```

The runner recursively searches the working directory for files that match the following patterns:

* `*.test.{js|jsx|ts|tsx}`
* `*_test.{js|jsx|ts|tsx}`
* `*.spec.{js|jsx|ts|tsx}`
* `*_spec.{js|jsx|ts|tsx}`

You can filter the set of *test files* to run by passing additional positional arguments to `bun test`. Any test file with a path that matches one of the filters will run. Commonly, these filters will be file or directory names; glob patterns are not yet supported.

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun test <filter> <filter> ...
```

To filter by *test name*, use the `-t`/`--test-name-pattern` flag.

```sh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
# run all tests or test suites with "addition" in the name
bun test --test-name-pattern addition
```

To run a specific file in the test runner, make sure the path starts with `./` or `/` to distinguish it from a filter name.

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun test ./test/specific-file.test.ts
```

The test runner runs all tests in a single process. It loads all `--preload` scripts (see [Lifecycle](/test/lifecycle) for details), then runs all tests. If a test fails, the test runner will exit with a non-zero exit code.

## CI/CD integration

`bun test` supports a variety of CI/CD integrations.

### GitHub Actions

`bun test` automatically detects if it's running inside GitHub Actions and will emit GitHub Actions annotations to the console directly.

No configuration is needed, other than installing `bun` in the workflow and running `bun test`.

#### How to install `bun` in a GitHub Actions workflow

To use `bun test` in a GitHub Actions workflow, add the following step:

```yaml title=".github/workflows/test.yml" icon="file-code" theme={"theme":{"light":"github-light","dark":"dracula"}}
jobs:
  build:
    name: build-app
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4
      - name: Install bun
        uses: oven-sh/setup-bun@v2
      - name: Install dependencies # (assuming your project has dependencies)
        run: bun install # You can use npm/yarn/pnpm instead if you prefer
      - name: Run tests
        run: bun test
```

From there, you'll get GitHub Actions annotations.

### JUnit XML reports (GitLab, etc.)

To use `bun test` with a JUnit XML reporter, you can use the `--reporter=junit` in combination with `--reporter-outfile`.

```sh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun test --reporter=junit --reporter-outfile=./bun.xml
```

This will continue to output to stdout/stderr as usual, and also write a JUnit
XML report to the given path at the very end of the test run.

JUnit XML is a popular format for reporting test results in CI/CD pipelines.

## Timeouts

Use the `--timeout` flag to specify a *per-test* timeout in milliseconds. If a test times out, it will be marked as failed. The default value is `5000`.

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
# default value is 5000
bun test --timeout 20
```

## Concurrent test execution

By default, Bun runs all tests sequentially within each test file. You can enable concurrent execution to run async tests in parallel, significantly speeding up test suites with independent tests.

### `--concurrent` flag

Use the `--concurrent` flag to run all tests concurrently within their respective files:

```sh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun test --concurrent
```

When this flag is enabled, all tests will run in parallel unless explicitly marked with `test.serial`.

### `--max-concurrency` flag

Control the maximum number of tests running simultaneously with the `--max-concurrency` flag:

```sh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
# Limit to 4 concurrent tests
bun test --concurrent --max-concurrency 4

# Default: 20
bun test --concurrent
```

This helps prevent resource exhaustion when running many concurrent tests. The default value is 20.

### `test.concurrent`

Mark individual tests to run concurrently, even when the `--concurrent` flag is not used:

```ts title="math.test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { test, expect } from "bun:test";

// These tests run in parallel with each other
test.concurrent("concurrent test 1", async () => {
  await fetch("/api/endpoint1");
  expect(true).toBe(true);
});

test.concurrent("concurrent test 2", async () => {
  await fetch("/api/endpoint2");
  expect(true).toBe(true);
});

// This test runs sequentially
test("sequential test", () => {
  expect(1 + 1).toBe(2);
});
```

### `test.serial`

Force tests to run sequentially, even when the `--concurrent` flag is enabled:

```ts title="math.test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { test, expect } from "bun:test";

let sharedState = 0;

// These tests must run in order
test.serial("first serial test", () => {
  sharedState = 1;
  expect(sharedState).toBe(1);
});

test.serial("second serial test", () => {
  // Depends on the previous test
  expect(sharedState).toBe(1);
  sharedState = 2;
});

// This test can run concurrently if --concurrent is enabled
test("independent test", () => {
  expect(true).toBe(true);
});

// Chaining test qualifiers
test.failing.each([1, 2, 3])("chained qualifiers %d", input => {
  expect(input).toBe(0); // This test is expected to fail for each input
});
```

## Rerun tests

Use the `--rerun-each` flag to run each test multiple times. This is useful for detecting flaky or non-deterministic test failures.

```sh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun test --rerun-each 100
```

## Randomize test execution order

Use the `--randomize` flag to run tests in a random order. This helps detect tests that depend on shared state or execution order.

```sh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun test --randomize
```

When using `--randomize`, the seed used for randomization will be displayed in the test summary:

```sh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun test --randomize
```

```txt theme={"theme":{"light":"github-light","dark":"dracula"}}
# ... test output ...
 --seed=12345
 2 pass
 8 fail
Ran 10 tests across 2 files. [50.00ms]
```

### Reproducible random order with `--seed`

Use the `--seed` flag to specify a seed for the randomization. This allows you to reproduce the same test order when debugging order-dependent failures.

```sh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
# Reproduce a previous randomized run
bun test --seed 123456
```

The `--seed` flag implies `--randomize`, so you don't need to specify both. Using the same seed value will always produce the same test execution order, making it easier to debug intermittent failures caused by test interdependencies.

## Bail out with `--bail`

Use the `--bail` flag to abort the test run early after a pre-determined number of test failures. By default Bun will run all tests and report all failures, but sometimes in CI environments it's preferable to terminate earlier to reduce CPU usage.

```sh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
# bail after 1 failure
bun test --bail

# bail after 10 failure
bun test --bail=10
```

## Watch mode

Similar to `bun run`, you can pass the `--watch` flag to `bun test` to watch for changes and re-run tests.

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun test --watch
```

## Lifecycle hooks

Bun supports the following lifecycle hooks:

| Hook         | Description                 |
| ------------ | --------------------------- |
| `beforeAll`  | Runs once before all tests. |
| `beforeEach` | Runs before each test.      |
| `afterEach`  | Runs after each test.       |
| `afterAll`   | Runs once after all tests.  |

These hooks can be defined inside test files, or in a separate file that is preloaded with the `--preload` flag.

```sh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun test --preload ./setup.ts
```

See [Test > Lifecycle](/test/lifecycle) for complete documentation.

## Mocks

Create mock functions with the `mock` function.

```ts title="math.test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { test, expect, mock } from "bun:test";
const random = mock(() => Math.random());

test("random", () => {
  const val = random();
  expect(val).toBeGreaterThan(0);
  expect(random).toHaveBeenCalled();
  expect(random).toHaveBeenCalledTimes(1);
});
```

Alternatively, you can use `jest.fn()`, it behaves identically.

```ts title="math.test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { test, expect, mock } from "bun:test"; // [!code --]
import { test, expect, jest } from "bun:test"; // [!code ++]

const random = mock(() => Math.random()); // [!code --]
const random = jest.fn(() => Math.random()); // [!code ++]
```

See [Test > Mocks](/test/mocks) for complete documentation.

## Snapshot testing

Snapshots are supported by `bun test`.

```ts title="math.test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
// example usage of toMatchSnapshot
import { test, expect } from "bun:test";

test("snapshot", () => {
  expect({ a: 1 }).toMatchSnapshot();
});
```

To update snapshots, use the `--update-snapshots` flag.

```sh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun test --update-snapshots
```

See [Test > Snapshots](/test/snapshots) for complete documentation.

## UI & DOM testing

Bun is compatible with popular UI testing libraries:

* [HappyDOM](https://github.com/capricorn86/happy-dom)
* [DOM Testing Library](https://testing-library.com/docs/dom-testing-library/intro/)
* [React Testing Library](https://testing-library.com/docs/react-testing-library/intro)

See [Test > DOM Testing](/test/dom) for complete documentation.

## Performance

Bun's test runner is fast.

<Frame>
  <img alt="Running 266 React SSR tests faster than Jest can print its version number." />
</Frame>

## AI Agent Integration

When using Bun's test runner with AI coding assistants, you can enable quieter output to improve readability and reduce context noise. This feature minimizes test output verbosity while preserving essential failure information.

### Environment Variables

Set any of the following environment variables to enable AI-friendly output:

* `CLAUDECODE=1` - For Claude Code
* `REPL_ID=1` - For Replit
* `AGENT=1` - Generic AI agent flag

### Behavior

When an AI agent environment is detected:

* Only test failures are displayed in detail
* Passing, skipped, and todo test indicators are hidden
* Summary statistics remain intact

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
# Example: Enable quiet output for Claude Code
CLAUDECODE=1 bun test

# Still shows failures and summary, but hides verbose passing test output
```

This feature is particularly useful in AI-assisted development workflows where reduced output verbosity improves context efficiency while maintaining visibility into test failures.

***

# CLI Usage

```bash theme={"theme":{"light":"github-light","dark":"dracula"}}
bun test <patterns>
```

### Execution Control

<ParamField type="number">
  Set the per-test timeout in milliseconds (default 5000)
</ParamField>

<ParamField type="number">
  Re-run each test file <code>NUMBER</code> times, helps catch certain bugs
</ParamField>

<ParamField type="boolean">
  Treat all tests as <code>test.concurrent()</code> tests
</ParamField>

<ParamField type="boolean">
  Run tests in random order
</ParamField>

<ParamField type="number">
  Set the random seed for test randomization
</ParamField>

<ParamField type="number">
  Exit the test suite after <code>NUMBER</code> failures. If you do not specify a number, it defaults to 1.
</ParamField>

<ParamField type="number">
  Maximum number of concurrent tests to execute at once (default 20)
</ParamField>

### Test Filtering

<ParamField type="boolean">
  Include tests that are marked with <code>test.todo()</code>
</ParamField>

<ParamField type="string">
  Run only tests with a name that matches the given regex. Alias: <code>-t</code>
</ParamField>

### Reporting

<ParamField type="string">
  Test output reporter format. Available: <code>junit</code> (requires --reporter-outfile), <code>dots</code>. Default:
  console output.
</ParamField>

<ParamField type="string">
  Output file path for the reporter format (required with --reporter)
</ParamField>

<ParamField type="boolean">
  Enable dots reporter. Shorthand for --reporter=dots
</ParamField>

### Coverage

<ParamField type="boolean">
  Generate a coverage profile
</ParamField>

<ParamField type="string">
  Report coverage in <code>text</code> and/or <code>lcov</code>. Defaults to <code>text</code>
</ParamField>

<ParamField type="string">
  Directory for coverage files. Defaults to <code>coverage</code>
</ParamField>

### Snapshots

<ParamField type="boolean">
  Update snapshot files. Alias: <code>-u</code>
</ParamField>

## Examples

Run all test files:

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun test
```

Run all test files with "foo" or "bar" in the file name:

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun test foo bar
```

Run all test files, only including tests whose names includes "baz":

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun test --test-name-pattern baz
```


# Lifecycle hooks
Source: https://bun.com/docs/test/lifecycle

Learn how to use beforeAll, beforeEach, afterEach, and afterAll lifecycle hooks in Bun tests

The test runner supports the following lifecycle hooks. This is useful for loading test fixtures, mocking data, and configuring the test environment.

| Hook             | Description                                                |
| ---------------- | ---------------------------------------------------------- |
| `beforeAll`      | Runs once before all tests.                                |
| `beforeEach`     | Runs before each test.                                     |
| `afterEach`      | Runs after each test.                                      |
| `afterAll`       | Runs once after all tests.                                 |
| `onTestFinished` | Runs after a single test finishes (after all `afterEach`). |

## Per-Test Setup and Teardown

Perform per-test setup and teardown logic with `beforeEach` and `afterEach`.

```ts title="test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { beforeEach, afterEach, test } from "bun:test";

beforeEach(() => {
  console.log("running test.");
});

afterEach(() => {
  console.log("done with test.");
});

// tests...
test("example test", () => {
  // This test will have beforeEach run before it
  // and afterEach run after it
});
```

## Per-Scope Setup and Teardown

Perform per-scope setup and teardown logic with `beforeAll` and `afterAll`. The scope is determined by where the hook is defined.

### Scoped to a Describe Block

To scope the hooks to a particular describe block:

```ts title="test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { describe, beforeAll, afterAll, test } from "bun:test";

describe("test group", () => {
  beforeAll(() => {
    // setup for this describe block
    console.log("Setting up test group");
  });

  afterAll(() => {
    // teardown for this describe block
    console.log("Tearing down test group");
  });

  test("test 1", () => {
    // test implementation
  });

  test("test 2", () => {
    // test implementation
  });
});
```

### Scoped to a Test File

To scope the hooks to an entire test file:

```ts title="test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { describe, beforeAll, afterAll, test } from "bun:test";

beforeAll(() => {
  // setup for entire file
  console.log("Setting up test file");
});

afterAll(() => {
  // teardown for entire file
  console.log("Tearing down test file");
});

describe("test group", () => {
  test("test 1", () => {
    // test implementation
  });
});
```

### `onTestFinished`

Use `onTestFinished` to run a callback after a single test completes. It runs after all `afterEach` hooks.

```ts title="test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { test, onTestFinished } from "bun:test";

test("cleanup after test", () => {
  onTestFinished(() => {
    // runs after all afterEach hooks
    console.log("test finished");
  });
});
```

Not supported in concurrent tests; use `test.serial` instead.

## Global Setup and Teardown

To scope the hooks to an entire multi-file test run, define the hooks in a separate file.

```ts title="setup.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { beforeAll, afterAll } from "bun:test";

beforeAll(() => {
  // global setup
  console.log("Global test setup");
  // Initialize database connections, start servers, etc.
});

afterAll(() => {
  // global teardown
  console.log("Global test teardown");
  // Close database connections, stop servers, etc.
});
```

Then use `--preload` to run the setup script before any test files.

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun test --preload ./setup.ts
```

To avoid typing `--preload` every time you run tests, it can be added to your `bunfig.toml`:

```toml title="bunfig.toml" icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
[test]
preload = ["./setup.ts"]
```

## Practical Examples

### Database Setup

```ts title="database-setup.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { beforeAll, afterAll, beforeEach, afterEach } from "bun:test";
import { createConnection, closeConnection, clearDatabase } from "./db";

let connection;

beforeAll(async () => {
  // Connect to test database
  connection = await createConnection({
    host: "localhost",
    database: "test_db",
  });
});

afterAll(async () => {
  // Close database connection
  await closeConnection(connection);
});

beforeEach(async () => {
  // Start with clean database for each test
  await clearDatabase(connection);
});
```

### API Server Setup

```ts title="server-setup.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { beforeAll, afterAll } from "bun:test";
import { startServer, stopServer } from "./server";

let server;

beforeAll(async () => {
  // Start test server
  server = await startServer({
    port: 3001,
    env: "test",
  });
});

afterAll(async () => {
  // Stop test server
  await stopServer(server);
});
```

### Mock Setup

```ts title="mock-setup.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { beforeEach, afterEach } from "bun:test";
import { mock } from "bun:test";

beforeEach(() => {
  // Set up common mocks
  mock.module("./api-client", () => ({
    fetchUser: mock(() => Promise.resolve({ id: 1, name: "Test User" })),
    createUser: mock(() => Promise.resolve({ id: 2 })),
  }));
});

afterEach(() => {
  // Clear all mocks after each test
  mock.restore();
});
```

## Async Lifecycle Hooks

All lifecycle hooks support async functions:

```ts title="test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { beforeAll, afterAll, test } from "bun:test";

beforeAll(async () => {
  // Async setup
  await new Promise(resolve => setTimeout(resolve, 100));
  console.log("Async setup complete");
});

afterAll(async () => {
  // Async teardown
  await new Promise(resolve => setTimeout(resolve, 100));
  console.log("Async teardown complete");
});

test("async test", async () => {
  // Test will wait for beforeAll to complete
  await expect(Promise.resolve("test")).resolves.toBe("test");
});
```

## Nested Hooks

Hooks can be nested and will run in the appropriate order:

```ts title="test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { describe, beforeAll, beforeEach, afterEach, afterAll, test } from "bun:test";

beforeAll(() => console.log("File beforeAll"));
afterAll(() => console.log("File afterAll"));

describe("outer describe", () => {
  beforeAll(() => console.log("Outer beforeAll"));
  beforeEach(() => console.log("Outer beforeEach"));
  afterEach(() => console.log("Outer afterEach"));
  afterAll(() => console.log("Outer afterAll"));

  describe("inner describe", () => {
    beforeAll(() => console.log("Inner beforeAll"));
    beforeEach(() => console.log("Inner beforeEach"));
    afterEach(() => console.log("Inner afterEach"));
    afterAll(() => console.log("Inner afterAll"));

    test("nested test", () => {
      console.log("Test running");
    });
  });
});
```

```txt theme={"theme":{"light":"github-light","dark":"dracula"}}
// Output order:
// File beforeAll
// Outer beforeAll
// Inner beforeAll
// Outer beforeEach
// Inner beforeEach
// Test running
// Inner afterEach
// Outer afterEach
// Inner afterAll
// Outer afterAll
// File afterAll
```

## Error Handling

If a lifecycle hook throws an error, it will affect test execution:

```ts title="test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { beforeAll, test } from "bun:test";

beforeAll(() => {
  // If this throws, all tests in this scope will be skipped
  throw new Error("Setup failed");
});

test("this test will be skipped", () => {
  // This won't run because beforeAll failed
});
```

For better error handling:

```ts title="test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { beforeAll, test, expect } from "bun:test";

beforeAll(async () => {
  try {
    await setupDatabase();
  } catch (error) {
    console.error("Database setup failed:", error);
    throw error; // Re-throw to fail the test suite
  }
});
```

## Best Practices

### Keep Hooks Simple

```ts title="test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
// Good: Simple, focused setup
beforeEach(() => {
  clearLocalStorage();
  resetMocks();
});

// Avoid: Complex logic in hooks
beforeEach(async () => {
  // Too much complex logic makes tests hard to debug
  const data = await fetchComplexData();
  await processData(data);
  await setupMultipleServices(data);
});
```

### Use Appropriate Scope

```ts title="test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
// Good: File-level setup for shared resources
beforeAll(async () => {
  await startTestServer();
});

// Good: Test-level setup for test-specific state
beforeEach(() => {
  user = createTestUser();
});
```

### Clean Up Resources

```ts title="test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { afterAll, afterEach } from "bun:test";

afterEach(() => {
  // Clean up after each test
  document.body.innerHTML = "";
  localStorage.clear();
});

afterAll(async () => {
  // Clean up expensive resources
  await closeDatabase();
  await stopServer();
});
```


# Mocks
Source: https://bun.com/docs/test/mocks

Learn how to create and use mock functions, spies, and module mocks in Bun tests

Mocking is essential for testing by allowing you to replace dependencies with controlled implementations. Bun provides comprehensive mocking capabilities including function mocks, spies, and module mocks.

## Basic Function Mocks

Create mocks with the `mock` function.

```ts title="test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { test, expect, mock } from "bun:test";

const random = mock(() => Math.random());

test("random", () => {
  const val = random();
  expect(val).toBeGreaterThan(0);
  expect(random).toHaveBeenCalled();
  expect(random).toHaveBeenCalledTimes(1);
});
```

### Jest Compatibility

Alternatively, you can use the `jest.fn()` function, as in Jest. It behaves identically.

```ts title="test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { test, expect, jest } from "bun:test";

const random = jest.fn(() => Math.random());

test("random", () => {
  const val = random();
  expect(val).toBeGreaterThan(0);
  expect(random).toHaveBeenCalled();
  expect(random).toHaveBeenCalledTimes(1);
});
```

## Mock Function Properties

The result of `mock()` is a new function that's been decorated with some additional properties.

```ts title="test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { mock } from "bun:test";

const random = mock((multiplier: number) => multiplier * Math.random());

random(2);
random(10);

random.mock.calls;
// [[ 2 ], [ 10 ]]

random.mock.results;
//  [
//    { type: "return", value: 0.6533907460954099 },
//    { type: "return", value: 0.6452713933037312 }
//  ]
```

### Available Properties and Methods

The following properties and methods are implemented on mock functions:

| Property/Method                           | Description                                    |
| ----------------------------------------- | ---------------------------------------------- |
| `mockFn.getMockName()`                    | Returns the mock name                          |
| `mockFn.mock.calls`                       | Array of call arguments for each invocation    |
| `mockFn.mock.results`                     | Array of return values for each invocation     |
| `mockFn.mock.instances`                   | Array of `this` contexts for each invocation   |
| `mockFn.mock.contexts`                    | Array of `this` contexts for each invocation   |
| `mockFn.mock.lastCall`                    | Arguments of the most recent call              |
| `mockFn.mockClear()`                      | Clears call history                            |
| `mockFn.mockReset()`                      | Clears call history and removes implementation |
| `mockFn.mockRestore()`                    | Restores original implementation               |
| `mockFn.mockImplementation(fn)`           | Sets a new implementation                      |
| `mockFn.mockImplementationOnce(fn)`       | Sets implementation for next call only         |
| `mockFn.mockName(name)`                   | Sets the mock name                             |
| `mockFn.mockReturnThis()`                 | Sets the return value to `this`                |
| `mockFn.mockReturnValue(value)`           | Sets a return value                            |
| `mockFn.mockReturnValueOnce(value)`       | Sets return value for next call only           |
| `mockFn.mockResolvedValue(value)`         | Sets a resolved Promise value                  |
| `mockFn.mockResolvedValueOnce(value)`     | Sets resolved Promise for next call only       |
| `mockFn.mockRejectedValue(value)`         | Sets a rejected Promise value                  |
| `mockFn.mockRejectedValueOnce(value)`     | Sets rejected Promise for next call only       |
| `mockFn.withImplementation(fn, callback)` | Temporarily changes implementation             |

### Practical Examples

#### Basic Mock Usage

```ts title="test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { test, expect, mock } from "bun:test";

test("mock function behavior", () => {
  const mockFn = mock((x: number) => x * 2);

  // Call the mock
  const result1 = mockFn(5);
  const result2 = mockFn(10);

  // Verify calls
  expect(mockFn).toHaveBeenCalledTimes(2);
  expect(mockFn).toHaveBeenCalledWith(5);
  expect(mockFn).toHaveBeenLastCalledWith(10);

  // Check results
  expect(result1).toBe(10);
  expect(result2).toBe(20);

  // Inspect call history
  expect(mockFn.mock.calls).toEqual([[5], [10]]);
  expect(mockFn.mock.results).toEqual([
    { type: "return", value: 10 },
    { type: "return", value: 20 },
  ]);
});
```

#### Dynamic Mock Implementations

```ts title="test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { test, expect, mock } from "bun:test";

test("dynamic mock implementations", () => {
  const mockFn = mock();

  // Set different implementations
  mockFn.mockImplementationOnce(() => "first");
  mockFn.mockImplementationOnce(() => "second");
  mockFn.mockImplementation(() => "default");

  expect(mockFn()).toBe("first");
  expect(mockFn()).toBe("second");
  expect(mockFn()).toBe("default");
  expect(mockFn()).toBe("default"); // Uses default implementation
});
```

#### Async Mocks

```ts title="test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { test, expect, mock } from "bun:test";

test("async mock functions", async () => {
  const asyncMock = mock();

  // Mock resolved values
  asyncMock.mockResolvedValueOnce("first result");
  asyncMock.mockResolvedValue("default result");

  expect(await asyncMock()).toBe("first result");
  expect(await asyncMock()).toBe("default result");

  // Mock rejected values
  const rejectMock = mock();
  rejectMock.mockRejectedValue(new Error("Mock error"));

  await expect(rejectMock()).rejects.toThrow("Mock error");
});
```

## Spies with spyOn()

It's possible to track calls to a function without replacing it with a mock. Use `spyOn()` to create a spy; these spies can be passed to `.toHaveBeenCalled()` and `.toHaveBeenCalledTimes()`.

```ts title="test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { test, expect, spyOn } from "bun:test";

const ringo = {
  name: "Ringo",
  sayHi() {
    console.log(`Hello I'm ${this.name}`);
  },
};

const spy = spyOn(ringo, "sayHi");

test("spyon", () => {
  expect(spy).toHaveBeenCalledTimes(0);
  ringo.sayHi();
  expect(spy).toHaveBeenCalledTimes(1);
});
```

### Advanced Spy Usage

```ts title="test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { test, expect, spyOn, afterEach } from "bun:test";

class UserService {
  async getUser(id: string) {
    // Original implementation
    return { id, name: `User ${id}` };
  }

  async saveUser(user: any) {
    // Original implementation
    return { ...user, saved: true };
  }
}

const userService = new UserService();

afterEach(() => {
  // Restore all spies after each test
  jest.restoreAllMocks();
});

test("spy on service methods", async () => {
  // Spy without changing implementation
  const getUserSpy = spyOn(userService, "getUser");
  const saveUserSpy = spyOn(userService, "saveUser");

  // Use the service normally
  const user = await userService.getUser("123");
  await userService.saveUser(user);

  // Verify calls
  expect(getUserSpy).toHaveBeenCalledWith("123");
  expect(saveUserSpy).toHaveBeenCalledWith(user);
});

test("spy with mock implementation", async () => {
  // Spy and override implementation
  const getUserSpy = spyOn(userService, "getUser").mockResolvedValue({
    id: "123",
    name: "Mocked User",
  });

  const result = await userService.getUser("123");

  expect(result.name).toBe("Mocked User");
  expect(getUserSpy).toHaveBeenCalledWith("123");
});
```

## Module Mocks with mock.module()

Module mocking lets you override the behavior of a module. Use `mock.module(path: string, callback: () => Object)` to mock a module.

```ts title="test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { test, expect, mock } from "bun:test";

mock.module("./module", () => {
  return {
    foo: "bar",
  };
});

test("mock.module", async () => {
  const esm = await import("./module");
  expect(esm.foo).toBe("bar");

  const cjs = require("./module");
  expect(cjs.foo).toBe("bar");
});
```

Like the rest of Bun, module mocks support both `import` and `require`.

### Overriding Already Imported Modules

If you need to override a module that's already been imported, there's nothing special you need to do. Just call `mock.module()` and the module will be overridden.

```ts title="test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { test, expect, mock } from "bun:test";

// The module we're going to mock is here:
import { foo } from "./module";

test("mock.module", async () => {
  const cjs = require("./module");
  expect(foo).toBe("bar");
  expect(cjs.foo).toBe("bar");

  // We update it here:
  mock.module("./module", () => {
    return {
      foo: "baz",
    };
  });

  // And the live bindings are updated.
  expect(foo).toBe("baz");

  // The module is also updated for CJS.
  expect(cjs.foo).toBe("baz");
});
```

### Hoisting & Preloading

If you need to ensure a module is mocked before it's imported, you should use `--preload` to load your mocks before your tests run.

```ts title="my-preload.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { mock } from "bun:test";

mock.module("./module", () => {
  return {
    foo: "bar",
  };
});
```

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun test --preload ./my-preload
```

To make your life easier, you can put preload in your `bunfig.toml`:

```toml title="bunfig.toml" icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
[test]
# Load these modules before running tests.
preload = ["./my-preload"]
```

### Module Mock Best Practices

#### When to Use Preload

**What happens if I mock a module that's already been imported?**

If you mock a module that's already been imported, the module will be updated in the module cache. This means that any modules that import the module will get the mocked version, BUT the original module will still have been evaluated. That means that any side effects from the original module will still have happened.

If you want to prevent the original module from being evaluated, you should use `--preload` to load your mocks before your tests run.

#### Practical Module Mock Examples

```ts title="api-client.test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { test, expect, mock, beforeEach } from "bun:test";

// Mock the API client module
mock.module("./api-client", () => ({
  fetchUser: mock(async (id: string) => ({ id, name: `User ${id}` })),
  createUser: mock(async (user: any) => ({ ...user, id: "new-id" })),
  updateUser: mock(async (id: string, user: any) => ({ ...user, id })),
}));

test("user service with mocked API", async () => {
  const { fetchUser } = await import("./api-client");
  const { UserService } = await import("./user-service");

  const userService = new UserService();
  const user = await userService.getUser("123");

  expect(fetchUser).toHaveBeenCalledWith("123");
  expect(user.name).toBe("User 123");
});
```

#### Mocking External Dependencies

```ts title="database.test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { test, expect, mock } from "bun:test";

// Mock external database library
mock.module("pg", () => ({
  Client: mock(function () {
    return {
      connect: mock(async () => {}),
      query: mock(async (sql: string) => ({
        rows: [{ id: 1, name: "Test User" }],
      })),
      end: mock(async () => {}),
    };
  }),
}));

test("database operations", async () => {
  const { Database } = await import("./database");
  const db = new Database();

  const users = await db.getUsers();
  expect(users).toHaveLength(1);
  expect(users[0].name).toBe("Test User");
});
```

## Global Mock Functions

### Clear All Mocks

Reset all mock function state (calls, results, etc.) without restoring their original implementation:

```ts title="test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { expect, mock, test } from "bun:test";

const random1 = mock(() => Math.random());
const random2 = mock(() => Math.random());

test("clearing all mocks", () => {
  random1();
  random2();

  expect(random1).toHaveBeenCalledTimes(1);
  expect(random2).toHaveBeenCalledTimes(1);

  mock.clearAllMocks();

  expect(random1).toHaveBeenCalledTimes(0);
  expect(random2).toHaveBeenCalledTimes(0);

  // Note: implementations are preserved
  expect(typeof random1()).toBe("number");
  expect(typeof random2()).toBe("number");
});
```

This resets the `.mock.calls`, `.mock.instances`, `.mock.contexts`, and `.mock.results` properties of all mocks, but unlike `mock.restore()`, it does not restore the original implementation.

### Restore All Mocks

Instead of manually restoring each mock individually with `mockFn.mockRestore()`, restore all mocks with one command by calling `mock.restore()`. Doing so does not reset the value of modules overridden with `mock.module()`.

```ts title="test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { expect, mock, spyOn, test } from "bun:test";

import * as fooModule from "./foo.ts";
import * as barModule from "./bar.ts";
import * as bazModule from "./baz.ts";

test("foo, bar, baz", () => {
  const fooSpy = spyOn(fooModule, "foo");
  const barSpy = spyOn(barModule, "bar");
  const bazSpy = spyOn(bazModule, "baz");

  // Original implementations still work
  expect(fooModule.foo()).toBe("foo");
  expect(barModule.bar()).toBe("bar");
  expect(bazModule.baz()).toBe("baz");

  // Mock implementations
  fooSpy.mockImplementation(() => 42);
  barSpy.mockImplementation(() => 43);
  bazSpy.mockImplementation(() => 44);

  expect(fooModule.foo()).toBe(42);
  expect(barModule.bar()).toBe(43);
  expect(bazModule.baz()).toBe(44);

  // Restore all
  mock.restore();

  expect(fooModule.foo()).toBe("foo");
  expect(barModule.bar()).toBe("bar");
  expect(bazModule.baz()).toBe("baz");
});
```

Using `mock.restore()` can reduce the amount of code in your tests by adding it to `afterEach` blocks in each test file or even in your test preload code.

## Vitest Compatibility

For added compatibility with tests written for Vitest, Bun provides the `vi` object as an alias for parts of the Jest mocking API:

```ts title="test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { test, expect, vi } from "bun:test";

// Using the 'vi' alias similar to Vitest
test("vitest compatibility", () => {
  const mockFn = vi.fn(() => 42);

  mockFn();
  expect(mockFn).toHaveBeenCalled();

  // The following functions are available on the vi object:
  // vi.fn
  // vi.spyOn
  // vi.mock
  // vi.restoreAllMocks
  // vi.clearAllMocks
});
```

This makes it easier to port tests from Vitest to Bun without having to rewrite all your mocks.

## Implementation Details

Understanding how `mock.module()` works helps you use it more effectively:

### Cache Interaction

Module mocks interact with both ESM and CommonJS module caches.

### Lazy Evaluation

The mock factory callback is only evaluated when the module is actually imported or required.

### Path Resolution

Bun automatically resolves the module specifier as though you were doing an import, supporting:

* Relative paths (`'./module'`)
* Absolute paths (`'/path/to/module'`)
* Package names (`'lodash'`)

### Import Timing Effects

* **When mocking before first import**: No side effects from the original module occur
* **When mocking after import**: The original module's side effects have already happened

For this reason, using `--preload` is recommended for mocks that need to prevent side effects.

### Live Bindings

Mocked ESM modules maintain live bindings, so changing the mock will update all existing imports.

## Advanced Patterns

### Factory Functions

```ts title="test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { mock } from "bun:test";

function createMockUser(overrides = {}) {
  return {
    id: "mock-id",
    name: "Mock User",
    email: "mock@example.com",
    ...overrides,
  };
}

const mockUserService = {
  getUser: mock(async (id: string) => createMockUser({ id })),
  createUser: mock(async (data: any) => createMockUser(data)),
  updateUser: mock(async (id: string, data: any) => createMockUser({ id, ...data })),
};
```

### Conditional Mocking

```ts title="test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { test, expect, mock } from "bun:test";

const shouldUseMockApi = process.env.NODE_ENV === "test";

if (shouldUseMockApi) {
  mock.module("./api", () => ({
    fetchData: mock(async () => ({ data: "mocked" })),
  }));
}

test("conditional API usage", async () => {
  const { fetchData } = await import("./api");
  const result = await fetchData();

  if (shouldUseMockApi) {
    expect(result.data).toBe("mocked");
  }
});
```

### Mock Cleanup Patterns

```ts title="test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { afterEach, beforeEach } from "bun:test";

beforeEach(() => {
  // Set up common mocks
  mock.module("./logger", () => ({
    log: mock(() => {}),
    error: mock(() => {}),
    warn: mock(() => {}),
  }));
});

afterEach(() => {
  // Clean up all mocks
  mock.restore();
  mock.clearAllMocks();
});
```

## Best Practices

### Keep Mocks Simple

```ts title="test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
// Good: Simple, focused mock
const mockUserApi = {
  getUser: mock(async id => ({ id, name: "Test User" })),
};

// Avoid: Overly complex mock behavior
const complexMock = mock(input => {
  if (input.type === "A") {
    return processTypeA(input);
  } else if (input.type === "B") {
    return processTypeB(input);
  }
  // ... lots of complex logic
});
```

### Use Type-Safe Mocks

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
interface UserService {
  getUser(id: string): Promise<User>;
  createUser(data: CreateUserData): Promise<User>;
}

const mockUserService: UserService = {
  getUser: mock(async (id: string) => ({ id, name: "Test User" })),
  createUser: mock(async data => ({ id: "new-id", ...data })),
};
```

### Test Mock Behavior

```ts title="test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
test("service calls API correctly", async () => {
  const mockApi = { fetchUser: mock(async () => ({ id: "1" })) };

  const service = new UserService(mockApi);
  await service.getUser("123");

  // Verify the mock was called correctly
  expect(mockApi.fetchUser).toHaveBeenCalledWith("123");
  expect(mockApi.fetchUser).toHaveBeenCalledTimes(1);
});
```

## Notes

### Auto-mocking

`__mocks__` directory and auto-mocking are not supported yet. If this is blocking you from switching to Bun, please [file an issue](https://github.com/oven-sh/bun/issues).

### ESM vs CommonJS

Module mocks have different implementations for ESM and CommonJS modules. For ES Modules, Bun has added patches to JavaScriptCore that allow Bun to override export values at runtime and update live bindings recursively.


# Test Reporters
Source: https://bun.com/docs/test/reporters



bun test supports different output formats through reporters. This document covers both built-in reporters and how to implement your own custom reporters.

***

## Built-in Reporters

### Default Console Reporter

By default, bun test outputs results to the console in a human-readable format:

```sh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
test/package-json-lint.test.ts:
✓ test/package.json [0.88ms]
✓ test/js/third_party/grpc-js/package.json [0.18ms]
✓ test/js/third_party/svelte/package.json [0.21ms]
✓ test/js/third_party/express/package.json [1.05ms]

 4 pass
 0 fail
 4 expect() calls
Ran 4 tests in 1.44ms
```

When a terminal doesn't support colors, the output avoids non-ascii characters:

```sh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
test/package-json-lint.test.ts:
(pass) test/package.json [0.48ms]
(pass) test/js/third_party/grpc-js/package.json [0.10ms]
(pass) test/js/third_party/svelte/package.json [0.04ms]
(pass) test/js/third_party/express/package.json [0.04ms]

 4 pass
 0 fail
 4 expect() calls
Ran 4 tests across 1 files. [0.66ms]
```

### Dots Reporter

The dots reporter shows `.` for passing tests and `F` for failures—useful for large test suites.

```sh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun test --dots
bun test --reporter=dots
```

### JUnit XML Reporter

For CI/CD environments, Bun supports generating JUnit XML reports. JUnit XML is a widely-adopted format for test results that can be parsed by many CI/CD systems, including GitLab, Jenkins, and others.

#### Using the JUnit Reporter

To generate a JUnit XML report, use the `--reporter=junit` flag along with `--reporter-outfile` to specify the output file:

```sh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun test --reporter=junit --reporter-outfile=./junit.xml
```

This continues to output to the console as usual while also writing the JUnit XML report to the specified path at the end of the test run.

#### Configuring via bunfig.toml

You can also configure the JUnit reporter in your `bunfig.toml` file:

```toml title="bunfig.toml" icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
[test.reporter]
junit = "path/to/junit.xml"  # Output path for JUnit XML report
```

#### Environment Variables in JUnit Reports

The JUnit reporter automatically includes environment information as `<properties>` in the XML output. This can be helpful for tracking test runs in CI environments.

Specifically, it includes the following environment variables when available:

| Environment Variable                                                    | Property Name | Description            |
| ----------------------------------------------------------------------- | ------------- | ---------------------- |
| `GITHUB_RUN_ID`, `GITHUB_SERVER_URL`, `GITHUB_REPOSITORY`, `CI_JOB_URL` | `ci`          | CI build information   |
| `GITHUB_SHA`, `CI_COMMIT_SHA`, `GIT_SHA`                                | `commit`      | Git commit identifiers |
| System hostname                                                         | `hostname`    | Machine hostname       |

This makes it easier to track which environment and commit a particular test run was for.

#### Current Limitations

The JUnit reporter currently has a few limitations that will be addressed in future updates:

* `stdout` and `stderr` output from individual tests are not included in the report
* Precise timestamp fields per test case are not included

### GitHub Actions reporter

Bun test automatically detects when it's running inside GitHub Actions and emits GitHub Actions annotations to the console directly. No special configuration is needed beyond installing Bun and running `bun test`.

For a GitHub Actions workflow configuration example, see the [CI/CD integration](/pm/cli/install#ci%2Fcd) section of the CLI documentation.

***

## Custom Reporters

Bun allows developers to implement custom test reporters by extending the WebKit Inspector Protocol with additional testing-specific domains.

### Inspector Protocol for Testing

To support test reporting, Bun extends the standard WebKit Inspector Protocol with two custom domains:

1. **TestReporter**: Reports test discovery, execution start, and completion events
2. **LifecycleReporter**: Reports errors and exceptions during test execution

These extensions allow you to build custom reporting tools that can receive detailed information about test execution in real-time.

### Key Events

Custom reporters can listen for these key events:

* `TestReporter.found`: Emitted when a test is discovered
* `TestReporter.start`: Emitted when a test starts running
* `TestReporter.end`: Emitted when a test completes
* `Console.messageAdded`: Emitted when console output occurs during a test
* `LifecycleReporter.error`: Emitted when an error or exception occurs


# Runtime behavior
Source: https://bun.com/docs/test/runtime-behavior

Learn about Bun test's runtime integration, environment variables, timeouts, and error handling

`bun test` is deeply integrated with Bun's runtime. This is part of what makes `bun test` fast and simple to use.

## Environment Variables

### NODE\_ENV

`bun test` automatically sets `$NODE_ENV` to `"test"` unless it's already set in the environment or via `.env` files. This is standard behavior for most test runners and helps ensure consistent test behavior.

```ts title="test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { test, expect } from "bun:test";

test("NODE_ENV is set to test", () => {
  expect(process.env.NODE_ENV).toBe("test");
});
```

You can override this by setting `NODE_ENV` explicitly:

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
NODE_ENV=development bun test
```

### TZ (Timezone)

By default, all `bun test` runs use UTC (`Etc/UTC`) as the time zone unless overridden by the `TZ` environment variable. This ensures consistent date and time behavior across different development environments.

```ts title="test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { test, expect } from "bun:test";

test("timezone is UTC by default", () => {
  const date = new Date();
  expect(date.getTimezoneOffset()).toBe(0);
});
```

To test with a specific timezone:

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
TZ=America/New_York bun test
```

## Test Timeouts

Each test has a default timeout of 5000ms (5 seconds) if not explicitly overridden. Tests that exceed this timeout will fail.

### Global Timeout

Change the timeout globally with the `--timeout` flag:

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun test --timeout 10000  # 10 seconds
```

### Per-Test Timeout

Set timeout per test as the third parameter to the test function:

```ts title="test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { test, expect } from "bun:test";

test("fast test", () => {
  expect(1 + 1).toBe(2);
}, 1000); // 1 second timeout

test("slow test", async () => {
  await new Promise(resolve => setTimeout(resolve, 8000));
}, 10000); // 10 second timeout
```

### Infinite Timeout

Use `0` or `Infinity` to disable timeout:

```ts title="test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
test("test without timeout", async () => {
  // This test can run indefinitely
  await someVeryLongOperation();
}, 0);
```

## Error Handling

### Unhandled Errors

`bun test` tracks unhandled promise rejections and errors that occur between tests. If such errors occur, the final exit code will be non-zero (specifically, the count of such errors), even if all tests pass.

This helps catch errors in asynchronous code that might otherwise go unnoticed:

```ts title="test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { test } from "bun:test";

test("test 1", () => {
  // This test passes
  expect(true).toBe(true);
});

// This error happens outside any test
setTimeout(() => {
  throw new Error("Unhandled error");
}, 0);

test("test 2", () => {
  // This test also passes
  expect(true).toBe(true);
});

// The test run will still fail with a non-zero exit code
// because of the unhandled error
```

### Promise Rejections

Unhandled promise rejections are also caught:

```ts title="test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { test } from "bun:test";

test("passing test", () => {
  expect(1).toBe(1);
});

// This will cause the test run to fail
Promise.reject(new Error("Unhandled rejection"));
```

### Custom Error Handling

You can set up custom error handlers in your test setup:

```ts title="test-setup.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
process.on("uncaughtException", error => {
  console.error("Uncaught Exception:", error);
  process.exit(1);
});

process.on("unhandledRejection", (reason, promise) => {
  console.error("Unhandled Rejection at:", promise, "reason:", reason);
  process.exit(1);
});
```

## CLI Flags Integration

Several Bun CLI flags can be used with `bun test` to modify its behavior:

### Memory Usage

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
# Reduces memory usage for the test runner VM
bun test --smol
```

### Debugging

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
# Attaches the debugger to the test runner process
bun test --inspect
bun test --inspect-brk
```

### Module Loading

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
# Runs scripts before test files (useful for global setup/mocks)
bun test --preload ./setup.ts

# Sets compile-time constants
bun test --define "process.env.API_URL='http://localhost:3000'"

# Configures custom loaders
bun test --loader .special:special-loader

# Uses a different tsconfig
bun test --tsconfig-override ./test-tsconfig.json

# Sets package.json conditions for module resolution
bun test --conditions development

# Loads environment variables for tests
bun test --env-file .env.test
```

### Installation-related Flags

```bash theme={"theme":{"light":"github-light","dark":"dracula"}}
# Affect any network requests or auto-installs during test execution
bun test --prefer-offline
bun test --frozen-lockfile
```

## Watch and Hot Reloading

### Watch Mode

When running `bun test` with the `--watch` flag, the test runner will watch for file changes and re-run affected tests.

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun test --watch
```

The test runner is smart about which tests to re-run:

```ts title="math.test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { add } from "./math.js";
import { test, expect } from "bun:test";

test("addition", () => {
  expect(add(2, 3)).toBe(5);
});
```

If you modify `math.js`, only `math.test.ts` will re-run, not all tests.

### Hot Reloading

The `--hot` flag provides similar functionality but is more aggressive about trying to preserve state between runs:

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun test --hot
```

For most test scenarios, `--watch` is the recommended option as it provides better isolation between test runs.

## Global Variables

The following globals are automatically available in test files without importing (though they can be imported from `bun:test` if preferred):

```ts title="test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
// All of these are available globally
test("global test function", () => {
  expect(true).toBe(true);
});

describe("global describe", () => {
  beforeAll(() => {
    // global beforeAll
  });

  it("global it function", () => {
    // it is an alias for test
  });
});

// Jest compatibility
jest.fn();

// Vitest compatibility
vi.fn();
```

You can also import them explicitly if you prefer:

```ts title="test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { test, it, describe, expect, beforeAll, beforeEach, afterAll, afterEach, jest, vi } from "bun:test";
```

## Process Integration

### Exit Codes

`bun test` uses standard exit codes:

* `0`: All tests passed, no unhandled errors
* `1`: Test failures occurred
* `>1`: Number of unhandled errors (even if tests passed)

### Signal Handling

The test runner properly handles common signals:

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
# Gracefully stops test execution
kill -SIGTERM <test-process-pid>

# Immediately stops test execution
kill -SIGKILL <test-process-pid>
```

### Environment Detection

Bun automatically detects certain environments and adjusts behavior:

```ts title="test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
// GitHub Actions detection
if (process.env.GITHUB_ACTIONS) {
  // Bun automatically emits GitHub Actions annotations
}

// CI detection
if (process.env.CI) {
  // Certain behaviors may be adjusted for CI environments
}
```

## Performance Considerations

### Single Process

The test runner runs all tests in a single process by default. This provides:

* **Faster startup** - No need to spawn multiple processes
* **Shared memory** - Efficient resource usage
* **Simple debugging** - All tests in one process

However, this means:

* Tests share global state (use lifecycle hooks to clean up)
* One test crash can affect others
* No true parallelization of individual tests

### Memory Management

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
# Monitor memory usage
bun test --smol  # Reduces memory footprint

# For large test suites, consider splitting files
bun test src/unit/
bun test src/integration/
```

### Test Isolation

Since tests run in the same process, ensure proper cleanup:

```ts title="test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { afterEach } from "bun:test";

afterEach(() => {
  // Clean up global state
  global.myGlobalVar = undefined;
  delete process.env.TEST_VAR;

  // Reset modules if needed
  jest.resetModules();
});
```


# Snapshots
Source: https://bun.com/docs/test/snapshots

Learn how to use snapshot testing in Bun to save and compare output between test runs

Snapshot testing saves the output of a value and compares it against future test runs. This is particularly useful for UI components, complex objects, or any output that needs to remain consistent.

## Basic Snapshots

Snapshot tests are written using the `.toMatchSnapshot()` matcher:

```ts title="test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { test, expect } from "bun:test";

test("snap", () => {
  expect("foo").toMatchSnapshot();
});
```

The first time this test is run, the argument to `expect` will be serialized and written to a special snapshot file in a `__snapshots__` directory alongside the test file.

### Snapshot Files

After running the test above, Bun will create:

```text title="directory structure" icon="file-directory" theme={"theme":{"light":"github-light","dark":"dracula"}}
your-project/
├── snap.test.ts
└── __snapshots__/
    └── snap.test.ts.snap
```

The snapshot file contains:

```ts title="__snapshots__/snap.test.ts.snap" icon="file-code" theme={"theme":{"light":"github-light","dark":"dracula"}}
// Bun Snapshot v1, https://bun.com/docs/test/snapshots

exports[`snap 1`] = `"foo"`;
```

On future runs, the argument is compared against the snapshot on disk.

## Updating Snapshots

Snapshots can be re-generated with the following command:

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun test --update-snapshots
```

This is useful when:

* You've intentionally changed the output
* You're adding new snapshot tests
* The expected output has legitimately changed

## Inline Snapshots

For smaller values, you can use inline snapshots with `.toMatchInlineSnapshot()`. These snapshots are stored directly in your test file:

```ts title="test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { test, expect } from "bun:test";

test("inline snapshot", () => {
  // First run: snapshot will be inserted automatically
  expect({ hello: "world" }).toMatchInlineSnapshot();
});
```

After the first run, Bun automatically updates your test file:

```ts title="test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { test, expect } from "bun:test";

test("inline snapshot", () => {
  expect({ hello: "world" }).toMatchInlineSnapshot(`
{
  "hello": "world",
}
`);
});
```

### Using Inline Snapshots

1. Write your test with `.toMatchInlineSnapshot()`
2. Run the test once
3. Bun automatically updates your test file with the snapshot
4. On subsequent runs, the value will be compared against the inline snapshot

Inline snapshots are particularly useful for small, simple values where it's helpful to see the expected output right in the test file.

## Error Snapshots

You can also snapshot error messages using `.toThrowErrorMatchingSnapshot()` and `.toThrowErrorMatchingInlineSnapshot()`:

```ts title="test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { test, expect } from "bun:test";

test("error snapshot", () => {
  expect(() => {
    throw new Error("Something went wrong");
  }).toThrowErrorMatchingSnapshot();

  expect(() => {
    throw new Error("Another error");
  }).toThrowErrorMatchingInlineSnapshot();
});
```

After running, the inline version becomes:

```ts title="test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
test("error snapshot", () => {
  expect(() => {
    throw new Error("Something went wrong");
  }).toThrowErrorMatchingSnapshot();

  expect(() => {
    throw new Error("Another error");
  }).toThrowErrorMatchingInlineSnapshot(`"Another error"`);
});
```

## Advanced Snapshot Usage

### Complex Objects

Snapshots work well with complex nested objects:

```ts title="test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { test, expect } from "bun:test";

test("complex object snapshot", () => {
  const user = {
    id: 1,
    name: "John Doe",
    email: "john@example.com",
    profile: {
      age: 30,
      preferences: {
        theme: "dark",
        notifications: true,
      },
    },
    tags: ["developer", "javascript", "bun"],
  };

  expect(user).toMatchSnapshot();
});
```

### Array Snapshots

Arrays are also well-suited for snapshot testing:

```ts title="test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { test, expect } from "bun:test";

test("array snapshot", () => {
  const numbers = [1, 2, 3, 4, 5].map(n => n * 2);
  expect(numbers).toMatchSnapshot();
});
```

### Function Output Snapshots

Snapshot the output of functions:

```ts title="test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { test, expect } from "bun:test";

function generateReport(data: any[]) {
  return {
    total: data.length,
    summary: data.map(item => ({ id: item.id, name: item.name })),
    timestamp: "2024-01-01", // Fixed for testing
  };
}

test("report generation", () => {
  const data = [
    { id: 1, name: "Alice", age: 30 },
    { id: 2, name: "Bob", age: 25 },
  ];

  expect(generateReport(data)).toMatchSnapshot();
});
```

## React Component Snapshots

Snapshots are particularly useful for React components:

```tsx title="test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { test, expect } from "bun:test";
import { render } from "@testing-library/react";

function Button({ children, variant = "primary" }) {
  return <button className={`btn btn-${variant}`}>{children}</button>;
}

test("Button component snapshots", () => {
  const { container: primary } = render(<Button>Click me</Button>);
  const { container: secondary } = render(<Button variant="secondary">Cancel</Button>);

  expect(primary.innerHTML).toMatchSnapshot();
  expect(secondary.innerHTML).toMatchSnapshot();
});
```

## Property Matchers

For values that change between test runs (like timestamps or IDs), use property matchers:

```ts title="test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { test, expect } from "bun:test";

test("snapshot with dynamic values", () => {
  const user = {
    id: Math.random(), // This changes every run
    name: "John",
    createdAt: new Date().toISOString(), // This also changes
  };

  expect(user).toMatchSnapshot({
    id: expect.any(Number),
    createdAt: expect.any(String),
  });
});
```

The snapshot will store:

```txt title="snapshot file" icon="file-code" theme={"theme":{"light":"github-light","dark":"dracula"}}
exports[`snapshot with dynamic values 1`] = `
{
  "createdAt": Any<String>,
  "id": Any<Number>,
  "name": "John",
}
`;
```

## Custom Serializers

You can customize how objects are serialized in snapshots:

```ts title="test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { test, expect } from "bun:test";

// Custom serializer for Date objects
expect.addSnapshotSerializer({
  test: val => val instanceof Date,
  serialize: val => `"${val.toISOString()}"`,
});

test("custom serializer", () => {
  const event = {
    name: "Meeting",
    date: new Date("2024-01-01T10:00:00Z"),
  };

  expect(event).toMatchSnapshot();
});
```

## Best Practices

### Keep Snapshots Small

```ts title="test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
// Good: Focused snapshots
test("user name formatting", () => {
  const formatted = formatUserName("john", "doe");
  expect(formatted).toMatchInlineSnapshot(`"John Doe"`);
});

// Avoid: Huge snapshots that are hard to review
test("entire page render", () => {
  const page = renderEntirePage();
  expect(page).toMatchSnapshot(); // This could be thousands of lines
});
```

### Use Descriptive Test Names

```ts title="test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
// Good: Clear what the snapshot represents
test("formats currency with USD symbol", () => {
  expect(formatCurrency(99.99)).toMatchInlineSnapshot(`"$99.99"`);
});

// Avoid: Unclear what's being tested
test("format test", () => {
  expect(format(99.99)).toMatchInlineSnapshot(`"$99.99"`);
});
```

### Group Related Snapshots

```ts title="test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { describe, test, expect } from "bun:test";

describe("Button component", () => {
  test("primary variant", () => {
    expect(render(<Button variant="primary">Click</Button>))
      .toMatchSnapshot();
  });

  test("secondary variant", () => {
    expect(render(<Button variant="secondary">Cancel</Button>))
      .toMatchSnapshot();
  });

  test("disabled state", () => {
    expect(render(<Button disabled>Disabled</Button>))
      .toMatchSnapshot();
  });
});
```

### Handle Dynamic Data

```ts title="test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
// Good: Normalize dynamic data
test("API response format", () => {
  const response = {
    data: { id: 1, name: "Test" },
    timestamp: Date.now(),
    requestId: generateId(),
  };

  expect({
    ...response,
    timestamp: "TIMESTAMP",
    requestId: "REQUEST_ID",
  }).toMatchSnapshot();
});

// Or use property matchers
test("API response with matchers", () => {
  const response = getApiResponse();

  expect(response).toMatchSnapshot({
    timestamp: expect.any(Number),
    requestId: expect.any(String),
  });
});
```

## Managing Snapshots

### Reviewing Snapshot Changes

When snapshots change, carefully review them:

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
# See what changed
git diff __snapshots__/

# Update if changes are intentional
bun test --update-snapshots

# Commit the updated snapshots
git add __snapshots__/
git commit -m "Update snapshots after UI changes"
```

### Cleaning Up Unused Snapshots

Bun will warn about unused snapshots:

```txt title="warning" icon="warning" theme={"theme":{"light":"github-light","dark":"dracula"}}
Warning: 1 unused snapshot found:
  my-test.test.ts.snap: "old test that no longer exists 1"
```

Remove unused snapshots by deleting them from the snapshot files or by running tests with cleanup flags if available.

### Organizing Large Snapshot Files

For large projects, consider organizing tests to keep snapshot files manageable:

```text title="directory structure" icon="file-directory" theme={"theme":{"light":"github-light","dark":"dracula"}}
tests/
├── components/
│   ├── Button.test.tsx
│   └── __snapshots__/
│       └── Button.test.tsx.snap
├── utils/
│   ├── formatters.test.ts
│   └── __snapshots__/
│       └── formatters.test.ts.snap
```

## Troubleshooting

### Snapshot Failures

When snapshots fail, you'll see a diff:

```diff title="diff" icon="file-code" theme={"theme":{"light":"github-light","dark":"dracula"}}
- Expected
+ Received

  Object {
-   "name": "John",
+   "name": "Jane",
  }
```

Common causes:

* Intentional changes (update with `--update-snapshots`)
* Unintentional changes (fix the code)
* Dynamic data (use property matchers)
* Environment differences (normalize the data)

### Platform Differences

Be aware of platform-specific differences:

```ts title="test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
// Paths might differ between Windows/Unix
test("file operations", () => {
  const result = processFile("./test.txt");

  expect({
    ...result,
    path: result.path.replace(/\\/g, "/"), // Normalize paths
  }).toMatchSnapshot();
});
```


# Writing tests
Source: https://bun.com/docs/test/writing-tests

Learn how to write tests using Bun's Jest-compatible API with support for async tests, timeouts, and various test modifiers

Define tests with a Jest-like API imported from the built-in `bun:test` module. Long term, Bun aims for complete Jest compatibility; at the moment, a limited set of expect matchers are supported.

## Basic Usage

To define a simple test:

```ts title="math.test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { expect, test } from "bun:test";

test("2 + 2", () => {
  expect(2 + 2).toBe(4);
});
```

### Grouping Tests

Tests can be grouped into suites with `describe`.

```ts title="math.test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { expect, test, describe } from "bun:test";

describe("arithmetic", () => {
  test("2 + 2", () => {
    expect(2 + 2).toBe(4);
  });

  test("2 * 2", () => {
    expect(2 * 2).toBe(4);
  });
});
```

### Async Tests

Tests can be async.

```ts title="math.test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { expect, test } from "bun:test";

test("2 * 2", async () => {
  const result = await Promise.resolve(2 * 2);
  expect(result).toEqual(4);
});
```

Alternatively, use the `done` callback to signal completion. If you include the `done` callback as a parameter in your test definition, you must call it or the test will hang.

```ts title="math.test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { expect, test } from "bun:test";

test("2 * 2", done => {
  Promise.resolve(2 * 2).then(result => {
    expect(result).toEqual(4);
    done();
  });
});
```

## Timeouts

Optionally specify a per-test timeout in milliseconds by passing a number as the third argument to `test`.

```ts title="math.test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { test } from "bun:test";

test("wat", async () => {
  const data = await slowOperation();
  expect(data).toBe(42);
}, 500); // test must run in <500ms
```

In `bun:test`, test timeouts throw an uncatchable exception to force the test to stop running and fail. We also kill any child processes that were spawned in the test to avoid leaving behind zombie processes lurking in the background.

The default timeout for each test is 5000ms (5 seconds) if not overridden by this timeout option or `jest.setDefaultTimeout()`.

## Retries and Repeats

### test.retry

Use the `retry` option to automatically retry a test if it fails. The test passes if it succeeds within the specified number of attempts. This is useful for flaky tests that may fail intermittently.

```ts title="example.test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { test } from "bun:test";

test(
  "flaky network request",
  async () => {
    const response = await fetch("https://example.com/api");
    expect(response.ok).toBe(true);
  },
  { retry: 3 }, // Retry up to 3 times if the test fails
);
```

### test.repeats

Use the `repeats` option to run a test multiple times regardless of pass/fail status. The test fails if any iteration fails. This is useful for detecting flaky tests or stress testing. Note that `repeats: N` runs the test N+1 times total (1 initial run + N repeats).

```ts title="example.test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { test } from "bun:test";

test(
  "ensure test is stable",
  () => {
    expect(Math.random()).toBeLessThan(1);
  },
  { repeats: 20 }, // Runs 21 times total (1 initial + 20 repeats)
);
```

<Note>You cannot use both `retry` and `repeats` on the same test.</Note>

### 🧟 Zombie Process Killer

When a test times out and processes spawned in the test via `Bun.spawn`, `Bun.spawnSync`, or `node:child_process` are not killed, they will be automatically killed and a message will be logged to the console. This prevents zombie processes from lingering in the background after timed-out tests.

## Test Modifiers

### test.skip

Skip individual tests with `test.skip`. These tests will not be run.

```ts title="math.test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { expect, test } from "bun:test";

test.skip("wat", () => {
  // TODO: fix this
  expect(0.1 + 0.2).toEqual(0.3);
});
```

### test.todo

Mark a test as a todo with `test.todo`. These tests will not be run.

```ts title="math.test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { expect, test } from "bun:test";

test.todo("fix this", () => {
  myTestFunction();
});
```

To run todo tests and find any which are passing, use `bun test --todo`.

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun test --todo
```

```
my.test.ts:
✗ unimplemented feature
  ^ this test is marked as todo but passes. Remove `.todo` or check that test is correct.

 0 pass
 1 fail
 1 expect() calls
```

With this flag, failing todo tests will not cause an error, but todo tests which pass will be marked as failing so you can remove the todo mark or fix the test.

### test.only

To run a particular test or suite of tests use `test.only()` or `describe.only()`.

```ts title="example.test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { test, describe } from "bun:test";

test("test #1", () => {
  // does not run
});

test.only("test #2", () => {
  // runs
});

describe.only("only", () => {
  test("test #3", () => {
    // runs
  });
});
```

The following command will only execute tests #2 and #3.

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun test --only
```

The following command will only execute tests #1, #2 and #3.

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun test
```

### test.if

To run a test conditionally, use `test.if()`. The test will run if the condition is truthy. This is particularly useful for tests that should only run on specific architectures or operating systems.

```ts title="example.test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
test.if(Math.random() > 0.5)("runs half the time", () => {
  // ...
});

const macOS = process.platform === "darwin";
test.if(macOS)("runs on macOS", () => {
  // runs if macOS
});
```

### test.skipIf

To instead skip a test based on some condition, use `test.skipIf()` or `describe.skipIf()`.

```ts title="example.test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
const macOS = process.platform === "darwin";

test.skipIf(macOS)("runs on non-macOS", () => {
  // runs if *not* macOS
});
```

### test.todoIf

If instead you want to mark the test as TODO, use `test.todoIf()` or `describe.todoIf()`. Carefully choosing `skipIf` or `todoIf` can show a difference between, for example, intent of "invalid for this target" and "planned but not implemented yet."

```ts title="example.test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
const macOS = process.platform === "darwin";

// TODO: we've only implemented this for Linux so far.
test.todoIf(macOS)("runs on posix", () => {
  // runs if *not* macOS
});
```

### test.failing

Use `test.failing()` when you know a test is currently failing but you want to track it and be notified when it starts passing. This inverts the test result:

* A failing test marked with `.failing()` will pass
* A passing test marked with `.failing()` will fail (with a message indicating it's now passing and should be fixed)

```ts math.test.ts icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
// This will pass because the test is failing as expected
test.failing("math is broken", () => {
  expect(0.1 + 0.2).toBe(0.3); // fails due to floating point precision
});

// This will fail with a message that the test is now passing
test.failing("fixed bug", () => {
  expect(1 + 1).toBe(2); // passes, but we expected it to fail
});
```

This is useful for tracking known bugs that you plan to fix later, or for implementing test-driven development.

## Conditional Tests for Describe Blocks

The conditional modifiers `.if()`, `.skipIf()`, and `.todoIf()` can also be applied to describe blocks, affecting all tests within the suite:

```ts title="example.test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
const isMacOS = process.platform === "darwin";

// Only runs the entire suite on macOS
describe.if(isMacOS)("macOS-specific features", () => {
  test("feature A", () => {
    // only runs on macOS
  });

  test("feature B", () => {
    // only runs on macOS
  });
});

// Skips the entire suite on Windows
describe.skipIf(process.platform === "win32")("Unix features", () => {
  test("feature C", () => {
    // skipped on Windows
  });
});

// Marks the entire suite as TODO on Linux
describe.todoIf(process.platform === "linux")("Upcoming Linux support", () => {
  test("feature D", () => {
    // marked as TODO on Linux
  });
});
```

## Parametrized Tests

### `test.each` and `describe.each`

To run the same test with multiple sets of data, use `test.each`. This creates a parametrized test that runs once for each test case provided.

```ts title="math.test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
const cases = [
  [1, 2, 3],
  [3, 4, 7],
];

test.each(cases)("%p + %p should be %p", (a, b, expected) => {
  expect(a + b).toBe(expected);
});
```

You can also use `describe.each` to create a parametrized suite that runs once for each test case:

```ts title="sum.test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
describe.each([
  [1, 2, 3],
  [3, 4, 7],
])("add(%i, %i)", (a, b, expected) => {
  test(`returns ${expected}`, () => {
    expect(a + b).toBe(expected);
  });

  test(`sum is greater than each value`, () => {
    expect(a + b).toBeGreaterThan(a);
    expect(a + b).toBeGreaterThan(b);
  });
});
```

### Argument Passing

How arguments are passed to your test function depends on the structure of your test cases:

* If a table row is an array (like `[1, 2, 3]`), each element is passed as an individual argument
* If a row is not an array (like an object), it's passed as a single argument

```ts title="example.test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
// Array items passed as individual arguments
test.each([
  [1, 2, 3],
  [4, 5, 9],
])("add(%i, %i) = %i", (a, b, expected) => {
  expect(a + b).toBe(expected);
});

// Object items passed as a single argument
test.each([
  { a: 1, b: 2, expected: 3 },
  { a: 4, b: 5, expected: 9 },
])("add($a, $b) = $expected", data => {
  expect(data.a + data.b).toBe(data.expected);
});
```

### Format Specifiers

There are a number of options available for formatting the test title:

| Specifier | Description             |
| --------- | ----------------------- |
| `%p`      | pretty-format           |
| `%s`      | String                  |
| `%d`      | Number                  |
| `%i`      | Integer                 |
| `%f`      | Floating point          |
| `%j`      | JSON                    |
| `%o`      | Object                  |
| `%#`      | Index of the test case  |
| `%%`      | Single percent sign (%) |

#### Examples

```ts title="example.test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
// Basic specifiers
test.each([
  ["hello", 123],
  ["world", 456],
])("string: %s, number: %i", (str, num) => {
  // "string: hello, number: 123"
  // "string: world, number: 456"
});

// %p for pretty-format output
test.each([
  [{ name: "Alice" }, { a: 1, b: 2 }],
  [{ name: "Bob" }, { x: 5, y: 10 }],
])("user %p with data %p", (user, data) => {
  // "user { name: 'Alice' } with data { a: 1, b: 2 }"
  // "user { name: 'Bob' } with data { x: 5, y: 10 }"
});

// %# for index
test.each(["apple", "banana"])("fruit #%# is %s", fruit => {
  // "fruit #0 is apple"
  // "fruit #1 is banana"
});
```

## Assertion Counting

Bun supports verifying that a specific number of assertions were called during a test:

### expect.hasAssertions()

Use `expect.hasAssertions()` to verify that at least one assertion is called during a test:

```ts title="example.test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
test("async work calls assertions", async () => {
  expect.hasAssertions(); // Will fail if no assertions are called

  const data = await fetchData();
  expect(data).toBeDefined();
});
```

This is especially useful for async tests to ensure your assertions actually run.

### expect.assertions(count)

Use `expect.assertions(count)` to verify that a specific number of assertions are called during a test:

```ts title="example.test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
test("exactly two assertions", () => {
  expect.assertions(2); // Will fail if not exactly 2 assertions are called

  expect(1 + 1).toBe(2);
  expect("hello").toContain("ell");
});
```

This helps ensure all your assertions run, especially in complex async code with multiple code paths.

## Type Testing

Bun includes `expectTypeOf` for testing TypeScript types, compatible with Vitest.

### expectTypeOf

<Warning>
  These functions are no-ops at runtime - you need to run TypeScript separately to verify the type checks.
</Warning>

The `expectTypeOf` function provides type-level assertions that are checked by TypeScript's type checker. To test your types:

1. Write your type assertions using `expectTypeOf`
2. Run `bunx tsc --noEmit` to check that your types are correct

```ts title="example.test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { expectTypeOf } from "bun:test";

// Basic type assertions
expectTypeOf<string>().toEqualTypeOf<string>();
expectTypeOf(123).toBeNumber();
expectTypeOf("hello").toBeString();

// Object type matching
expectTypeOf({ a: 1, b: "hello" }).toMatchObjectType<{ a: number }>();

// Function types
function greet(name: string): string {
  return `Hello ${name}`;
}

expectTypeOf(greet).toBeFunction();
expectTypeOf(greet).parameters.toEqualTypeOf<[string]>();
expectTypeOf(greet).returns.toEqualTypeOf<string>();

// Array types
expectTypeOf([1, 2, 3]).items.toBeNumber();

// Promise types
expectTypeOf(Promise.resolve(42)).resolves.toBeNumber();
```

For full documentation on expectTypeOf matchers, see the [API Reference](https://bun.com/reference/bun/test/expectTypeOf).

## Matchers

Bun implements the following matchers. Full Jest compatibility is on the roadmap; [track progress here](https://github.com/oven-sh/bun/issues/1825).

### Basic Matchers

| Status | Matcher            |
| ------ | ------------------ |
| ✅      | `.not`             |
| ✅      | `.toBe()`          |
| ✅      | `.toEqual()`       |
| ✅      | `.toBeNull()`      |
| ✅      | `.toBeUndefined()` |
| ✅      | `.toBeNaN()`       |
| ✅      | `.toBeDefined()`   |
| ✅      | `.toBeFalsy()`     |
| ✅      | `.toBeTruthy()`    |
| ✅      | `.toStrictEqual()` |

### String and Array Matchers

| Status | Matcher               |
| ------ | --------------------- |
| ✅      | `.toContain()`        |
| ✅      | `.toHaveLength()`     |
| ✅      | `.toMatch()`          |
| ✅      | `.toContainEqual()`   |
| ✅      | `.stringContaining()` |
| ✅      | `.stringMatching()`   |
| ✅      | `.arrayContaining()`  |

### Object Matchers

| Status | Matcher                 |
| ------ | ----------------------- |
| ✅      | `.toHaveProperty()`     |
| ✅      | `.toMatchObject()`      |
| ✅      | `.toContainAllKeys()`   |
| ✅      | `.toContainValue()`     |
| ✅      | `.toContainValues()`    |
| ✅      | `.toContainAllValues()` |
| ✅      | `.toContainAnyValues()` |
| ✅      | `.objectContaining()`   |

### Number Matchers

| Status | Matcher                     |
| ------ | --------------------------- |
| ✅      | `.toBeCloseTo()`            |
| ✅      | `.closeTo()`                |
| ✅      | `.toBeGreaterThan()`        |
| ✅      | `.toBeGreaterThanOrEqual()` |
| ✅      | `.toBeLessThan()`           |
| ✅      | `.toBeLessThanOrEqual()`    |

### Function and Class Matchers

| Status | Matcher             |
| ------ | ------------------- |
| ✅      | `.toThrow()`        |
| ✅      | `.toBeInstanceOf()` |

### Promise Matchers

| Status | Matcher       |
| ------ | ------------- |
| ✅      | `.resolves()` |
| ✅      | `.rejects()`  |

### Mock Function Matchers

| Status | Matcher                       |
| ------ | ----------------------------- |
| ✅      | `.toHaveBeenCalled()`         |
| ✅      | `.toHaveBeenCalledTimes()`    |
| ✅      | `.toHaveBeenCalledWith()`     |
| ✅      | `.toHaveBeenLastCalledWith()` |
| ✅      | `.toHaveBeenNthCalledWith()`  |
| ✅      | `.toHaveReturned()`           |
| ✅      | `.toHaveReturnedTimes()`      |
| ✅      | `.toHaveReturnedWith()`       |
| ✅      | `.toHaveLastReturnedWith()`   |
| ✅      | `.toHaveNthReturnedWith()`    |

### Snapshot Matchers

| Status | Matcher                                 |
| ------ | --------------------------------------- |
| ✅      | `.toMatchSnapshot()`                    |
| ✅      | `.toMatchInlineSnapshot()`              |
| ✅      | `.toThrowErrorMatchingSnapshot()`       |
| ✅      | `.toThrowErrorMatchingInlineSnapshot()` |

### Utility Matchers

| Status | Matcher            |
| ------ | ------------------ |
| ✅      | `.extend`          |
| ✅      | `.anything()`      |
| ✅      | `.any()`           |
| ✅      | `.assertions()`    |
| ✅      | `.hasAssertions()` |

### Not Yet Implemented

| Status | Matcher                    |
| ------ | -------------------------- |
| ❌      | `.addSnapshotSerializer()` |

## Best Practices

### Use Descriptive Test Names

```ts title="example.test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
// Good
test("should calculate total price including tax for multiple items", () => {
  // test implementation
});

// Avoid
test("price calculation", () => {
  // test implementation
});
```

### Group Related Tests

```ts title="auth.test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
describe("User authentication", () => {
  describe("with valid credentials", () => {
    test("should return user data", () => {
      // test implementation
    });

    test("should set authentication token", () => {
      // test implementation
    });
  });

  describe("with invalid credentials", () => {
    test("should throw authentication error", () => {
      // test implementation
    });
  });
});
```

### Use Appropriate Matchers

```ts title="auth.test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
// Good: Use specific matchers
expect(users).toHaveLength(3);
expect(user.email).toContain("@");
expect(response.status).toBeGreaterThanOrEqual(200);

// Avoid: Using toBe for everything
expect(users.length === 3).toBe(true);
expect(user.email.includes("@")).toBe(true);
expect(response.status >= 200).toBe(true);
```

### Test Error Conditions

```ts title="example.test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
test("should throw error for invalid input", () => {
  expect(() => {
    validateEmail("not-an-email");
  }).toThrow("Invalid email format");
});

test("should handle async errors", async () => {
  await expect(async () => {
    await fetchUser("invalid-id");
  }).rejects.toThrow("User not found");
});
```

### Use Setup and Teardown

```ts title="example.test.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { beforeEach, afterEach, test } from "bun:test";

let testUser;

beforeEach(() => {
  testUser = createTestUser();
});

afterEach(() => {
  cleanupTestUser(testUser);
});

test("should update user profile", () => {
  // Use testUser in test
});
```


# TypeScript
Source: https://bun.com/docs/typescript

Using TypeScript with Bun, including type definitions and compiler options

To install the TypeScript definitions for Bun's built-in APIs, install `@types/bun`.

```zsh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun add -d @types/bun # dev dependency
```

At this point, you should be able to reference the `Bun` global in your TypeScript files without seeing errors in your editor.

## Suggested `compilerOptions`

Bun supports things like top-level await, JSX, and extensioned `.ts` imports, which TypeScript doesn't allow by default. Below is a set of recommended `compilerOptions` for a Bun project, so you can use these features without seeing compiler warnings from TypeScript.

```json tsconfig.json icon="file-json" theme={"theme":{"light":"github-light","dark":"dracula"}}
{
  "compilerOptions": {
    // Environment setup & latest features
    "lib": ["ESNext"],
    "target": "ESNext",
    "module": "Preserve",
    "moduleDetection": "force",
    "jsx": "react-jsx",
    "allowJs": true,

    // Bundler mode
    "moduleResolution": "bundler",
    "allowImportingTsExtensions": true,
    "verbatimModuleSyntax": true,
    "noEmit": true,

    // Best practices
    "strict": true,
    "skipLibCheck": true,
    "noFallthroughCasesInSwitch": true,
    "noUncheckedIndexedAccess": true,
    "noImplicitOverride": true,

    // Some stricter flags (disabled by default)
    "noUnusedLocals": false,
    "noUnusedParameters": false,
    "noPropertyAccessFromIndexSignature": false
  }
}
```

If you run `bun init` in a new directory, this `tsconfig.json` will be generated for you. (The stricter flags are disabled by default.)

```sh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun init
```


