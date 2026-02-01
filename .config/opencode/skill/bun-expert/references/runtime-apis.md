# Bun APIs
Source: https://bun.com/docs/runtime/bun-apis

Overview of Bun's native APIs available on the Bun global object and built-in modules

Bun implements a set of native APIs on the `Bun` global object and through a number of built-in modules. These APIs are heavily optimized and represent the canonical "Bun-native" way to implement some common functionality.

Bun strives to implement standard Web APIs wherever possible. Bun introduces new APIs primarily for server-side tasks where no standard exists, such as file I/O and starting an HTTP server. In these cases, Bun's approach still builds atop standard APIs like `Blob`, `URL`, and `Request`.

```ts server.ts icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
Bun.serve({
  fetch(req: Request) {
    return new Response("Success!");
  },
});
```

Click the link in the right column to jump to the associated documentation.

| Topic                            | APIs                                                                                                                                                                                                                                                                                                                   |
| -------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| HTTP Server                      | [`Bun.serve`](/runtime/http/server)                                                                                                                                                                                                                                                                                    |
| Shell                            | [`$`](/runtime/shell)                                                                                                                                                                                                                                                                                                  |
| Bundler                          | [`Bun.build`](/bundler)                                                                                                                                                                                                                                                                                                |
| File I/O                         | [`Bun.file`](/runtime/file-io#reading-files-bun-file), [`Bun.write`](/runtime/file-io#writing-files-bun-write), `Bun.stdin`, `Bun.stdout`, `Bun.stderr`                                                                                                                                                                |
| Child Processes                  | [`Bun.spawn`](/runtime/child-process#spawn-a-process-bun-spawn), [`Bun.spawnSync`](/runtime/child-process#blocking-api-bun-spawnsync)                                                                                                                                                                                  |
| TCP Sockets                      | [`Bun.listen`](/runtime/networking/tcp#start-a-server-bun-listen), [`Bun.connect`](/runtime/networking/tcp#start-a-server-bun-listen)                                                                                                                                                                                  |
| UDP Sockets                      | [`Bun.udpSocket`](/runtime/networking/udp)                                                                                                                                                                                                                                                                             |
| WebSockets                       | `new WebSocket()` (client), [`Bun.serve`](/runtime/http/websockets) (server)                                                                                                                                                                                                                                           |
| Transpiler                       | [`Bun.Transpiler`](/runtime/transpiler)                                                                                                                                                                                                                                                                                |
| Routing                          | [`Bun.FileSystemRouter`](/runtime/file-system-router)                                                                                                                                                                                                                                                                  |
| Streaming HTML                   | [`HTMLRewriter`](/runtime/html-rewriter)                                                                                                                                                                                                                                                                               |
| Hashing                          | [`Bun.password`](/runtime/hashing#bun-password), [`Bun.hash`](/runtime/hashing#bun-hash), [`Bun.CryptoHasher`](/runtime/hashing#bun-cryptohasher), `Bun.sha`                                                                                                                                                           |
| SQLite                           | [`bun:sqlite`](/runtime/sqlite)                                                                                                                                                                                                                                                                                        |
| PostgreSQL Client                | [`Bun.SQL`](/runtime/sql), `Bun.sql`                                                                                                                                                                                                                                                                                   |
| Redis (Valkey) Client            | [`Bun.RedisClient`](/runtime/redis), `Bun.redis`                                                                                                                                                                                                                                                                       |
| FFI (Foreign Function Interface) | [`bun:ffi`](/runtime/ffi)                                                                                                                                                                                                                                                                                              |
| DNS                              | [`Bun.dns.lookup`](/runtime/networking/dns), `Bun.dns.prefetch`, `Bun.dns.getCacheStats`                                                                                                                                                                                                                               |
| Testing                          | [`bun:test`](/test)                                                                                                                                                                                                                                                                                                    |
| Workers                          | [`new Worker()`](/runtime/workers)                                                                                                                                                                                                                                                                                     |
| Module Loaders                   | [`Bun.plugin`](/bundler/plugins)                                                                                                                                                                                                                                                                                       |
| Glob                             | [`Bun.Glob`](/runtime/glob)                                                                                                                                                                                                                                                                                            |
| Cookies                          | [`Bun.Cookie`](/runtime/cookies), [`Bun.CookieMap`](/runtime/cookies)                                                                                                                                                                                                                                                  |
| Node-API                         | [`Node-API`](/runtime/node-api)                                                                                                                                                                                                                                                                                        |
| `import.meta`                    | [`import.meta`](/runtime/module-resolution#import-meta)                                                                                                                                                                                                                                                                |
| Utilities                        | [`Bun.version`](/runtime/utils#bun-version), [`Bun.revision`](/runtime/utils#bun-revision), [`Bun.env`](/runtime/utils#bun-env), [`Bun.main`](/runtime/utils#bun-main)                                                                                                                                                 |
| Sleep & Timing                   | [`Bun.sleep()`](/runtime/utils#bun-sleep), [`Bun.sleepSync()`](/runtime/utils#bun-sleepsync), [`Bun.nanoseconds()`](/runtime/utils#bun-nanoseconds)                                                                                                                                                                    |
| Random & UUID                    | [`Bun.randomUUIDv7()`](/runtime/utils#bun-randomuuidv7)                                                                                                                                                                                                                                                                |
| System & Environment             | [`Bun.which()`](/runtime/utils#bun-which)                                                                                                                                                                                                                                                                              |
| Comparison & Inspection          | [`Bun.peek()`](/runtime/utils#bun-peek), [`Bun.deepEquals()`](/runtime/utils#bun-deepequals), `Bun.deepMatch`, [`Bun.inspect()`](/runtime/utils#bun-inspect)                                                                                                                                                           |
| String & Text Processing         | [`Bun.escapeHTML()`](/runtime/utils#bun-escapehtml), [`Bun.stringWidth()`](/runtime/utils#bun-stringwidth), `Bun.indexOfLine`                                                                                                                                                                                          |
| URL & Path Utilities             | [`Bun.fileURLToPath()`](/runtime/utils#bun-fileurltopath), [`Bun.pathToFileURL()`](/runtime/utils#bun-pathtofileurl)                                                                                                                                                                                                   |
| Compression                      | [`Bun.gzipSync()`](/runtime/utils#bun-gzipsync), [`Bun.gunzipSync()`](/runtime/utils#bun-gunzipsync), [`Bun.deflateSync()`](/runtime/utils#bun-deflatesync), [`Bun.inflateSync()`](/runtime/utils#bun-inflatesync), `Bun.zstdCompressSync()`, `Bun.zstdDecompressSync()`, `Bun.zstdCompress()`, `Bun.zstdDecompress()` |
| Stream Processing                | [`Bun.readableStreamTo*()`](/runtime/utils#bun-readablestreamto), `Bun.readableStreamToBytes()`, `Bun.readableStreamToBlob()`, `Bun.readableStreamToFormData()`, `Bun.readableStreamToJSON()`, `Bun.readableStreamToArray()`                                                                                           |
| Memory & Buffer Management       | `Bun.ArrayBufferSink`, `Bun.allocUnsafe`, `Bun.concatArrayBuffers`                                                                                                                                                                                                                                                     |
| Module Resolution                | [`Bun.resolveSync()`](/runtime/utils#bun-resolvesync)                                                                                                                                                                                                                                                                  |
| Parsing & Formatting             | [`Bun.semver`](/runtime/semver), `Bun.TOML.parse`, [`Bun.markdown`](/runtime/markdown), [`Bun.color`](/runtime/color)                                                                                                                                                                                                  |
| Low-level / Internals            | `Bun.mmap`, `Bun.gc`, `Bun.generateHeapSnapshot`, [`bun:jsc`](https://bun.com/reference/bun/jsc)                                                                                                                                                                                                                       |


# bunfig.toml
Source: https://bun.com/docs/runtime/bunfig

Configure Bun's behavior using its configuration file bunfig.toml

Bun's behavior can be configured using its configuration file, `bunfig.toml`.

In general, Bun relies on pre-existing configuration files like `package.json` and `tsconfig.json` to configure its behavior. `bunfig.toml` is only necessary for configuring Bun-specific things. This file is optional, and Bun will work out of the box without it.

## Global vs. local

In general, it's recommended to add a `bunfig.toml` file to your project root, alongside your `package.json`.

To configure Bun globally, you can also create a `.bunfig.toml` file at one of the following paths:

* `$HOME/.bunfig.toml`
* `$XDG_CONFIG_HOME/.bunfig.toml`

If both a global and local `bunfig` are detected, the results are shallow-merged, with local overriding global. CLI flags will override `bunfig` setting where applicable.

## Runtime

Bun's runtime behavior is configured using top-level fields in the `bunfig.toml` file.

### `preload`

An array of scripts/plugins to execute before running a file or script.

```toml title="bunfig.toml" icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
# scripts to run before `bun run`-ing a file or script
# register plugins by adding them to this list
preload = ["./preload.ts"]
```

### `jsx`

Configure how Bun handles JSX. You can also set these fields in the `compilerOptions` of your `tsconfig.json`, but they are supported here as well for non-TypeScript projects.

```toml title="bunfig.toml" icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
jsx = "react"
jsxFactory = "h"
jsxFragment = "Fragment"
jsxImportSource = "react"
```

Refer to the tsconfig docs for more information on these fields.

* [`jsx`](https://www.typescriptlang.org/tsconfig#jsx)
* [`jsxFactory`](https://www.typescriptlang.org/tsconfig#jsxFactory)
* [`jsxFragment`](https://www.typescriptlang.org/tsconfig#jsxFragment)
* [`jsxImportSource`](https://www.typescriptlang.org/tsconfig#jsxImportSource)

### `smol`

Enable `smol` mode. This reduces memory usage at the cost of performance.

```toml title="bunfig.toml" icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
# Reduce memory usage at the cost of performance
smol = true
```

### `logLevel`

Set the log level. This can be one of `"debug"`, `"warn"`, or `"error"`.

```toml title="bunfig.toml" icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
logLevel = "debug" # "debug" | "warn" | "error"
```

### `define`

The `define` field allows you to replace certain global identifiers with constant expressions. Bun will replace any usage of the identifier with the expression. The expression should be a JSON string.

```toml title="bunfig.toml" icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
[define]
# Replace any usage of "process.env.bagel" with the string `lox`.
# The values are parsed as JSON, except single-quoted strings are supported and `'undefined'` becomes `undefined` in JS.
# This will probably change in a future release to be just regular TOML instead. It is a holdover from the CLI argument parsing.
"process.env.bagel" = "'lox'"
```

### `loader`

Configure how Bun maps file extensions to loaders. This is useful for loading files that aren't natively supported by Bun.

```toml title="bunfig.toml" icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
[loader]
# when a .bagel file is imported, treat it like a tsx file
".bagel" = "tsx"
```

Bun supports the following loaders:

* `jsx`
* `js`
* `ts`
* `tsx`
* `css`
* `file`
* `json`
* `toml`
* `wasm`
* `napi`
* `base64`
* `dataurl`
* `text`

### `telemetry`

The `telemetry` field is used to enable/disable analytics. By default, telemetry is enabled. This is equivalent to the `DO_NOT_TRACK` environment variable.

Currently we do not collect telemetry and this setting is only used for enabling/disabling anonymous crash reports, but in the future we plan to collect information like which Bun APIs are used most or how long `bun build` takes.

```toml title="bunfig.toml" icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
telemetry = false
```

### `env`

Configure automatic `.env` file loading. By default, Bun automatically loads `.env` files. To disable this behavior:

```toml title="bunfig.toml" icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
# Disable automatic .env file loading
env = false
```

You can also use object syntax with the `file` property:

```toml title="bunfig.toml" icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
[env]
file = false
```

This is useful in production environments or CI/CD pipelines where you want to rely solely on system environment variables.

Note: Explicitly provided environment files via `--env-file` will still be loaded even when default loading is disabled.

### `console`

Configure console output behavior.

#### `console.depth`

Set the default depth for `console.log()` object inspection. Default `2`.

```toml title="bunfig.toml" icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
[console]
depth = 3
```

This controls how deeply nested objects are displayed in console output. Higher values show more nested properties but may produce verbose output for complex objects. This setting can be overridden by the `--console-depth` CLI flag.

## Test runner

The test runner is configured under the `[test]` section of your bunfig.toml.

```toml title="bunfig.toml" icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
[test]
# configuration goes here
```

### `test.root`

The root directory to run tests from. Default `.`.

```toml title="bunfig.toml" icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
[test]
root = "./__tests__"
```

### `test.preload`

Same as the top-level `preload` field, but only applies to `bun test`.

```toml title="bunfig.toml" icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
[test]
preload = ["./setup.ts"]
```

### `test.smol`

Same as the top-level `smol` field, but only applies to `bun test`.

```toml title="bunfig.toml" icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
[test]
smol = true
```

### `test.coverage`

Enables coverage reporting. Default `false`. Use `--coverage` to override.

```toml title="bunfig.toml" icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
[test]
coverage = false
```

### `test.coverageThreshold`

To specify a coverage threshold. By default, no threshold is set. If your test suite does not meet or exceed this threshold, `bun test` will exit with a non-zero exit code to indicate the failure.

```toml title="bunfig.toml" icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
[test]

# to require 90% line-level and function-level coverage
coverageThreshold = 0.9
```

Different thresholds can be specified for line-wise, function-wise, and statement-wise coverage.

```toml title="bunfig.toml" icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
[test]
coverageThreshold = { line = 0.7, function = 0.8, statement = 0.9 }
```

### `test.coverageSkipTestFiles`

Whether to skip test files when computing coverage statistics. Default `false`.

```toml title="bunfig.toml" icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
[test]
coverageSkipTestFiles = false
```

### `test.coveragePathIgnorePatterns`

Exclude specific files or file patterns from coverage reports using glob patterns. Can be a single string pattern or an array of patterns.

```toml title="bunfig.toml" icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
[test]
# Single pattern
coveragePathIgnorePatterns = "**/*.spec.ts"

# Multiple patterns
coveragePathIgnorePatterns = [
  "**/*.spec.ts",
  "**/*.test.ts",
  "src/utils/**",
  "*.config.js"
]
```

### `test.coverageReporter`

By default, coverage reports will be printed to the console. For persistent code coverage reports in CI environments and for other tools use `lcov`.

```toml title="bunfig.toml" icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
[test]
coverageReporter  = ["text", "lcov"]  # default ["text"]
```

### `test.coverageDir`

Set path where coverage reports will be saved. Please notice, that it works only for persistent `coverageReporter` like `lcov`.

```toml title="bunfig.toml" icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
[test]
coverageDir = "path/to/somewhere"  # default "coverage"
```

### `test.randomize`

Run tests in random order. Default `false`.

```toml title="bunfig.toml" icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
[test]
randomize = true
```

This helps catch bugs related to test interdependencies by running tests in a different order each time. When combined with `seed`, the random order becomes reproducible.

The `--randomize` CLI flag will override this setting when specified.

### `test.seed`

Set the random seed for test randomization. This option requires `randomize` to be `true`.

```toml title="bunfig.toml" icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
[test]
randomize = true
seed = 2444615283
```

Using a seed makes the randomized test order reproducible across runs, which is useful for debugging flaky tests. When you encounter a test failure with randomization enabled, you can use the same seed to reproduce the exact test order.

The `--seed` CLI flag will override this setting when specified.

### `test.rerunEach`

Re-run each test file a specified number of times. Default `0` (run once).

```toml title="bunfig.toml" icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
[test]
rerunEach = 3
```

This is useful for catching flaky tests or non-deterministic behavior. Each test file will be executed the specified number of times.

The `--rerun-each` CLI flag will override this setting when specified.

### `test.concurrentTestGlob`

Specify a glob pattern to automatically run matching test files with concurrent test execution enabled. Test files matching this pattern will behave as if the `--concurrent` flag was passed, running all tests within those files concurrently.

```toml title="bunfig.toml" icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
[test]
concurrentTestGlob = "**/concurrent-*.test.ts"
```

This is useful for:

* Gradually migrating test suites to concurrent execution
* Running integration tests concurrently while keeping unit tests sequential
* Separating fast concurrent tests from tests that require sequential execution

The `--concurrent` CLI flag will override this setting when specified.

### `test.onlyFailures`

When enabled, only failed tests are displayed in the output. This helps reduce noise in large test suites by hiding passing tests. Default `false`.

```toml title="bunfig.toml" icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
[test]
onlyFailures = true
```

This is equivalent to using the `--only-failures` flag when running `bun test`.

### `test.reporter`

Configure the test reporter settings.

#### `test.reporter.dots`

Enable the dots reporter, which displays a compact output showing a dot for each test. Default `false`.

```toml title="bunfig.toml" icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
[test.reporter]
dots = true
```

#### `test.reporter.junit`

Enable JUnit XML reporting and specify the output file path.

```toml title="bunfig.toml" icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
[test.reporter]
junit = "test-results.xml"
```

This generates a JUnit XML report that can be consumed by CI systems and other tools.

## Package manager

Package management is a complex issue; to support a range of use cases, the behavior of `bun install` can be configured under the `[install]` section.

```toml title="bunfig.toml" icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
[install]
# configuration here
```

### `install.optional`

Whether to install optional dependencies. Default `true`.

```toml title="bunfig.toml" icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
[install]
optional = true
```

### `install.dev`

Whether to install development dependencies. Default `true`.

```toml title="bunfig.toml" icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
[install]
dev = true
```

### `install.peer`

Whether to install peer dependencies. Default `true`.

```toml title="bunfig.toml" icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
[install]
peer = true
```

### `install.production`

Whether `bun install` will run in "production mode". Default `false`.

In production mode, `"devDependencies"` are not installed. You can use `--production` in the CLI to override this setting.

```toml title="bunfig.toml" icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
[install]
production = false
```

### `install.exact`

Whether to set an exact version in `package.json`. Default `false`.

By default Bun uses caret ranges; if the `latest` version of a package is `2.4.1`, the version range in your `package.json` will be `^2.4.1`. This indicates that any version from `2.4.1` up to (but not including) `3.0.0` is acceptable.

```toml title="bunfig.toml" icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
[install]
exact = false
```

### `install.saveTextLockfile`

If false, generate a binary `bun.lockb` instead of a text-based `bun.lock` file when running `bun install` and no lockfile is present.

Default `true` (since Bun v1.2).

```toml title="bunfig.toml" icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
[install]
saveTextLockfile = false
```

### `install.auto`

To configure Bun's package auto-install behavior. Default `"auto"` — when no `node_modules` folder is found, Bun will automatically install dependencies on the fly during execution.

```toml title="bunfig.toml" icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
[install]
auto = "auto"
```

Valid values are:

| Value        | Description                                                                                                                         |
| ------------ | ----------------------------------------------------------------------------------------------------------------------------------- |
| `"auto"`     | Resolve modules from local `node_modules` if it exists. Otherwise, auto-install dependencies on the fly.                            |
| `"force"`    | Always auto-install dependencies, even if `node_modules` exists.                                                                    |
| `"disable"`  | Never auto-install dependencies.                                                                                                    |
| `"fallback"` | Check local `node_modules` first, then auto-install any packages that aren't found. You can enable this from the CLI with `bun -i`. |

### `install.frozenLockfile`

When true, `bun install` will not update `bun.lock`. Default `false`. If `package.json` and the existing `bun.lock` are not in agreement, this will error.

```toml title="bunfig.toml" icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
[install]
frozenLockfile = false
```

### `install.dryRun`

Whether `bun install` will actually install dependencies. Default `false`. When true, it's equivalent to setting `--dry-run` on all `bun install` commands.

```toml title="bunfig.toml" icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
[install]
dryRun = false
```

### `install.globalDir`

To configure the directory where Bun puts globally installed packages.

Environment variable: `BUN_INSTALL_GLOBAL_DIR`

```toml title="bunfig.toml" icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
[install]
# where `bun install --global` installs packages
globalDir = "~/.bun/install/global"
```

### `install.globalBinDir`

To configure the directory where Bun installs globally installed binaries and CLIs.

Environment variable: `BUN_INSTALL_BIN`

```toml title="bunfig.toml" icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
[install]
# where globally-installed package bins are linked
globalBinDir = "~/.bun/bin"
```

### `install.registry`

The default registry is `https://registry.npmjs.org/`. This can be globally configured in `bunfig.toml`:

```toml title="bunfig.toml" icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
[install]
# set default registry as a string
registry = "https://registry.npmjs.org"
# set a token
registry = { url = "https://registry.npmjs.org", token = "123456" }
# set a username/password
registry = "https://username:password@registry.npmjs.org"
```

### `install.linkWorkspacePackages`

To configure how workspace packages are linked, use the `install.linkWorkspacePackages` option.

Whether to link workspace packages from the monorepo root to their respective `node_modules` directories. Default `true`.

```toml title="bunfig.toml" icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
[install]
linkWorkspacePackages = true
```

### `install.scopes`

To configure a registry for a particular scope (e.g. `@myorg/<package>`) use `install.scopes`. You can reference environment variables with `$variable` notation.

```toml title="bunfig.toml" icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
[install.scopes]
# registry as string
myorg = "https://username:password@registry.myorg.com/"

# registry with username/password
# you can reference environment variables
myorg = { username = "myusername", password = "$npm_password", url = "https://registry.myorg.com/" }

# registry with token
myorg = { token = "$npm_token", url = "https://registry.myorg.com/" }
```

### `install.ca` and `install.cafile`

To configure a CA certificate, use `install.ca` or `install.cafile` to specify a path to a CA certificate file.

```toml title="bunfig.toml" icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
[install]
# The CA certificate as a string
ca = "-----BEGIN CERTIFICATE-----\n...\n-----END CERTIFICATE-----"

# A path to a CA certificate file. The file can contain multiple certificates.
cafile = "path/to/cafile"
```

### `install.cache`

To configure the cache behavior:

```toml title="bunfig.toml" icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
[install.cache]

# the directory to use for the cache
dir = "~/.bun/install/cache"

# when true, don't load from the global cache.
# Bun may still write to node_modules/.cache
disable = false

# when true, always resolve the latest versions from the registry
disableManifest = false
```

### `install.lockfile`

To configure lockfile behavior, use the `install.lockfile` section.

Whether to generate a lockfile on `bun install`. Default `true`.

```toml title="bunfig.toml" icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
[install.lockfile]
save = true
```

Whether to generate a non-Bun lockfile alongside `bun.lock`. (A `bun.lock` will always be created.) Currently `"yarn"` is the only supported value.

```toml title="bunfig.toml" icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
[install.lockfile]
print = "yarn"
```

### `install.linker`

Configure the linker strategy for installing dependencies. Defaults to `"isolated"` for new workspaces, `"hoisted"` for new single-package projects and existing projects (made pre-v1.3.2).

For complete documentation refer to [Package manager > Isolated installs](/pm/isolated-installs).

```toml title="bunfig.toml" icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
[install]
linker = "hoisted"
```

Valid values are:

| Value        | Description                                             |
| ------------ | ------------------------------------------------------- |
| `"hoisted"`  | Link dependencies in a shared `node_modules` directory. |
| `"isolated"` | Link dependencies inside each package installation.     |

```toml title="bunfig.toml" icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
[debug]
# When navigating to a blob: or src: link, open the file in your editor
# If not, it tries $EDITOR or $VISUAL
# If that still fails, it will try Visual Studio Code, then Sublime Text, then a few others
# This is used by Bun.openInEditor()
editor = "code"

# List of editors:
# - "subl", "sublime"
# - "vscode", "code"
# - "textmate", "mate"
# - "idea"
# - "webstorm"
# - "nvim", "neovim"
# - "vim","vi"
# - "emacs"
```

### `install.security.scanner`

Configure a security scanner to scan packages for vulnerabilities before installation.

First, install a security scanner from npm:

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun add -d @acme/bun-security-scanner
```

Then configure it in your `bunfig.toml`:

```toml bunfig.toml icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
[install.security]
scanner = "@acme/bun-security-scanner"
```

When a security scanner is configured:

* Auto-install is automatically disabled for security
* Packages are scanned before installation
* Installation is cancelled if fatal issues are found
* Security warnings are displayed during installation

Learn more about [using and writing security scanners](/pm/security-scanner-api).

### `install.minimumReleaseAge`

Configure a minimum age (in seconds) for npm package versions. Package versions published more recently than this threshold will be filtered out during installation. Default is `null` (disabled).

```toml title="bunfig.toml" icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
[install]
# Only install package versions published at least 3 days ago
minimumReleaseAge = 259200
# These packages will bypass the 3-day minimum age requirement
minimumReleaseAgeExcludes = ["@types/bun", "typescript"]
```

For more details see [Minimum release age](/pm/cli/install#minimum-release-age) in the install documentation.

## `bun run`

The `bun run` command can be configured under the `[run]` section. These apply to the `bun run` command and the `bun` command when running a file or executable or script.

Currently, `bunfig.toml` is only automatically loaded for `bun run` in a local project (it doesn't check for a global `.bunfig.toml`).

### `run.shell` - use the system shell or Bun's shell

The shell to use when running package.json scripts via `bun run` or `bun`. On Windows, this defaults to `"bun"` and on other platforms it defaults to `"system"`.

To always use the system shell instead of Bun's shell (default behavior unless Windows):

```toml title="bunfig.toml" icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
[run]
# default outside of Windows
shell = "system"
```

To always use Bun's shell instead of the system shell:

```toml title="bunfig.toml" icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
[run]
# default on Windows
shell = "bun"
```

### `run.bun` - auto alias `node` to `bun`

When `true`, this prepends `$PATH` with a `node` symlink that points to the `bun` binary for all scripts or executables invoked by `bun run` or `bun`.

This means that if you have a script that runs `node`, it will actually run `bun` instead, without needing to change your script. This works recursively, so if your script runs another script that runs `node`, it will also run `bun` instead. This applies to shebangs as well, so if you have a script with a shebang that points to `node`, it will actually run `bun` instead.

By default, this is enabled if `node` is not already in your `$PATH`.

```toml title="bunfig.toml" icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
[run]
# equivalent to `bun --bun` for all `bun run` commands
bun = true
```

You can test this by running:

```sh theme={"theme":{"light":"github-light","dark":"dracula"}}
bun --bun which node # /path/to/bun
bun which node # /path/to/node
```

This option is equivalent to prefixing all `bun run` commands with `--bun`:

```sh theme={"theme":{"light":"github-light","dark":"dracula"}}
bun --bun run dev
bun --bun dev
bun run --bun dev
```

If set to `false`, this will disable the `node` symlink.

### `run.silent` - suppress reporting the command being run

When `true`, suppresses the output of the command being run by `bun run` or `bun`.

```toml title="bunfig.toml" icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
[run]
silent = true
```

Without this option, the command being run will be printed to the console:

```sh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun run dev
echo "Running \"dev\"..."
```

```txt theme={"theme":{"light":"github-light","dark":"dracula"}}
Running "dev"...
```

With this option, the command being run will not be printed to the console:

```sh theme={"theme":{"light":"github-light","dark":"dracula"}}
bun run dev
```

```txt theme={"theme":{"light":"github-light","dark":"dracula"}}
Running "dev"...
```

This is equivalent to passing `--silent` to all `bun run` commands:

```sh theme={"theme":{"light":"github-light","dark":"dracula"}}
bun --silent run dev
bun --silent dev
bun run --silent dev
```


# C Compiler
Source: https://bun.com/docs/runtime/c-compiler

Compile and run C from JavaScript with low overhead

`bun:ffi` has experimental support for compiling and running C from JavaScript with low overhead.

***

## Usage (cc in `bun:ffi`)

See the [introduction blog post](https://bun.com/blog/compile-and-run-c-in-js) for more information.

JavaScript:

```ts hello.ts icon="file-code" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { cc } from "bun:ffi";
import source from "./hello.c" with { type: "file" };

const {
  symbols: { hello },
} = cc({
  source,
  symbols: {
    hello: {
      args: [],
      returns: "int",
    },
  },
});

console.log("What is the answer to the universe?", hello());
```

C source:

```c hello.c theme={"theme":{"light":"github-light","dark":"dracula"}}
int hello() {
  return 42;
}
```

When you run `hello.js`, it will print:

```sh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun hello.js
What is the answer to the universe? 42
```

Under the hood, `cc` uses [TinyCC](https://bellard.org/tcc/) to compile the C code and then link it with the JavaScript runtime, efficiently converting types in-place.

### Primitive types

The same `FFIType` values in [`dlopen`](/runtime/ffi) are supported in `cc`.

| `FFIType`   | C Type         | Aliases                     |
| ----------- | -------------- | --------------------------- |
| cstring     | `char*`        |                             |
| function    | `(void*)(*)()` | `fn`, `callback`            |
| ptr         | `void*`        | `pointer`, `void*`, `char*` |
| i8          | `int8_t`       | `int8_t`                    |
| i16         | `int16_t`      | `int16_t`                   |
| i32         | `int32_t`      | `int32_t`, `int`            |
| i64         | `int64_t`      | `int64_t`                   |
| i64\_fast   | `int64_t`      |                             |
| u8          | `uint8_t`      | `uint8_t`                   |
| u16         | `uint16_t`     | `uint16_t`                  |
| u32         | `uint32_t`     | `uint32_t`                  |
| u64         | `uint64_t`     | `uint64_t`                  |
| u64\_fast   | `uint64_t`     |                             |
| f32         | `float`        | `float`                     |
| f64         | `double`       | `double`                    |
| bool        | `bool`         |                             |
| char        | `char`         |                             |
| napi\_env   | `napi_env`     |                             |
| napi\_value | `napi_value`   |                             |

### Strings, objects, and non-primitive types

To make it easier to work with strings, objects, and other non-primitive types that don't map 1:1 to C types, `cc` supports N-API.

To pass or receive a JavaScript values without any type conversions from a C function, you can use `napi_value`.

You can also pass a `napi_env` to receive the N-API environment used to call the JavaScript function.

#### Returning a C string to JavaScript

For example, if you have a string in C, you can return it to JavaScript like this:

```ts hello.ts theme={"theme":{"light":"github-light","dark":"dracula"}}
import { cc } from "bun:ffi";
import source from "./hello.c" with { type: "file" };

const {
  symbols: { hello },
} = cc({
  source,
  symbols: {
    hello: {
      args: ["napi_env"],
      returns: "napi_value",
    },
  },
});

const result = hello();
```

And in C:

```c hello.c theme={"theme":{"light":"github-light","dark":"dracula"}}
#include <node/node_api.h>

napi_value hello(napi_env env) {
  napi_value result;
  napi_create_string_utf8(env, "Hello, Napi!", NAPI_AUTO_LENGTH, &result);
  return result;
}
```

You can also use this to return other types like objects and arrays:

```c hello.c theme={"theme":{"light":"github-light","dark":"dracula"}}
#include <node/node_api.h>

napi_value hello(napi_env env) {
  napi_value result;
  napi_create_object(env, &result);
  return result;
}
```

### `cc` Reference

#### `library: string[]`

The `library` array is used to specify the libraries that should be linked with the C code.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
type Library = string[];

cc({
  source: "hello.c",
  library: ["sqlite3"],
});
```

#### `symbols`

The `symbols` object is used to specify the functions and variables that should be exposed to JavaScript.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
type Symbols = {
  [key: string]: {
    args: FFIType[];
    returns: FFIType;
  };
};
```

#### `source`

The `source` is a file path to the C code that should be compiled and linked with the JavaScript runtime.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
type Source = string | URL | BunFile;

cc({
  source: "hello.c",
  symbols: {
    hello: {
      args: [],
      returns: "int",
    },
  },
});
```

#### `flags: string | string[]`

The `flags` is an optional array of strings that should be passed to the TinyCC compiler.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
type Flags = string | string[];
```

These are flags like `-I` for include directories and `-D` for preprocessor definitions.

#### `define: Record<string, string>`

The `define` is an optional object that should be passed to the TinyCC compiler.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
type Defines = Record<string, string>;

cc({
  source: "hello.c",
  define: {
    NDEBUG: "1",
  },
});
```

These are preprocessor definitions passed to the TinyCC compiler.


# Spawn
Source: https://bun.com/docs/runtime/child-process

Spawn child processes with `Bun.spawn` or `Bun.spawnSync`

## Spawn a process (`Bun.spawn()`)

Provide a command as an array of strings. The result of `Bun.spawn()` is a `Bun.Subprocess` object.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
const proc = Bun.spawn(["bun", "--version"]);
console.log(await proc.exited); // 0
```

The second argument to `Bun.spawn` is a parameters object that can be used to configure the subprocess.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
const proc = Bun.spawn(["bun", "--version"], {
  cwd: "./path/to/subdir", // specify a working directory
  env: { ...process.env, FOO: "bar" }, // specify environment variables
  onExit(proc, exitCode, signalCode, error) {
    // exit handler
  },
});

proc.pid; // process ID of subprocess
```

## Input stream

By default, the input stream of the subprocess is undefined; it can be configured with the `stdin` parameter.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
const proc = Bun.spawn(["cat"], {
  stdin: await fetch("https://raw.githubusercontent.com/oven-sh/bun/main/examples/hashing.js"),
});

const text = await proc.stdout.text();
console.log(text); // "const input = "hello world".repeat(400); ..."
```

| Value                    | Description                                      |
| ------------------------ | ------------------------------------------------ |
| `null`                   | **Default.** Provide no input to the subprocess  |
| `"pipe"`                 | Return a `FileSink` for fast incremental writing |
| `"inherit"`              | Inherit the `stdin` of the parent process        |
| `Bun.file()`             | Read from the specified file                     |
| `TypedArray \| DataView` | Use a binary buffer as input                     |
| `Response`               | Use the response `body` as input                 |
| `Request`                | Use the request `body` as input                  |
| `ReadableStream`         | Use a readable stream as input                   |
| `Blob`                   | Use a blob as input                              |
| `number`                 | Read from the file with a given file descriptor  |

The `"pipe"` option lets incrementally write to the subprocess's input stream from the parent process.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
const proc = Bun.spawn(["cat"], {
  stdin: "pipe", // return a FileSink for writing
});

// enqueue string data
proc.stdin.write("hello");

// enqueue binary data
const enc = new TextEncoder();
proc.stdin.write(enc.encode(" world!"));

// send buffered data
proc.stdin.flush();

// close the input stream
proc.stdin.end();
```

Passing a `ReadableStream` to `stdin` lets you pipe data from a JavaScript `ReadableStream` directly to the subprocess's input:

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
const stream = new ReadableStream({
  start(controller) {
    controller.enqueue("Hello from ");
    controller.enqueue("ReadableStream!");
    controller.close();
  },
});

const proc = Bun.spawn(["cat"], {
  stdin: stream,
  stdout: "pipe",
});

const output = await proc.stdout.text();
console.log(output); // "Hello from ReadableStream!"
```

## Output streams

You can read results from the subprocess via the `stdout` and `stderr` properties. By default these are instances of `ReadableStream`.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
const proc = Bun.spawn(["bun", "--version"]);
const text = await proc.stdout.text();
console.log(text); // => "1.3.3\n"
```

Configure the output stream by passing one of the following values to `stdout/stderr`:

| Value        | Description                                                                                         |
| ------------ | --------------------------------------------------------------------------------------------------- |
| `"pipe"`     | **Default for `stdout`.** Pipe the output to a `ReadableStream` on the returned `Subprocess` object |
| `"inherit"`  | **Default for `stderr`.** Inherit from the parent process                                           |
| `"ignore"`   | Discard the output                                                                                  |
| `Bun.file()` | Write to the specified file                                                                         |
| `number`     | Write to the file with the given file descriptor                                                    |

## Exit handling

Use the `onExit` callback to listen for the process exiting or being killed.

```ts index.ts icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
const proc = Bun.spawn(["bun", "--version"], {
  onExit(proc, exitCode, signalCode, error) {
    // exit handler
  },
});
```

For convenience, the `exited` property is a `Promise` that resolves when the process exits.

```ts index.ts icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
const proc = Bun.spawn(["bun", "--version"]);

await proc.exited; // resolves when process exit
proc.killed; // boolean — was the process killed?
proc.exitCode; // null | number
proc.signalCode; // null | "SIGABRT" | "SIGALRM" | ...
```

To kill a process:

```ts index.ts icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
const proc = Bun.spawn(["bun", "--version"]);
proc.kill();
proc.killed; // true

proc.kill(15); // specify a signal code
proc.kill("SIGTERM"); // specify a signal name
```

The parent `bun` process will not terminate until all child processes have exited. Use `proc.unref()` to detach the child process from the parent.

```ts index.ts icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
const proc = Bun.spawn(["bun", "--version"]);
proc.unref();
```

## Resource usage

You can get information about the process's resource usage after it has exited:

```ts index.ts icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
const proc = Bun.spawn(["bun", "--version"]);
await proc.exited;

const usage = proc.resourceUsage();
console.log(`Max memory used: ${usage.maxRSS} bytes`);
console.log(`CPU time (user): ${usage.cpuTime.user} µs`);
console.log(`CPU time (system): ${usage.cpuTime.system} µs`);
```

## Using AbortSignal

You can abort a subprocess using an `AbortSignal`:

```ts index.ts icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
const controller = new AbortController();
const { signal } = controller;

const proc = Bun.spawn({
  cmd: ["sleep", "100"],
  signal,
});

// Later, to abort the process:
controller.abort();
```

## Using timeout and killSignal

You can set a timeout for a subprocess to automatically terminate after a specific duration:

```ts index.ts icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
// Kill the process after 5 seconds
const proc = Bun.spawn({
  cmd: ["sleep", "10"],
  timeout: 5000, // 5 seconds in milliseconds
});

await proc.exited; // Will resolve after 5 seconds
```

By default, timed-out processes are killed with the `SIGTERM` signal. You can specify a different signal with the `killSignal` option:

```ts index.ts icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
// Kill the process with SIGKILL after 5 seconds
const proc = Bun.spawn({
  cmd: ["sleep", "10"],
  timeout: 5000,
  killSignal: "SIGKILL", // Can be string name or signal number
});
```

The `killSignal` option also controls which signal is sent when an AbortSignal is aborted.

## Using maxBuffer

For spawnSync, you can limit the maximum number of bytes of output before the process is killed:

```ts index.ts icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
// Kill 'yes' after it emits over 100 bytes of output
const result = Bun.spawnSync({
  cmd: ["yes"], // or ["bun", "exec", "yes"] on Windows
  maxBuffer: 100,
});
// process exits
```

## Inter-process communication (IPC)

Bun supports direct inter-process communication channel between two `bun` processes. To receive messages from a spawned Bun subprocess, specify an `ipc` handler.

```ts parent.ts icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
const child = Bun.spawn(["bun", "child.ts"], {
  ipc(message) {
    /**
     * The message received from the sub process
     **/
  },
});
```

The parent process can send messages to the subprocess using the `.send()` method on the returned `Subprocess` instance. A reference to the sending subprocess is also available as the second argument in the `ipc` handler.

```ts parent.ts icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
const childProc = Bun.spawn(["bun", "child.ts"], {
  ipc(message, childProc) {
    /**
     * The message received from the sub process
     **/
    childProc.send("Respond to child");
  },
});

childProc.send("I am your father"); // The parent can send messages to the child as well
```

Meanwhile the child process can send messages to its parent using with `process.send()` and receive messages with `process.on("message")`. This is the same API used for `child_process.fork()` in Node.js.

```ts child.ts theme={"theme":{"light":"github-light","dark":"dracula"}}
process.send("Hello from child as string");
process.send({ message: "Hello from child as object" });

process.on("message", message => {
  // print message from parent
  console.log(message);
});
```

```ts child.ts theme={"theme":{"light":"github-light","dark":"dracula"}}
// send a string
process.send("Hello from child as string");

// send an object
process.send({ message: "Hello from child as object" });
```

The `serialization` option controls the underlying communication format between the two processes:

* `advanced`: (default) Messages are serialized using the JSC `serialize` API, which supports cloning [everything `structuredClone` supports](https://developer.mozilla.org/en-US/docs/Web/API/Web_Workers_API/Structured_clone_algorithm). This does not support transferring ownership of objects.
* `json`: Messages are serialized using `JSON.stringify` and `JSON.parse`, which does not support as many object types as `advanced` does.

To disconnect the IPC channel from the parent process, call:

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
childProc.disconnect();
```

### IPC between Bun & Node.js

To use IPC between a `bun` process and a Node.js process, set `serialization: "json"` in `Bun.spawn`. This is because Node.js and Bun use different JavaScript engines with different object serialization formats.

```js bun-node-ipc.js icon="file-code" theme={"theme":{"light":"github-light","dark":"dracula"}}
if (typeof Bun !== "undefined") {
  const prefix = `[bun ${process.versions.bun} 🐇]`;
  const node = Bun.spawn({
    cmd: ["node", __filename],
    ipc({ message }) {
      console.log(message);
      node.send({ message: `${prefix} 👋 hey node` });
      node.kill();
    },
    stdio: ["inherit", "inherit", "inherit"],
    serialization: "json",
  });

  node.send({ message: `${prefix} 👋 hey node` });
} else {
  const prefix = `[node ${process.version}]`;
  process.on("message", ({ message }) => {
    console.log(message);
    process.send({ message: `${prefix} 👋 hey bun` });
  });
}
```

***

## Terminal (PTY) support

For interactive terminal applications, you can spawn a subprocess with a pseudo-terminal (PTY) attached using the `terminal` option. This makes the subprocess think it's running in a real terminal, enabling features like colored output, cursor movement, and interactive prompts.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
const proc = Bun.spawn(["bash"], {
  terminal: {
    cols: 80,
    rows: 24,
    data(terminal, data) {
      // Called when data is received from the terminal
      process.stdout.write(data);
    },
  },
});

// Write to the terminal
proc.terminal.write("echo hello\n");

// Wait for the process to exit
await proc.exited;

// Close the terminal
proc.terminal.close();
```

When the `terminal` option is provided:

* The subprocess sees `process.stdout.isTTY` as `true`
* `stdin`, `stdout`, and `stderr` are all connected to the terminal
* `proc.stdin`, `proc.stdout`, and `proc.stderr` return `null` — use the terminal instead
* Access the terminal via `proc.terminal`

### Terminal options

| Option  | Description                                                                                                                                                        | Default            |
| ------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------ |
| `cols`  | Number of columns                                                                                                                                                  | `80`               |
| `rows`  | Number of rows                                                                                                                                                     | `24`               |
| `name`  | Terminal type for PTY configuration (set `TERM` env var separately via `env` option)                                                                               | `"xterm-256color"` |
| `data`  | Callback when data is received `(terminal, data) => void`                                                                                                          | —                  |
| `exit`  | Callback when PTY stream closes (EOF or error). `exitCode` is PTY lifecycle status (0=EOF, 1=error), not subprocess exit code. Use `proc.exited` for process exit. | —                  |
| `drain` | Callback when ready for more data `(terminal) => void`                                                                                                             | —                  |

### Terminal methods

The `Terminal` object returned by `proc.terminal` has the following methods:

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
// Write data to the terminal
proc.terminal.write("echo hello\n");

// Resize the terminal
proc.terminal.resize(120, 40);

// Set raw mode (disable line buffering and echo)
proc.terminal.setRawMode(true);

// Keep event loop alive while terminal is open
proc.terminal.ref();
proc.terminal.unref();

// Close the terminal
proc.terminal.close();
```

### Reusable Terminal

You can create a terminal independently and reuse it across multiple subprocesses:

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
await using terminal = new Bun.Terminal({
  cols: 80,
  rows: 24,
  data(term, data) {
    process.stdout.write(data);
  },
});

// Spawn first process
const proc1 = Bun.spawn(["echo", "first"], { terminal });
await proc1.exited;

// Reuse terminal for another process
const proc2 = Bun.spawn(["echo", "second"], { terminal });
await proc2.exited;

// Terminal is closed automatically by `await using`
```

When passing an existing `Terminal` object:

* The terminal can be reused across multiple spawns
* You control when to close the terminal
* The `exit` callback fires when you call `terminal.close()`, not when each subprocess exits
* Use `proc.exited` to detect individual subprocess exits

This is useful for running multiple commands in sequence through the same terminal session.

<Note>Terminal support is only available on POSIX systems (Linux, macOS). It is not available on Windows.</Note>

***

## Blocking API (`Bun.spawnSync()`)

Bun provides a synchronous equivalent of `Bun.spawn` called `Bun.spawnSync`. This is a blocking API that supports the same inputs and parameters as `Bun.spawn`. It returns a `SyncSubprocess` object, which differs from `Subprocess` in a few ways.

1. It contains a `success` property that indicates whether the process exited with a zero exit code.
2. The `stdout` and `stderr` properties are instances of `Buffer` instead of `ReadableStream`.
3. There is no `stdin` property. Use `Bun.spawn` to incrementally write to the subprocess's input stream.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
const proc = Bun.spawnSync(["echo", "hello"]);

console.log(proc.stdout.toString());
// => "hello\n"
```

As a rule of thumb, the asynchronous `Bun.spawn` API is better for HTTP servers and apps, and `Bun.spawnSync` is better for building command-line tools.

***

## Benchmarks

<Note>
  ⚡️ Under the hood, `Bun.spawn` and `Bun.spawnSync` use
  [`posix_spawn(3)`](https://man7.org/linux/man-pages/man3/posix_spawn.3.html).
</Note>

Bun's `spawnSync` spawns processes 60% faster than the Node.js `child_process` module.

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun spawn.mjs
```

```txt theme={"theme":{"light":"github-light","dark":"dracula"}}
cpu: Apple M1 Max
runtime: bun 1.x (arm64-darwin)

benchmark              time (avg)             (min … max)       p75       p99      p995
--------------------------------------------------------- -----------------------------
spawnSync echo hi  888.14 µs/iter    (821.83 µs … 1.2 ms) 905.92 µs      1 ms   1.03 ms
```

```sh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
node spawn.node.mjs
```

```txt theme={"theme":{"light":"github-light","dark":"dracula"}}
cpu: Apple M1 Max
runtime: node v18.9.1 (arm64-darwin)

benchmark              time (avg)             (min … max)       p75       p99      p995
--------------------------------------------------------- -----------------------------
spawnSync echo hi    1.47 ms/iter     (1.14 ms … 2.64 ms)   1.57 ms   2.37 ms   2.52 ms
```

***

## Reference

A reference of the Spawn API and types are shown below. The real types have complex generics to strongly type the `Subprocess` streams with the options passed to `Bun.spawn` and `Bun.spawnSync`. For full details, find these types as defined [bun.d.ts](https://github.com/oven-sh/bun/blob/main/packages/bun-types/bun.d.ts).

```ts See Typescript Definitions expandable theme={"theme":{"light":"github-light","dark":"dracula"}}
interface Bun {
  spawn(command: string[], options?: SpawnOptions.OptionsObject): Subprocess;
  spawnSync(command: string[], options?: SpawnOptions.OptionsObject): SyncSubprocess;

  spawn(options: { cmd: string[] } & SpawnOptions.OptionsObject): Subprocess;
  spawnSync(options: { cmd: string[] } & SpawnOptions.OptionsObject): SyncSubprocess;
}

namespace SpawnOptions {
  interface OptionsObject {
    cwd?: string;
    env?: Record<string, string | undefined>;
    stdio?: [Writable, Readable, Readable];
    stdin?: Writable;
    stdout?: Readable;
    stderr?: Readable;
    onExit?(
      subprocess: Subprocess,
      exitCode: number | null,
      signalCode: number | null,
      error?: ErrorLike,
    ): void | Promise<void>;
    ipc?(message: any, subprocess: Subprocess): void;
    serialization?: "json" | "advanced";
    windowsHide?: boolean;
    windowsVerbatimArguments?: boolean;
    argv0?: string;
    signal?: AbortSignal;
    timeout?: number;
    killSignal?: string | number;
    maxBuffer?: number;
    terminal?: TerminalOptions; // PTY support (POSIX only)
  }

  type Readable =
    | "pipe"
    | "inherit"
    | "ignore"
    | null // equivalent to "ignore"
    | undefined // to use default
    | BunFile
    | ArrayBufferView
    | number;

  type Writable =
    | "pipe"
    | "inherit"
    | "ignore"
    | null // equivalent to "ignore"
    | undefined // to use default
    | BunFile
    | ArrayBufferView
    | number
    | ReadableStream
    | Blob
    | Response
    | Request;
}

interface Subprocess extends AsyncDisposable {
  readonly stdin: FileSink | number | undefined | null;
  readonly stdout: ReadableStream<Uint8Array<ArrayBuffer>> | number | undefined | null;
  readonly stderr: ReadableStream<Uint8Array<ArrayBuffer>> | number | undefined | null;
  readonly readable: ReadableStream<Uint8Array<ArrayBuffer>> | number | undefined | null;
  readonly terminal: Terminal | undefined;
  readonly pid: number;
  readonly exited: Promise<number>;
  readonly exitCode: number | null;
  readonly signalCode: NodeJS.Signals | null;
  readonly killed: boolean;

  kill(exitCode?: number | NodeJS.Signals): void;
  ref(): void;
  unref(): void;

  send(message: any): void;
  disconnect(): void;
  resourceUsage(): ResourceUsage | undefined;
}

interface SyncSubprocess {
  stdout: Buffer | undefined;
  stderr: Buffer | undefined;
  exitCode: number;
  success: boolean;
  resourceUsage: ResourceUsage;
  signalCode?: string;
  exitedDueToTimeout?: true;
  pid: number;
}

interface TerminalOptions {
  cols?: number;
  rows?: number;
  name?: string;
  data?: (terminal: Terminal, data: Uint8Array<ArrayBuffer>) => void;
  /** Called when PTY stream closes (EOF or error). exitCode is PTY lifecycle status (0=EOF, 1=error), not subprocess exit code. */
  exit?: (terminal: Terminal, exitCode: number, signal: string | null) => void;
  drain?: (terminal: Terminal) => void;
}

interface Terminal extends AsyncDisposable {
  readonly stdin: number;
  readonly stdout: number;
  readonly closed: boolean;
  write(data: string | BufferSource): number;
  resize(cols: number, rows: number): void;
  setRawMode(enabled: boolean): void;
  ref(): void;
  unref(): void;
  close(): void;
}

interface ResourceUsage {
  contextSwitches: {
    voluntary: number;
    involuntary: number;
  };

  cpuTime: {
    user: number;
    system: number;
    total: number;
  };
  maxRSS: number;

  messages: {
    sent: number;
    received: number;
  };
  ops: {
    in: number;
    out: number;
  };
  shmSize: number;
  signalCount: number;
  swapCount: number;
}

type Signal =
  | "SIGABRT"
  | "SIGALRM"
  | "SIGBUS"
  | "SIGCHLD"
  | "SIGCONT"
  | "SIGFPE"
  | "SIGHUP"
  | "SIGILL"
  | "SIGINT"
  | "SIGIO"
  | "SIGIOT"
  | "SIGKILL"
  | "SIGPIPE"
  | "SIGPOLL"
  | "SIGPROF"
  | "SIGPWR"
  | "SIGQUIT"
  | "SIGSEGV"
  | "SIGSTKFLT"
  | "SIGSTOP"
  | "SIGSYS"
  | "SIGTERM"
  | "SIGTRAP"
  | "SIGTSTP"
  | "SIGTTIN"
  | "SIGTTOU"
  | "SIGUNUSED"
  | "SIGURG"
  | "SIGUSR1"
  | "SIGUSR2"
  | "SIGVTALRM"
  | "SIGWINCH"
  | "SIGXCPU"
  | "SIGXFSZ"
  | "SIGBREAK"
  | "SIGLOST"
  | "SIGINFO";
```


# Color
Source: https://bun.com/docs/runtime/color

Format colors as CSS, ANSI, numbers, hex strings, and more

`Bun.color(input, outputFormat?)` leverages Bun's CSS parser to parse, normalize, and convert colors from user input to a variety of output formats, including:

| Format       | Example                          |
| ------------ | -------------------------------- |
| `"css"`      | `"red"`                          |
| `"ansi"`     | `"\x1b[38;2;255;0;0m"`           |
| `"ansi-16"`  | `"\x1b[38;5;\tm"`                |
| `"ansi-256"` | `"\x1b[38;5;196m"`               |
| `"ansi-16m"` | `"\x1b[38;2;255;0;0m"`           |
| `"number"`   | `0x1a2b3c`                       |
| `"rgb"`      | `"rgb(255, 99, 71)"`             |
| `"rgba"`     | `"rgba(255, 99, 71, 0.5)"`       |
| `"hsl"`      | `"hsl(120, 50%, 50%)"`           |
| `"hex"`      | `"#1a2b3c"`                      |
| `"HEX"`      | `"#1A2B3C"`                      |
| `"{rgb}"`    | `{ r: 255, g: 99, b: 71 }`       |
| `"{rgba}"`   | `{ r: 255, g: 99, b: 71, a: 1 }` |
| `"[rgb]"`    | `[ 255, 99, 71 ]`                |
| `"[rgba]"`   | `[ 255, 99, 71, 255]`            |

There are many different ways to use this API:

* Validate and normalize colors to persist in a database (`number` is the most database-friendly)
* Convert colors to different formats
* Colorful logging beyond the 16 colors many use today (use `ansi` if you don't want to figure out what the user's terminal supports, otherwise use `ansi-16`, `ansi-256`, or `ansi-16m` for how many colors the terminal supports)
* Format colors for use in CSS injected into HTML
* Get the `r`, `g`, `b`, and `a` color components as JavaScript objects or numbers from a CSS color string

You can think of this as an alternative to the popular npm packages [`color`](https://github.com/Qix-/color) and [`tinycolor2`](https://github.com/bgrins/TinyColor) except with full support for parsing CSS color strings and zero dependencies built directly into Bun.

### Flexible input

You can pass in any of the following:

* Standard CSS color names like `"red"`
* Numbers like `0xff0000`
* Hex strings like `"#f00"`
* RGB strings like `"rgb(255, 0, 0)"`
* RGBA strings like `"rgba(255, 0, 0, 1)"`
* HSL strings like `"hsl(0, 100%, 50%)"`
* HSLA strings like `"hsla(0, 100%, 50%, 1)"`
* RGB objects like `{ r: 255, g: 0, b: 0 }`
* RGBA objects like `{ r: 255, g: 0, b: 0, a: 1 }`
* RGB arrays like `[255, 0, 0]`
* RGBA arrays like `[255, 0, 0, 255]`
* LAB strings like `"lab(50% 50% 50%)"`
* ... anything else that CSS can parse as a single color value

### Format colors as CSS

The `"css"` format outputs valid CSS for use in stylesheets, inline styles, CSS variables, css-in-js, etc. It returns the most compact representation of the color as a string.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
Bun.color("red", "css"); // "red"
Bun.color(0xff0000, "css"); // "#f000"
Bun.color("#f00", "css"); // "red"
Bun.color("#ff0000", "css"); // "red"
Bun.color("rgb(255, 0, 0)", "css"); // "red"
Bun.color("rgba(255, 0, 0, 1)", "css"); // "red"
Bun.color("hsl(0, 100%, 50%)", "css"); // "red"
Bun.color("hsla(0, 100%, 50%, 1)", "css"); // "red"
Bun.color({ r: 255, g: 0, b: 0 }, "css"); // "red"
Bun.color({ r: 255, g: 0, b: 0, a: 1 }, "css"); // "red"
Bun.color([255, 0, 0], "css"); // "red"
Bun.color([255, 0, 0, 255], "css"); // "red"
```

If the input is unknown or fails to parse, `Bun.color` returns `null`.

### Format colors as ANSI (for terminals)

The `"ansi"` format outputs ANSI escape codes for use in terminals to make text colorful.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
Bun.color("red", "ansi"); // "\u001b[38;2;255;0;0m"
Bun.color(0xff0000, "ansi"); // "\u001b[38;2;255;0;0m"
Bun.color("#f00", "ansi"); // "\u001b[38;2;255;0;0m"
Bun.color("#ff0000", "ansi"); // "\u001b[38;2;255;0;0m"
Bun.color("rgb(255, 0, 0)", "ansi"); // "\u001b[38;2;255;0;0m"
Bun.color("rgba(255, 0, 0, 1)", "ansi"); // "\u001b[38;2;255;0;0m"
Bun.color("hsl(0, 100%, 50%)", "ansi"); // "\u001b[38;2;255;0;0m"
Bun.color("hsla(0, 100%, 50%, 1)", "ansi"); // "\u001b[38;2;255;0;0m"
Bun.color({ r: 255, g: 0, b: 0 }, "ansi"); // "\u001b[38;2;255;0;0m"
Bun.color({ r: 255, g: 0, b: 0, a: 1 }, "ansi"); // "\u001b[38;2;255;0;0m"
Bun.color([255, 0, 0], "ansi"); // "\u001b[38;2;255;0;0m"
Bun.color([255, 0, 0, 255], "ansi"); // "\u001b[38;2;255;0;0m"
```

This gets the color depth of stdout and automatically chooses one of `"ansi-16m"`, `"ansi-256"`, `"ansi-16"` based on the environment variables. If stdout doesn't support any form of ANSI color, it returns an empty string. As with the rest of Bun's color API, if the input is unknown or fails to parse, it returns `null`.

#### 24-bit ANSI colors (`ansi-16m`)

The `"ansi-16m"` format outputs 24-bit ANSI colors for use in terminals to make text colorful. 24-bit color means you can display 16 million colors on supported terminals, and requires a modern terminal that supports it.

This converts the input color to RGBA, and then outputs that as an ANSI color.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
Bun.color("red", "ansi-16m"); // "\x1b[38;2;255;0;0m"
Bun.color(0xff0000, "ansi-16m"); // "\x1b[38;2;255;0;0m"
Bun.color("#f00", "ansi-16m"); // "\x1b[38;2;255;0;0m"
Bun.color("#ff0000", "ansi-16m"); // "\x1b[38;2;255;0;0m"
```

#### 256 ANSI colors (`ansi-256`)

The `"ansi-256"` format approximates the input color to the nearest of the 256 ANSI colors supported by some terminals.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
Bun.color("red", "ansi-256"); // "\u001b[38;5;196m"
Bun.color(0xff0000, "ansi-256"); // "\u001b[38;5;196m"
Bun.color("#f00", "ansi-256"); // "\u001b[38;5;196m"
Bun.color("#ff0000", "ansi-256"); // "\u001b[38;5;196m"
```

To convert from RGBA to one of the 256 ANSI colors, we ported the algorithm that [`tmux` uses](https://github.com/tmux/tmux/blob/dae2868d1227b95fd076fb4a5efa6256c7245943/colour.c#L44-L55).

#### 16 ANSI colors (`ansi-16`)

The `"ansi-16"` format approximates the input color to the nearest of the 16 ANSI colors supported by most terminals.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
Bun.color("red", "ansi-16"); // "\u001b[38;5;\tm"
Bun.color(0xff0000, "ansi-16"); // "\u001b[38;5;\tm"
Bun.color("#f00", "ansi-16"); // "\u001b[38;5;\tm"
Bun.color("#ff0000", "ansi-16"); // "\u001b[38;5;\tm"
```

This works by first converting the input to a 24-bit RGB color space, then to `ansi-256`, and then we convert that to the nearest 16 ANSI color.

### Format colors as numbers

The `"number"` format outputs a 24-bit number for use in databases, configuration, or any other use case where a compact representation of the color is desired.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
Bun.color("red", "number"); // 16711680
Bun.color(0xff0000, "number"); // 16711680
Bun.color({ r: 255, g: 0, b: 0 }, "number"); // 16711680
Bun.color([255, 0, 0], "number"); // 16711680
Bun.color("rgb(255, 0, 0)", "number"); // 16711680
Bun.color("rgba(255, 0, 0, 1)", "number"); // 16711680
Bun.color("hsl(0, 100%, 50%)", "number"); // 16711680
Bun.color("hsla(0, 100%, 50%, 1)", "number"); // 16711680
```

### Get the red, green, blue, and alpha channels

You can use the `"{rgba}"`, `"{rgb}"`, `"[rgba]"` and `"[rgb]"` formats to get the red, green, blue, and alpha channels as objects or arrays.

#### `{rgba}` object

The `"{rgba}"` format outputs an object with the red, green, blue, and alpha channels.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
type RGBAObject = {
  // 0 - 255
  r: number;
  // 0 - 255
  g: number;
  // 0 - 255
  b: number;
  // 0 - 1
  a: number;
};
```

Example:

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
Bun.color("hsl(0, 0%, 50%)", "{rgba}"); // { r: 128, g: 128, b: 128, a: 1 }
Bun.color("red", "{rgba}"); // { r: 255, g: 0, b: 0, a: 1 }
Bun.color(0xff0000, "{rgba}"); // { r: 255, g: 0, b: 0, a: 1 }
Bun.color({ r: 255, g: 0, b: 0 }, "{rgba}"); // { r: 255, g: 0, b: 0, a: 1 }
Bun.color([255, 0, 0], "{rgba}"); // { r: 255, g: 0, b: 0, a: 1 }
```

To behave similarly to CSS, the `a` channel is a decimal number between `0` and `1`.

The `"{rgb}"` format is similar, but it doesn't include the alpha channel.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
Bun.color("hsl(0, 0%, 50%)", "{rgb}"); // { r: 128, g: 128, b: 128 }
Bun.color("red", "{rgb}"); // { r: 255, g: 0, b: 0 }
Bun.color(0xff0000, "{rgb}"); // { r: 255, g: 0, b: 0 }
Bun.color({ r: 255, g: 0, b: 0 }, "{rgb}"); // { r: 255, g: 0, b: 0 }
Bun.color([255, 0, 0], "{rgb}"); // { r: 255, g: 0, b: 0 }
```

#### `[rgba]` array

The `"[rgba]"` format outputs an array with the red, green, blue, and alpha channels.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
// All values are 0 - 255
type RGBAArray = [number, number, number, number];
```

Example:

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
Bun.color("hsl(0, 0%, 50%)", "[rgba]"); // [128, 128, 128, 255]
Bun.color("red", "[rgba]"); // [255, 0, 0, 255]
Bun.color(0xff0000, "[rgba]"); // [255, 0, 0, 255]
Bun.color({ r: 255, g: 0, b: 0 }, "[rgba]"); // [255, 0, 0, 255]
Bun.color([255, 0, 0], "[rgba]"); // [255, 0, 0, 255]
```

Unlike the `"{rgba}"` format, the alpha channel is an integer between `0` and `255`. This is useful for typed arrays where each channel must be the same underlying type.

The `"[rgb]"` format is similar, but it doesn't include the alpha channel.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
Bun.color("hsl(0, 0%, 50%)", "[rgb]"); // [128, 128, 128]
Bun.color("red", "[rgb]"); // [255, 0, 0]
Bun.color(0xff0000, "[rgb]"); // [255, 0, 0]
Bun.color({ r: 255, g: 0, b: 0 }, "[rgb]"); // [255, 0, 0]
Bun.color([255, 0, 0], "[rgb]"); // [255, 0, 0]
```

### Format colors as hex strings

The `"hex"` format outputs a lowercase hex string for use in CSS or other contexts.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
Bun.color("hsl(0, 0%, 50%)", "hex"); // "#808080"
Bun.color("red", "hex"); // "#ff0000"
Bun.color(0xff0000, "hex"); // "#ff0000"
Bun.color({ r: 255, g: 0, b: 0 }, "hex"); // "#ff0000"
Bun.color([255, 0, 0], "hex"); // "#ff0000"
```

The `"HEX"` format is similar, but it outputs a hex string with uppercase letters instead of lowercase letters.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
Bun.color("hsl(0, 0%, 50%)", "HEX"); // "#808080"
Bun.color("red", "HEX"); // "#FF0000"
Bun.color(0xff0000, "HEX"); // "#FF0000"
Bun.color({ r: 255, g: 0, b: 0 }, "HEX"); // "#FF0000"
Bun.color([255, 0, 0], "HEX"); // "#FF0000"
```

### Bundle-time client-side color formatting

Like many of Bun's APIs, you can use macros to invoke `Bun.color` at bundle-time for use in client-side JavaScript builds:

```ts client-side.ts theme={"theme":{"light":"github-light","dark":"dracula"}}
import { color } from "bun" with { type: "macro" };

console.log(color("#f00", "css"));
```

Then, build the client-side code:

```sh theme={"theme":{"light":"github-light","dark":"dracula"}}
bun build ./client-side.ts
```

This will output the following to `client-side.js`:

```js theme={"theme":{"light":"github-light","dark":"dracula"}}
// client-side.ts
console.log("red");
```


# Console
Source: https://bun.com/docs/runtime/console

The console object in Bun

<Note>
  Bun provides a browser- and Node.js-compatible [console](https://developer.mozilla.org/en-US/docs/Web/API/console)
  global. This page only documents Bun-native APIs.
</Note>

***

## Object inspection depth

Bun allows you to configure how deeply nested objects are displayed in `console.log()` output:

* **CLI flag**: Use `--console-depth <number>` to set the depth for a single run
* **Configuration**: Set `console.depth` in your `bunfig.toml` for persistent configuration
* **Default**: Objects are inspected to a depth of `2` levels

```js theme={"theme":{"light":"github-light","dark":"dracula"}}
const nested = { a: { b: { c: { d: "deep" } } } };
console.log(nested);
// Default (depth 2): { a: { b: [Object] } }
// With depth 4: { a: { b: { c: { d: 'deep' } } } }
```

The CLI flag takes precedence over the configuration file setting.

***

## Reading from stdin

In Bun, the `console` object can be used as an `AsyncIterable` to sequentially read lines from `process.stdin`.

```ts adder.ts icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
for await (const line of console) {
  console.log(line);
}
```

This is useful for implementing interactive programs, like the following addition calculator.

```ts adder.ts icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
console.log(`Let's add some numbers!`);
console.write(`Count: 0\n> `);

let count = 0;
for await (const line of console) {
  count += Number(line);
  console.write(`Count: ${count}\n> `);
}
```

To run the file:

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun adder.ts
Let's add some numbers!
Count: 0
> 5
Count: 5
> 5
Count: 10
> 5
Count: 15
```


# Cookies
Source: https://bun.com/docs/runtime/cookies

Use Bun's native APIs for working with HTTP cookies

Bun provides native APIs for working with HTTP cookies through `Bun.Cookie` and `Bun.CookieMap`. These APIs offer fast, easy-to-use methods for parsing, generating, and manipulating cookies in HTTP requests and responses.

## CookieMap class

`Bun.CookieMap` provides a Map-like interface for working with collections of cookies. It implements the `Iterable` interface, allowing you to use it with `for...of` loops and other iteration methods.

```ts title="cookies.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
// Empty cookie map
const cookies = new Bun.CookieMap();

// From a cookie string
const cookies1 = new Bun.CookieMap("name=value; foo=bar");

// From an object
const cookies2 = new Bun.CookieMap({
  session: "abc123",
  theme: "dark",
});

// From an array of name/value pairs
const cookies3 = new Bun.CookieMap([
  ["session", "abc123"],
  ["theme", "dark"],
]);
```

### In HTTP servers

In Bun's HTTP server, the `cookies` property on the request object (in `routes`) is an instance of `CookieMap`:

```ts title="server.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
const server = Bun.serve({
  routes: {
    "/": req => {
      // Access request cookies
      const cookies = req.cookies;

      // Get a specific cookie
      const sessionCookie = cookies.get("session");
      if (sessionCookie != null) {
        console.log(sessionCookie);
      }

      // Check if a cookie exists
      if (cookies.has("theme")) {
        // ...
      }

      // Set a cookie, it will be automatically applied to the response
      cookies.set("visited", "true");

      return new Response("Hello");
    },
  },
});

console.log("Server listening at: " + server.url);
```

### Methods

#### `get(name: string): string | null`

Retrieves a cookie by name. Returns `null` if the cookie doesn't exist.

```ts title="get-cookie.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
// Get by name
const cookie = cookies.get("session");

if (cookie != null) {
  console.log(cookie);
}
```

#### `has(name: string): boolean`

Checks if a cookie with the given name exists.

```ts title="has-cookie.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
// Check if cookie exists
if (cookies.has("session")) {
  // Cookie exists
}
```

#### `set(name: string, value: string): void`

#### `set(options: CookieInit): void`

#### `set(cookie: Cookie): void`

Adds or updates a cookie in the map. Cookies default to `{ path: "/", sameSite: "lax" }`.

```ts title="set-cookie.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
// Set by name and value
cookies.set("session", "abc123");

// Set using options object
cookies.set({
  name: "theme",
  value: "dark",
  maxAge: 3600,
  secure: true,
});

// Set using Cookie instance
const cookie = new Bun.Cookie("visited", "true");
cookies.set(cookie);
```

#### `delete(name: string): void`

#### `delete(options: CookieStoreDeleteOptions): void`

Removes a cookie from the map. When applied to a Response, this adds a cookie with an empty string value and an expiry date in the past. A cookie will only delete successfully on the browser if the domain and path is the same as it was when the cookie was created.

```ts title="delete-cookie.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
// Delete by name using default domain and path.
cookies.delete("session");

// Delete with domain/path options.
cookies.delete({
  name: "session",
  domain: "example.com",
  path: "/admin",
});
```

#### `toJSON(): Record<string, string>`

Converts the cookie map to a serializable format.

```ts title="cookie-to-json.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
const json = cookies.toJSON();
```

#### `toSetCookieHeaders(): string[]`

Returns an array of values for Set-Cookie headers that can be used to apply all cookie changes.

When using `Bun.serve()`, you don't need to call this method explicitly. Any changes made to the `req.cookies` map are automatically applied to the response headers. This method is primarily useful when working with other HTTP server implementations.

```js title="node-server.js" icon="file-code" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { createServer } from "node:http";
import { CookieMap } from "bun";

const server = createServer((req, res) => {
  const cookieHeader = req.headers.cookie || "";
  const cookies = new CookieMap(cookieHeader);

  cookies.set("view-count", Number(cookies.get("view-count") || "0") + 1);
  cookies.delete("session");

  res.writeHead(200, {
    "Content-Type": "text/plain",
    "Set-Cookie": cookies.toSetCookieHeaders(),
  });
  res.end(`Found ${cookies.size} cookies`);
});

server.listen(3000, () => {
  console.log("Server running at http://localhost:3000/");
});
```

### Iteration

`CookieMap` provides several methods for iteration:

```ts title="iterate-cookies.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
// Iterate over [name, cookie] entries
for (const [name, value] of cookies) {
  console.log(`${name}: ${value}`);
}

// Using entries()
for (const [name, value] of cookies.entries()) {
  console.log(`${name}: ${value}`);
}

// Using keys()
for (const name of cookies.keys()) {
  console.log(name);
}

// Using values()
for (const value of cookies.values()) {
  console.log(value);
}

// Using forEach
cookies.forEach((value, name) => {
  console.log(`${name}: ${value}`);
});
```

### Properties

#### `size: number`

Returns the number of cookies in the map.

```ts title="cookie-size.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
console.log(cookies.size); // Number of cookies
```

## Cookie class

`Bun.Cookie` represents an HTTP cookie with its name, value, and attributes.

```ts title="cookie-class.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { Cookie } from "bun";

// Create a basic cookie
const cookie = new Bun.Cookie("name", "value");

// Create a cookie with options
const secureSessionCookie = new Bun.Cookie("session", "abc123", {
  domain: "example.com",
  path: "/admin",
  expires: new Date(Date.now() + 86400000), // 1 day
  httpOnly: true,
  secure: true,
  sameSite: "strict",
});

// Parse from a cookie string
const parsedCookie = new Bun.Cookie("name=value; Path=/; HttpOnly");

// Create from an options object
const objCookie = new Bun.Cookie({
  name: "theme",
  value: "dark",
  maxAge: 3600,
  secure: true,
});
```

### Constructors

```ts title="constructors.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
// Basic constructor with name/value
new Bun.Cookie(name: string, value: string);

// Constructor with name, value, and options
new Bun.Cookie(name: string, value: string, options: CookieInit);

// Constructor from cookie string
new Bun.Cookie(cookieString: string);

// Constructor from cookie object
new Bun.Cookie(options: CookieInit);
```

### Properties

```ts title="cookie-properties.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
cookie.name; // string - Cookie name
cookie.value; // string - Cookie value
cookie.domain; // string | null - Domain scope (null if not specified)
cookie.path; // string - URL path scope (defaults to "/")
cookie.expires; // number | undefined - Expiration timestamp (ms since epoch)
cookie.secure; // boolean - Require HTTPS
cookie.sameSite; // "strict" | "lax" | "none" - SameSite setting
cookie.partitioned; // boolean - Whether the cookie is partitioned (CHIPS)
cookie.maxAge; // number | undefined - Max age in seconds
cookie.httpOnly; // boolean - Accessible only via HTTP (not JavaScript)
```

### Methods

#### `isExpired(): boolean`

Checks if the cookie has expired.

```ts title="is-expired.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
// Expired cookie (Date in the past)
const expiredCookie = new Bun.Cookie("name", "value", {
  expires: new Date(Date.now() - 1000),
});
console.log(expiredCookie.isExpired()); // true

// Valid cookie (Using maxAge instead of expires)
const validCookie = new Bun.Cookie("name", "value", {
  maxAge: 3600, // 1 hour in seconds
});
console.log(validCookie.isExpired()); // false

// Session cookie (no expiration)
const sessionCookie = new Bun.Cookie("name", "value");
console.log(sessionCookie.isExpired()); // false
```

#### `serialize(): string`

#### `toString(): string`

Returns a string representation of the cookie suitable for a `Set-Cookie` header.

```ts title="serialize-cookie.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
const cookie = new Bun.Cookie("session", "abc123", {
  domain: "example.com",
  path: "/admin",
  expires: new Date(Date.now() + 86400000),
  secure: true,
  httpOnly: true,
  sameSite: "strict",
});

console.log(cookie.serialize());
// => "session=abc123; Domain=example.com; Path=/admin; Expires=Sun, 19 Mar 2025 15:03:26 GMT; Secure; HttpOnly; SameSite=strict"
console.log(cookie.toString());
// => "session=abc123; Domain=example.com; Path=/admin; Expires=Sun, 19 Mar 2025 15:03:26 GMT; Secure; HttpOnly; SameSite=strict"
```

#### `toJSON(): CookieInit`

Converts the cookie to a plain object suitable for JSON serialization.

```ts title="cookie-json.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
const cookie = new Bun.Cookie("session", "abc123", {
  secure: true,
  httpOnly: true,
});

const json = cookie.toJSON();
// => {
//   name: "session",
//   value: "abc123",
//   path: "/",
//   secure: true,
//   httpOnly: true,
//   sameSite: "lax",
//   partitioned: false
// }

// Works with JSON.stringify
const jsonString = JSON.stringify(cookie);
```

### Static methods

#### `Cookie.parse(cookieString: string): Cookie`

Parses a cookie string into a `Cookie` instance.

```ts title="parse-cookie.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
const cookie = Bun.Cookie.parse("name=value; Path=/; Secure; SameSite=Lax");

console.log(cookie.name); // "name"
console.log(cookie.value); // "value"
console.log(cookie.path); // "/"
console.log(cookie.secure); // true
console.log(cookie.sameSite); // "lax"
```

#### `Cookie.from(name: string, value: string, options?: CookieInit): Cookie`

Factory method to create a cookie.

```ts title="cookie-from.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
const cookie = Bun.Cookie.from("session", "abc123", {
  httpOnly: true,
  secure: true,
  maxAge: 3600,
});
```

## Types

```ts title="types.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
interface CookieInit {
  name?: string;
  value?: string;
  domain?: string;
  /** Defaults to '/'. To allow the browser to set the path, use an empty string. */
  path?: string;
  expires?: number | Date | string;
  secure?: boolean;
  /** Defaults to `lax`. */
  sameSite?: CookieSameSite;
  httpOnly?: boolean;
  partitioned?: boolean;
  maxAge?: number;
}

interface CookieStoreDeleteOptions {
  name: string;
  domain?: string | null;
  path?: string;
}

interface CookieStoreGetOptions {
  name?: string;
  url?: string;
}

type CookieSameSite = "strict" | "lax" | "none";

class Cookie {
  constructor(name: string, value: string, options?: CookieInit);
  constructor(cookieString: string);
  constructor(cookieObject?: CookieInit);

  readonly name: string;
  value: string;
  domain?: string;
  path: string;
  expires?: Date;
  secure: boolean;
  sameSite: CookieSameSite;
  partitioned: boolean;
  maxAge?: number;
  httpOnly: boolean;

  isExpired(): boolean;

  serialize(): string;
  toString(): string;
  toJSON(): CookieInit;

  static parse(cookieString: string): Cookie;
  static from(name: string, value: string, options?: CookieInit): Cookie;
}

class CookieMap implements Iterable<[string, string]> {
  constructor(init?: string[][] | Record<string, string> | string);

  get(name: string): string | null;

  toSetCookieHeaders(): string[];

  has(name: string): boolean;
  set(name: string, value: string, options?: CookieInit): void;
  set(options: CookieInit): void;
  delete(name: string): void;
  delete(options: CookieStoreDeleteOptions): void;
  delete(name: string, options: Omit<CookieStoreDeleteOptions, "name">): void;
  toJSON(): Record<string, string>;

  readonly size: number;

  entries(): IterableIterator<[string, string]>;
  keys(): IterableIterator<string>;
  values(): IterableIterator<string>;
  forEach(callback: (value: string, key: string, map: CookieMap) => void): void;
  [Symbol.iterator](): IterableIterator<[string, string]>;
}
```


# Debugging
Source: https://bun.com/docs/runtime/debugger

Debug your Bun code with an interactive debugger using WebKit Inspector Protocol

Bun speaks the [WebKit Inspector Protocol](https://github.com/oven-sh/bun/blob/main/packages/bun-inspector-protocol/src/protocol/jsc/index.d.ts), so you can debug your code with an interactive debugger. For demonstration purposes, consider the following simple web server.

## Debugging JavaScript and TypeScript

```typescript icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" title="server.ts" theme={"theme":{"light":"github-light","dark":"dracula"}}
Bun.serve({
  fetch(req) {
    console.log(req.url);
    return new Response("Hello, world!");
  },
});
```

### `--inspect`

To enable debugging when running code with Bun, use the `--inspect` flag. This automatically starts a WebSocket server on an available port that can be used to introspect the running Bun process.

```sh icon="terminal" title="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun --inspect server.ts
```

```txt id="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
------------------ Bun Inspector ------------------
Listening at:
  ws://localhost:6499/0tqxs9exrgrm

Inspect in browser:
  https://debug.bun.sh/#localhost:6499/0tqxs9exrgrm
------------------ Bun Inspector ------------------
```

### `--inspect-brk`

The `--inspect-brk` flag behaves identically to `--inspect`, except it automatically injects a breakpoint at the first line of the executed script. This is useful for debugging scripts that run quickly and exit immediately.

### `--inspect-wait`

The `--inspect-wait` flag behaves identically to `--inspect`, except the code will not execute until a debugger has attached to the running process.

### Setting a port or URL for the debugger

Regardless of which flag you use, you can optionally specify a port number, URL prefix, or both.

```sh icon="terminal" title="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun --inspect=4000 server.ts
bun --inspect=localhost:4000 server.ts
bun --inspect=localhost:4000/prefix server.ts
```

***

## Debuggers

Various debugging tools can connect to this server to provide an interactive debugging experience.

### `debug.bun.sh`

Bun hosts a web-based debugger at [debug.bun.sh](https://debug.bun.sh). It is a modified version of WebKit's [Web Inspector Interface](https://webkit.org/web-inspector/web-inspector-interface/), which will look familiar to Safari users.

Open the provided `debug.bun.sh` URL in your browser to start a debugging session. From this interface, you'll be able to view the source code of the running file, view and set breakpoints, and execute code with the built-in console.

<Frame>
  ![Screenshot of Bun debugger, Console
  tab](https://github.com/oven-sh/bun/assets/3084745/e6a976a8-80cc-4394-8925-539025cc025d)
</Frame>

Let's set a breakpoint. Navigate to the Sources tab; you should see the code from earlier. Click on the line number `3` to set a breakpoint on our `console.log(req.url)` statement.

<Frame>
  ![screenshot of Bun debugger](https://github.com/oven-sh/bun/assets/3084745/3b69c7e9-25ff-4f9d-acc4-caa736862935)
</Frame>

Then visit [`http://localhost:3000`](http://localhost:3000) in your web browser. This will send an HTTP request to our `localhost` web server. It will seem like the page isn't loading. Why? Because the program has paused execution at the breakpoint we set earlier.

Note how the UI has changed.

<Frame>
  ![screenshot of Bun debugger](https://github.com/oven-sh/bun/assets/3084745/8b565e58-5445-4061-9bc4-f41090dfe769)
</Frame>

At this point there's a lot we can do to introspect the current execution environment. We can use the console at the bottom to run arbitrary code in the context of the program, with full access to the variables in scope at our breakpoint.

<Frame>
  ![Bun debugger console](https://github.com/oven-sh/bun/assets/3084745/f4312b76-48ba-4a7d-b3b6-6205968ac681)
</Frame>

On the right side of the Sources pane, we can see all local variables currently in scope, and drill down to see their properties and methods. Here, we're inspecting the `req` variable.

<Frame>
  ![Bun debugger variables](https://github.com/oven-sh/bun/assets/3084745/63d7f843-5180-489c-aa94-87c486e68646)
</Frame>

In the upper left of the Sources pane, we can control the execution of the program.

<Frame>
  ![Bun debugger controls](https://github.com/oven-sh/bun/assets/3084745/41b76deb-7371-4461-9d5d-81b5a6d2f7a4)
</Frame>

Here's a cheat sheet explaining the functions of the control flow buttons.

* *Continue script execution* — continue running the program until the next breakpoint or exception.
* *Step over* — The program will continue to the next line.
* *Step into* — If the current statement contains a function call, the debugger will "step into" the called function.
* *Step out* — If the current statement is a function call, the debugger will finish executing the call, then "step out" of the function to the location where it was called.

<Frame>
  ![Bun debugger execution
  controls](https://github-production-user-asset-6210df.s3.amazonaws.com/3084745/261510346-6a94441c-75d3-413a-99a7-efa62365f83d.png)
</Frame>

### Visual Studio Code Debugger

Experimental support for debugging Bun scripts is available in Visual Studio Code. To use it, you'll need to install the [Bun VSCode extension](/guides/runtime/vscode-debugger).

***

## Debugging Network Requests

The `BUN_CONFIG_VERBOSE_FETCH` environment variable lets you log network requests made with `fetch()` or `node:http` automatically.

| Value   | Description                        |
| ------- | ---------------------------------- |
| `curl`  | Print requests as `curl` commands. |
| `true`  | Print request & response info      |
| `false` | Don't print anything. Default      |

### Print fetch & node:http requests as curl commands

Bun also supports printing `fetch()` and `node:http` network requests as `curl` commands by setting the environment variable `BUN_CONFIG_VERBOSE_FETCH` to `curl`. This prints the `fetch` request as a single-line `curl` command to let you copy-paste into your terminal to replicate the request.

```ts index.ts icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
process.env.BUN_CONFIG_VERBOSE_FETCH = "curl";

await fetch("https://example.com", {
  method: "POST",
  headers: {
    "Content-Type": "application/json",
  },
  body: JSON.stringify({ foo: "bar" }),
});
```

```txt theme={"theme":{"light":"github-light","dark":"dracula"}}
[fetch] $ curl --http1.1 "https://example.com/" -X POST -H "content-type: application/json" -H "Connection: keep-alive" -H "User-Agent: Bun/1.3.3" -H "Accept: */*" -H "Host: example.com" -H "Accept-Encoding: gzip, deflate, br" --compressed -H "Content-Length: 13" --data-raw "{\"foo\":\"bar\"}"
[fetch] > HTTP/1.1 POST https://example.com/
[fetch] > content-type: application/json
[fetch] > Connection: keep-alive
[fetch] > User-Agent: Bun/1.3.3
[fetch] > Accept: */*
[fetch] > Host: example.com
[fetch] > Accept-Encoding: gzip, deflate, br
[fetch] > Content-Length: 13

[fetch] < 200 OK
[fetch] < Accept-Ranges: bytes
[fetch] < Cache-Control: max-age=604800
[fetch] < Content-Type: text/html; charset=UTF-8
[fetch] < Date: Tue, 18 Jun 2024 05:12:07 GMT
[fetch] < Etag: "3147526947"
[fetch] < Expires: Tue, 25 Jun 2024 05:12:07 GMT
[fetch] < Last-Modified: Thu, 17 Oct 2019 07:18:26 GMT
[fetch] < Server: EOS (vny/044F)
[fetch] < Content-Length: 1256
```

The lines with `[fetch] >` are the request from your local code, and the lines with `[fetch] <` are the response from the remote server.

The `BUN_CONFIG_VERBOSE_FETCH` environment variable is supported in both `fetch()` and `node:http` requests, so it should just work.

To print without the `curl` command, set `BUN_CONFIG_VERBOSE_FETCH` to `true`.

```ts index.ts icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
process.env.BUN_CONFIG_VERBOSE_FETCH = "true";

await fetch("https://example.com", {
  method: "POST",
  headers: {
    "Content-Type": "application/json",
  },
  body: JSON.stringify({ foo: "bar" }),
});
```

```txt theme={"theme":{"light":"github-light","dark":"dracula"}}
[fetch] > HTTP/1.1 POST https://example.com/
[fetch] > content-type: application/json
[fetch] > Connection: keep-alive
[fetch] > User-Agent: Bun/1.3.3
[fetch] > Accept: */*
[fetch] > Host: example.com
[fetch] > Accept-Encoding: gzip, deflate, br
[fetch] > Content-Length: 13

[fetch] < 200 OK
[fetch] < Accept-Ranges: bytes
[fetch] < Cache-Control: max-age=604800
[fetch] < Content-Type: text/html; charset=UTF-8
[fetch] < Date: Tue, 18 Jun 2024 05:12:07 GMT
[fetch] < Etag: "3147526947"
[fetch] < Expires: Tue, 25 Jun 2024 05:12:07 GMT
[fetch] < Last-Modified: Thu, 17 Oct 2019 07:18:26 GMT
[fetch] < Server: EOS (vny/044F)
[fetch] < Content-Length: 1256
```

***

## Stacktraces & sourcemaps

Bun transpiles every file, which sounds like it would mean that the stack traces you see in the console would unhelpfully point to the transpiled output. To address this, Bun automatically generates and serves sourcemapped files for every file it transpiles. When you see a stack trace in the console, you can click on the file path and be taken to the original source code, even though it was written in TypeScript or JSX, or has some other transformation applied.

Bun automatically loads sourcemaps both at runtime when transpiling files on-demand, and when using `bun build` to precompile files ahead of time.

### Syntax-highlighted source code preview

To help with debugging, Bun automatically prints a small source-code preview when an unhandled exception or rejection occurs. You can simulate this behavior by calling `Bun.inspect(error)`:

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
// Create an error
const err = new Error("Something went wrong");
console.log(Bun.inspect(err, { colors: true }));
```

This prints a syntax-highlighted preview of the source code where the error occurred, along with the error message and stack trace.

```ts icon="file-code" theme={"theme":{"light":"github-light","dark":"dracula"}}
1 | // Create an error
2 | const err = new Error("Something went wrong");
                ^
error: Something went wrong
      at file.js:2:13
```

### V8 Stack Traces

Bun uses JavaScriptCore as it's engine, but much of the Node.js ecosystem & npm expects V8. JavaScript engines differ in `error.stack` formatting. Bun intends to be a drop-in replacement for Node.js, and that means it's our job to make sure that even though the engine is different, the stack traces are as similar as possible.

That's why when you log `error.stack` in Bun, the formatting of `error.stack` is the same as in Node.js's V8 engine. This is especially useful when you're using libraries that expect V8 stack traces.

#### V8 Stack Trace API

Bun implements the [V8 Stack Trace API](https://v8.dev/docs/stack-trace-api), which is a set of functions that allow you to manipulate stack traces.

##### `Error.prepareStackTrace`

The `Error.prepareStackTrace` function is a global function that lets you customize the stack trace output. This function is called with the error object and an array of `CallSite` objects and lets you return a custom stack trace.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
Error.prepareStackTrace = (err, stack) => {
  return stack.map(callSite => {
    return callSite.getFileName();
  });
};

const err = new Error("Something went wrong");
console.log(err.stack);
// [ "error.js" ]
```

The `CallSite` object has the following methods:

| Method                     | Returns                                               |
| -------------------------- | ----------------------------------------------------- |
| `getThis`                  | `this` value of the function call                     |
| `getTypeName`              | typeof `this`                                         |
| `getFunction`              | function object                                       |
| `getFunctionName`          | function name as a string                             |
| `getMethodName`            | method name as a string                               |
| `getFileName`              | file name or URL                                      |
| `getLineNumber`            | line number                                           |
| `getColumnNumber`          | column number                                         |
| `getEvalOrigin`            | `undefined`                                           |
| `getScriptNameOrSourceURL` | source URL                                            |
| `isToplevel`               | returns `true` if the function is in the global scope |
| `isEval`                   | returns `true` if the function is an `eval` call      |
| `isNative`                 | returns `true` if the function is native              |
| `isConstructor`            | returns `true` if the function is a constructor       |
| `isAsync`                  | returns `true` if the function is `async`             |
| `isPromiseAll`             | Not implemented yet.                                  |
| `getPromiseIndex`          | Not implemented yet.                                  |
| `toString`                 | returns a string representation of the call site      |

In some cases, the `Function` object may have already been garbage collected, so some of these methods may return `undefined`.

##### `Error.captureStackTrace(error, startFn)`

The `Error.captureStackTrace` function lets you capture a stack trace at a specific point in your code, rather than at the point where the error was thrown.

This can be helpful when you have callbacks or asynchronous code that makes it difficult to determine where an error originated. The 2nd argument to `Error.captureStackTrace` is the function where you want the stack trace to start.

For example, the below code will make `err.stack` point to the code calling `fn()`, even though the error was thrown at `myInner`.

```ts index.ts icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
const fn = () => {
  function myInner() {
    throw err;
  }

  try {
    myInner();
  } catch (err) {
    console.log(err.stack);
    console.log("");
    console.log("-- captureStackTrace --");
    console.log("");
    Error.captureStackTrace(err, fn);
    console.log(err.stack);
  }
};

fn();
```

```txt theme={"theme":{"light":"github-light","dark":"dracula"}}
Error: here!
    at myInner (file.js:4:15)
    at fn (file.js:8:5)
    at module code (file.js:17:1)
    at moduleEvaluation (native)
    at moduleEvaluation (native)
    at <anonymous> (native)

-- captureStackTrace --

Error: here!
    at module code (file.js:17:1)
    at moduleEvaluation (native)
    at moduleEvaluation (native)
    at <anonymous> (native)
```


# Environment Variables
Source: https://bun.com/docs/runtime/environment-variables

Read and configure environment variables in Bun, including automatic .env file support

Bun reads your `.env` files automatically and provides idiomatic ways to read and write your environment variables programmatically. Plus, some aspects of Bun's runtime behavior can be configured with Bun-specific environment variables.

## Setting environment variables

Bun reads the following files automatically (listed in order of increasing precedence).

* `.env`
* `.env.production`, `.env.development`, `.env.test` (depending on value of `NODE_ENV`)
* `.env.local`

```ini .env icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
FOO=hello
BAR=world
```

Variables can also be set via the command line.

<CodeGroup>
  ```sh Linux/macOS icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
  FOO=helloworld bun run dev
  ```

  ```sh Windows icon="windows" theme={"theme":{"light":"github-light","dark":"dracula"}}
  # Using CMD
  set FOO=helloworld && bun run dev

  # Using PowerShell
  $env:FOO="helloworld"; bun run dev
  ```
</CodeGroup>

<Accordion title="Cross-platform solution with Windows">
  For a cross-platform solution, you can use [bun shell](/runtime/shell). For example, the `bun exec` command.

  ```sh theme={"theme":{"light":"github-light","dark":"dracula"}}
  bun exec 'FOO=helloworld bun run dev'
  ```

  On Windows, `package.json` scripts called with `bun run` will automatically use the **bun shell**, making the following also cross-platform.

  ```json package.json icon="file-json" theme={"theme":{"light":"github-light","dark":"dracula"}}
  "scripts": {
    "dev": "NODE_ENV=development bun --watch app.ts",
  },
  ```
</Accordion>

Or programmatically by assigning a property to `process.env`.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
process.env.FOO = "hello";
```

***

## Manually specifying `.env` files

Bun supports `--env-file` to override which specific `.env` file to load. You can use `--env-file` when running scripts in bun's runtime, or when running package.json scripts.

```sh theme={"theme":{"light":"github-light","dark":"dracula"}}
bun --env-file=.env.1 src/index.ts

bun --env-file=.env.abc --env-file=.env.def run build
```

## Disabling automatic `.env` loading

Use `--no-env-file` to disable Bun's automatic `.env` file loading. This is useful in production environments or CI/CD pipelines where you want to rely solely on system environment variables.

```sh theme={"theme":{"light":"github-light","dark":"dracula"}}
bun run --no-env-file index.ts
```

This can also be configured in `bunfig.toml`:

```toml bunfig.toml icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
# Disable loading .env files
env = false
```

Explicitly provided environment files via `--env-file` will still be loaded even when default loading is disabled.

***

## Quotation marks

Bun supports double quotes, single quotes, and template literal backticks:

```ini .env icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
FOO='hello'
FOO="hello"
FOO=`hello`
```

### Expansion

Environment variables are automatically *expanded*. This means you can reference previously-defined variables in your environment variables.

```ini .env icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
FOO=world
BAR=hello$FOO
```

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
process.env.BAR; // => "helloworld"
```

This is useful for constructing connection strings or other compound values.

```ini .env icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
DB_USER=postgres
DB_PASSWORD=secret
DB_HOST=localhost
DB_PORT=5432
DB_URL=postgres://$DB_USER:$DB_PASSWORD@$DB_HOST:$DB_PORT/$DB_NAME
```

This can be disabled by escaping the `$` with a backslash.

```ini .env icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
FOO=world
BAR=hello\$FOO
```

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
process.env.BAR; // => "hello$FOO"
```

### `dotenv`

Generally speaking, you won't need `dotenv` or `dotenv-expand` anymore, because Bun reads `.env` files automatically.

## Reading environment variables

The current environment variables can be accessed via `process.env`.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
process.env.API_TOKEN; // => "secret"
```

Bun also exposes these variables via `Bun.env` and `import.meta.env`, which is a simple alias of `process.env`.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
Bun.env.API_TOKEN; // => "secret"
import.meta.env.API_TOKEN; // => "secret"
```

To print all currently-set environment variables to the command line, run `bun --print process.env`. This is useful for debugging.

```sh theme={"theme":{"light":"github-light","dark":"dracula"}}
bun --print process.env
BAZ=stuff
FOOBAR=aaaaaa
<lots more lines>
```

## TypeScript

In TypeScript, all properties of `process.env` are typed as `string | undefined`.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
Bun.env.whatever;
// string | undefined
```

To get autocompletion and tell TypeScript to treat a variable as a non-optional string, we'll use [interface merging](https://www.typescriptlang.org/docs/handbook/declaration-merging.html#merging-interfaces).

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
declare module "bun" {
  interface Env {
    AWESOME: string;
  }
}
```

Add this line to any file in your project. It will globally add the `AWESOME` property to `process.env` and `Bun.env`.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
process.env.AWESOME; // => string
```

## Configuring Bun

These environment variables are read by Bun and configure aspects of its behavior.

| Name                                     | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| ---------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `NODE_TLS_REJECT_UNAUTHORIZED`           | `NODE_TLS_REJECT_UNAUTHORIZED=0` disables SSL certificate validation. This is useful for testing and debugging, but you should be very hesitant to use this in production. Note: This environment variable was originally introduced by Node.js and we kept the name for compatibility.                                                                                                                                                                                                                                                                                   |
| `BUN_CONFIG_VERBOSE_FETCH`               | If `BUN_CONFIG_VERBOSE_FETCH=curl`, then fetch requests will log the url, method, request headers and response headers to the console. This is useful for debugging network requests. This also works with `node:http`. `BUN_CONFIG_VERBOSE_FETCH=1` is equivalent to `BUN_CONFIG_VERBOSE_FETCH=curl` except without the `curl` output.                                                                                                                                                                                                                                   |
| `BUN_RUNTIME_TRANSPILER_CACHE_PATH`      | The runtime transpiler caches the transpiled output of source files larger than 50 kb. This makes CLIs using Bun load faster. If `BUN_RUNTIME_TRANSPILER_CACHE_PATH` is set, then the runtime transpiler will cache transpiled output to the specified directory. If `BUN_RUNTIME_TRANSPILER_CACHE_PATH` is set to an empty string or the string `"0"`, then the runtime transpiler will not cache transpiled output. If `BUN_RUNTIME_TRANSPILER_CACHE_PATH` is unset, then the runtime transpiler will cache transpiled output to the platform-specific cache directory. |
| `TMPDIR`                                 | Bun occasionally requires a directory to store intermediate assets during bundling or other operations. If unset, defaults to the platform-specific temporary directory: `/tmp` on Linux, `/private/tmp` on macOS.                                                                                                                                                                                                                                                                                                                                                        |
| `NO_COLOR`                               | If `NO_COLOR=1`, then ANSI color output is [disabled](https://no-color.org/).                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| `FORCE_COLOR`                            | If `FORCE_COLOR=1`, then ANSI color output is force enabled, even if `NO_COLOR` is set.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| `BUN_CONFIG_MAX_HTTP_REQUESTS`           | Control the maximum number of concurrent HTTP requests sent by fetch and `bun install`. Defaults to `256`. If you are running into rate limits or connection issues, you can reduce this number.                                                                                                                                                                                                                                                                                                                                                                          |
| `BUN_CONFIG_NO_CLEAR_TERMINAL_ON_RELOAD` | If `BUN_CONFIG_NO_CLEAR_TERMINAL_ON_RELOAD=true`, then `bun --watch` will not clear the console on reload                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| `DO_NOT_TRACK`                           | Disable uploading crash reports to `bun.report` on crash. On macOS & Windows, crash report uploads are enabled by default. Otherwise, telemetry is not sent yet as of May 21st, 2024, but we are planning to add telemetry in the coming weeks. If `DO_NOT_TRACK=1`, then auto-uploading crash reports and telemetry are both [disabled](https://do-not-track.dev/).                                                                                                                                                                                                      |
| `BUN_OPTIONS`                            | Prepends command-line arguments to any Bun execution. For example, `BUN_OPTIONS="--hot"` makes `bun run dev` behave like `bun --hot run dev`                                                                                                                                                                                                                                                                                                                                                                                                                              |

## Runtime transpiler caching

For files larger than 50 KB, Bun caches transpiled output into `$BUN_RUNTIME_TRANSPILER_CACHE_PATH` or the platform-specific cache directory. This makes CLIs using Bun load faster.

This transpiler cache is global and shared across all projects. It is safe to delete the cache at any time. It is a content-addressable cache, so it will never contain duplicate entries. It is also safe to delete the cache while a Bun process is running.

It is recommended to disable this cache when using ephemeral filesystems like Docker. Bun's Docker images automatically disable this cache.

### Disable the runtime transpiler cache

To disable the runtime transpiler cache, set `BUN_RUNTIME_TRANSPILER_CACHE_PATH` to an empty string or the string `"0"`.

```sh theme={"theme":{"light":"github-light","dark":"dracula"}}
BUN_RUNTIME_TRANSPILER_CACHE_PATH=0 bun run dev
```

### What does it cache?

It caches:

* The transpiled output of source files larger than 50 KB.
* The sourcemap for the transpiled output of the file

The file extension `.pile` is used for these cached files.


# FFI
Source: https://bun.com/docs/runtime/ffi

Use Bun's FFI module to efficiently call native libraries from JavaScript

<Warning>
  `bun:ffi` is **experimental**, with known bugs and limitations, and should not be relied on in production. The most
  stable way to interact with native code from Bun is to write a [Node-API module](/runtime/node-api).
</Warning>

Use the built-in `bun:ffi` module to efficiently call native libraries from JavaScript. It works with languages that support the C ABI (Zig, Rust, C/C++, C#, Nim, Kotlin, etc).

***

## dlopen usage (`bun:ffi`)

To print the version number of `sqlite3`:

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
import { dlopen, FFIType, suffix } from "bun:ffi";

// `suffix` is either "dylib", "so", or "dll" depending on the platform
// you don't have to use "suffix", it's just there for convenience
const path = `libsqlite3.${suffix}`;

const {
  symbols: {
    sqlite3_libversion, // the function to call
  },
} = dlopen(
  path, // a library name or file path
  {
    sqlite3_libversion: {
      // no arguments, returns a string
      args: [],
      returns: FFIType.cstring,
    },
  },
);

console.log(`SQLite 3 version: ${sqlite3_libversion()}`);
```

***

## Performance

According to [our benchmark](https://github.com/oven-sh/bun/tree/main/bench/ffi), `bun:ffi` is roughly 2-6x faster than Node.js FFI via `Node-API`.

<Image />

Bun generates & just-in-time compiles C bindings that efficiently convert values between JavaScript types and native types. To compile C, Bun embeds [TinyCC](https://github.com/TinyCC/tinycc), a small and fast C compiler.

***

## Usage

### Zig

```zig add.zig icon="file-code" theme={"theme":{"light":"github-light","dark":"dracula"}}
pub export fn add(a: i32, b: i32) i32 {
  return a + b;
}
```

To compile:

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
zig build-lib add.zig -dynamic -OReleaseFast
```

Pass a path to the shared library and a map of symbols to import into `dlopen`:

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
import { dlopen, FFIType, suffix } from "bun:ffi";
const { i32 } = FFIType;

const path = `libadd.${suffix}`;

const lib = dlopen(path, {
  add: {
    args: [i32, i32],
    returns: i32,
  },
});

console.log(lib.symbols.add(1, 2));
```

### Rust

```rust theme={"theme":{"light":"github-light","dark":"dracula"}}
// add.rs
#[no_mangle]
pub extern "C" fn add(a: i32, b: i32) -> i32 {
    a + b
}
```

To compile:

```bash theme={"theme":{"light":"github-light","dark":"dracula"}}
rustc --crate-type cdylib add.rs
```

### C++

```c theme={"theme":{"light":"github-light","dark":"dracula"}}
#include <cstdint>

extern "C" int32_t add(int32_t a, int32_t b) {
    return a + b;
}
```

To compile:

```bash theme={"theme":{"light":"github-light","dark":"dracula"}}
zig build-lib add.cpp -dynamic -lc -lc++
```

***

## FFI types

The following `FFIType` values are supported.

| `FFIType`   | C Type         | Aliases                     |
| ----------- | -------------- | --------------------------- |
| buffer      | `char*`        |                             |
| cstring     | `char*`        |                             |
| function    | `(void*)(*)()` | `fn`, `callback`            |
| ptr         | `void*`        | `pointer`, `void*`, `char*` |
| i8          | `int8_t`       | `int8_t`                    |
| i16         | `int16_t`      | `int16_t`                   |
| i32         | `int32_t`      | `int32_t`, `int`            |
| i64         | `int64_t`      | `int64_t`                   |
| i64\_fast   | `int64_t`      |                             |
| u8          | `uint8_t`      | `uint8_t`                   |
| u16         | `uint16_t`     | `uint16_t`                  |
| u32         | `uint32_t`     | `uint32_t`                  |
| u64         | `uint64_t`     | `uint64_t`                  |
| u64\_fast   | `uint64_t`     |                             |
| f32         | `float`        | `float`                     |
| f64         | `double`       | `double`                    |
| bool        | `bool`         |                             |
| char        | `char`         |                             |
| napi\_env   | `napi_env`     |                             |
| napi\_value | `napi_value`   |                             |

Note: `buffer` arguments must be a `TypedArray` or `DataView`.

***

## Strings

JavaScript strings and C-like strings are different, and that complicates using strings with native libraries.

<Accordion title="How are JavaScript strings and C strings different?">
  JavaScript strings:

  * UTF16 (2 bytes per letter) or potentially latin1, depending on the JavaScript engine & what characters are used
  * `length` stored separately
  * Immutable

  C strings:

  * UTF8 (1 byte per letter), usually
  * The length is not stored. Instead, the string is null-terminated which means the length is the index of the first `\0` it finds
  * Mutable
</Accordion>

To solve this, `bun:ffi` exports `CString` which extends JavaScript's built-in `String` to support null-terminated strings and add a few extras:

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
class CString extends String {
  /**
   * Given a `ptr`, this will automatically search for the closing `\0` character and transcode from UTF-8 to UTF-16 if necessary.
   */
  constructor(ptr: number, byteOffset?: number, byteLength?: number): string;

  /**
   * The ptr to the C string
   *
   * This `CString` instance is a clone of the string, so it
   * is safe to continue using this instance after the `ptr` has been
   * freed.
   */
  ptr: number;
  byteOffset?: number;
  byteLength?: number;
}
```

To convert from a null-terminated string pointer to a JavaScript string:

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
const myString = new CString(ptr);
```

To convert from a pointer with a known length to a JavaScript string:

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
const myString = new CString(ptr, 0, byteLength);
```

The `new CString()` constructor clones the C string, so it is safe to continue using `myString` after `ptr` has been freed.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
my_library_free(myString.ptr);

// this is safe because myString is a clone
console.log(myString);
```

When used in `returns`, `FFIType.cstring` coerces the pointer to a JavaScript `string`. When used in `args`, `FFIType.cstring` is identical to `ptr`.

***

## Function pointers

<Note>Async functions are not yet supported</Note>

To call a function pointer from JavaScript, use `CFunction`. This is useful if using Node-API (napi) with Bun, and you've already loaded some symbols.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
import { CFunction } from "bun:ffi";

let myNativeLibraryGetVersion = /* somehow, you got this pointer */

const getVersion = new CFunction({
  returns: "cstring",
  args: [],
  ptr: myNativeLibraryGetVersion,
});
getVersion();
```

If you have multiple function pointers, you can define them all at once with `linkSymbols`:

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
import { linkSymbols } from "bun:ffi";

// getVersionPtrs defined elsewhere
const [majorPtr, minorPtr, patchPtr] = getVersionPtrs();

const lib = linkSymbols({
  // Unlike with dlopen(), the names here can be whatever you want
  getMajor: {
    returns: "cstring",
    args: [],

    // Since this doesn't use dlsym(), you have to provide a valid ptr
    // That ptr could be a number or a bigint
    // An invalid pointer will crash your program.
    ptr: majorPtr,
  },
  getMinor: {
    returns: "cstring",
    args: [],
    ptr: minorPtr,
  },
  getPatch: {
    returns: "cstring",
    args: [],
    ptr: patchPtr,
  },
});

const [major, minor, patch] = [lib.symbols.getMajor(), lib.symbols.getMinor(), lib.symbols.getPatch()];
```

***

## Callbacks

Use `JSCallback` to create JavaScript callback functions that can be passed to C/FFI functions. The C/FFI function can call into the JavaScript/TypeScript code. This is useful for asynchronous code or whenever you want to call into JavaScript code from C.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
import { dlopen, JSCallback, ptr, CString } from "bun:ffi";

const {
  symbols: { search },
  close,
} = dlopen("libmylib", {
  search: {
    returns: "usize",
    args: ["cstring", "callback"],
  },
});

const searchIterator = new JSCallback((ptr, length) => /hello/.test(new CString(ptr, length)), {
  returns: "bool",
  args: ["ptr", "usize"],
});

const str = Buffer.from("wwutwutwutwutwutwutwutwutwutwutut\0", "utf8");
if (search(ptr(str), searchIterator)) {
  // found a match!
}

// Sometime later:
setTimeout(() => {
  searchIterator.close();
  close();
}, 5000);
```

When you're done with a JSCallback, you should call `close()` to free the memory.

### Experimental thread-safe callbacks

`JSCallback` has experimental support for thread-safe callbacks. This will be needed if you pass a callback function into a different thread from its instantiation context. You can enable it with the optional `threadsafe` parameter.

Currently, thread-safe callbacks work best when run from another thread that is running JavaScript code, i.e. a [`Worker`](/runtime/workers). A future version of Bun will enable them to be called from any thread (such as new threads spawned by your native library that Bun is not aware of).

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
const searchIterator = new JSCallback((ptr, length) => /hello/.test(new CString(ptr, length)), {
  returns: "bool",
  args: ["ptr", "usize"],
  threadsafe: true, // Optional. Defaults to `false`
});
```

<Note>
  **⚡️ Performance tip** — For a slight performance boost, directly pass `JSCallback.prototype.ptr` instead of the `JSCallback` object:

  ```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
  const onResolve = new JSCallback(arg => arg === 42, {
    returns: "bool",
    args: ["i32"],
  });
  const setOnResolve = new CFunction({
    returns: "bool",
    args: ["function"],
    ptr: myNativeLibrarySetOnResolve,
  });

  // This code runs slightly faster:
  setOnResolve(onResolve.ptr);

  // Compared to this:
  setOnResolve(onResolve);
  ```
</Note>

***

## Pointers

Bun represents [pointers](https://en.wikipedia.org/wiki/Pointer_\(computer_programming\)) as a `number` in JavaScript.

<Accordion title="How does a 64 bit pointer fit in a JavaScript number?">
  64-bit processors support up to [52 bits of addressable space](https://en.wikipedia.org/wiki/64-bit_computing#Limits_of_processors). [JavaScript numbers](https://en.wikipedia.org/wiki/Double-precision_floating-point_format#IEEE_754_double-precision_binary_floating-point_format:_binary64) support 53 bits of usable space, so that leaves us with about 11 bits of extra space.

  **Why not `BigInt`?** `BigInt` is slower. JavaScript engines allocate a separate `BigInt` which means they can't fit into a regular JavaScript value. If you pass a `BigInt` to a function, it will be converted to a `number`

  **Windows Note**: The Windows API type HANDLE does not represent a virtual address, and using `ptr` for it will *not* work as expected. Use `u64` to safely represent HANDLE values.
</Accordion>

To convert from a `TypedArray` to a pointer:

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
import { ptr } from "bun:ffi";
let myTypedArray = new Uint8Array(32);
const myPtr = ptr(myTypedArray);
```

To convert from a pointer to an `ArrayBuffer`:

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
import { ptr, toArrayBuffer } from "bun:ffi";
let myTypedArray = new Uint8Array(32);
const myPtr = ptr(myTypedArray);

// toArrayBuffer accepts a `byteOffset` and `byteLength`
// if `byteLength` is not provided, it is assumed to be a null-terminated pointer
myTypedArray = new Uint8Array(toArrayBuffer(myPtr, 0, 32), 0, 32);
```

To read data from a pointer, you have two options. For long-lived pointers, use a `DataView`:

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
import { toArrayBuffer } from "bun:ffi";
let myDataView = new DataView(toArrayBuffer(myPtr, 0, 32));

console.log(
  myDataView.getUint8(0, true),
  myDataView.getUint8(1, true),
  myDataView.getUint8(2, true),
  myDataView.getUint8(3, true),
);
```

For short-lived pointers, use `read`:

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
import { read } from "bun:ffi";

console.log(
  // ptr, byteOffset
  read.u8(myPtr, 0),
  read.u8(myPtr, 1),
  read.u8(myPtr, 2),
  read.u8(myPtr, 3),
);
```

The `read` function behaves similarly to `DataView`, but it's usually faster because it doesn't need to create a `DataView` or `ArrayBuffer`.

| `FFIType` | `read` function |
| --------- | --------------- |
| ptr       | `read.ptr`      |
| i8        | `read.i8`       |
| i16       | `read.i16`      |
| i32       | `read.i32`      |
| i64       | `read.i64`      |
| u8        | `read.u8`       |
| u16       | `read.u16`      |
| u32       | `read.u32`      |
| u64       | `read.u64`      |
| f32       | `read.f32`      |
| f64       | `read.f64`      |

### Memory management

`bun:ffi` does not manage memory for you. You must free the memory when you're done with it.

#### From JavaScript

If you want to track when a `TypedArray` is no longer in use from JavaScript, you can use a [FinalizationRegistry](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/FinalizationRegistry).

#### From C, Rust, Zig, etc

If you want to track when a `TypedArray` is no longer in use from C or FFI, you can pass a callback and an optional context pointer to `toArrayBuffer` or `toBuffer`. This function is called at some point later, once the garbage collector frees the underlying `ArrayBuffer` JavaScript object.

The expected signature is the same as in [JavaScriptCore's C API](https://developer.apple.com/documentation/javascriptcore/jstypedarraybytesdeallocator?language=objc):

```c theme={"theme":{"light":"github-light","dark":"dracula"}}
typedef void (*JSTypedArrayBytesDeallocator)(void *bytes, void *deallocatorContext);
```

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
import { toArrayBuffer } from "bun:ffi";

// with a deallocatorContext:
toArrayBuffer(
  bytes,
  byteOffset,

  byteLength,

  // this is an optional pointer to a callback
  deallocatorContext,

  // this is a pointer to a function
  jsTypedArrayBytesDeallocator,
);

// without a deallocatorContext:
toArrayBuffer(
  bytes,
  byteOffset,

  byteLength,

  // this is a pointer to a function
  jsTypedArrayBytesDeallocator,
);
```

### Memory safety

Using raw pointers outside of FFI is extremely not recommended. A future version of Bun may add a CLI flag to disable `bun:ffi`.

### Pointer alignment

If an API expects a pointer sized to something other than `char` or `u8`, make sure the `TypedArray` is also that size. A `u64*` is not exactly the same as `[8]u8*` due to alignment.

### Passing a pointer

Where FFI functions expect a pointer, pass a `TypedArray` of equivalent size:

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
import { dlopen, FFIType } from "bun:ffi";

const {
  symbols: { encode_png },
} = dlopen(myLibraryPath, {
  encode_png: {
    // FFIType's can be specified as strings too
    args: ["ptr", "u32", "u32"],
    returns: FFIType.ptr,
  },
});

const pixels = new Uint8ClampedArray(128 * 128 * 4);
pixels.fill(254);
pixels.subarray(0, 32 * 32 * 2).fill(0);

const out = encode_png(
  // pixels will be passed as a pointer
  pixels,

  128,
  128,
);
```

The [auto-generated wrapper](https://github.com/oven-sh/bun/blob/6a65631cbdcae75bfa1e64323a6ad613a922cd1a/src/bun.js/ffi.exports.js#L180-L182) converts the pointer to a `TypedArray`.

<Accordion title="Hardmode">
  If you don't want the automatic conversion or you want a pointer to a specific byte offset within the `TypedArray`, you can also directly get the pointer to the `TypedArray`:

  ```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
  import { dlopen, FFIType, ptr } from "bun:ffi";

  const {
    symbols: { encode_png },
  } = dlopen(myLibraryPath, {
    encode_png: {
      // FFIType's can be specified as strings too
      args: ["ptr", "u32", "u32"],
      returns: FFIType.ptr,
    },
  });

  const pixels = new Uint8ClampedArray(128 * 128 * 4);
  pixels.fill(254);

  // this returns a number! not a BigInt!
  const myPtr = ptr(pixels);

  const out = encode_png(
    myPtr,

    // dimensions:
    128,
    128,
  );
  ```
</Accordion>

### Reading pointers

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
const out = encode_png(
  // pixels will be passed as a pointer
  pixels,

  // dimensions:
  128,
  128,
);

// assuming it is 0-terminated, it can be read like this:
let png = new Uint8Array(toArrayBuffer(out));

// save it to disk:
await Bun.write("out.png", png);
```


# File I/O
Source: https://bun.com/docs/runtime/file-io

Bun provides a set of optimized APIs for reading and writing files.

<Note>
  The `Bun.file` and `Bun.write` APIs documented on this page are heavily optimized and represent the recommended way to perform file-system tasks using Bun. For operations that are not yet available with `Bun.file`, such as `mkdir` or `readdir`, you can use Bun's [nearly complete](/runtime/nodejs-compat#node-fs) implementation of the [`node:fs`](https://nodejs.org/api/fs.html) module.
</Note>

***

## Reading files (`Bun.file()`)

`Bun.file(path): BunFile`

Create a `BunFile` instance with the `Bun.file(path)` function. A `BunFile` represents a lazily-loaded file; initializing it does not actually read the file from disk.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
const foo = Bun.file("foo.txt"); // relative to cwd
foo.size; // number of bytes
foo.type; // MIME type
```

The reference conforms to the [`Blob`](https://developer.mozilla.org/en-US/docs/Web/API/Blob) interface, so the contents can be read in various formats.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
const foo = Bun.file("foo.txt");

await foo.text(); // contents as a string
await foo.json(); // contents as a JSON object
await foo.stream(); // contents as ReadableStream
await foo.arrayBuffer(); // contents as ArrayBuffer
await foo.bytes(); // contents as Uint8Array
```

File references can also be created using numerical [file descriptors](https://en.wikipedia.org/wiki/File_descriptor) or `file://` URLs.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
Bun.file(1234);
Bun.file(new URL(import.meta.url)); // reference to the current file
```

A `BunFile` can point to a location on disk where a file does not exist.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
const notreal = Bun.file("notreal.txt");
notreal.size; // 0
notreal.type; // "text/plain;charset=utf-8"
const exists = await notreal.exists(); // false
```

The default MIME type is `text/plain;charset=utf-8`, but it can be overridden by passing a second argument to `Bun.file`.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
const notreal = Bun.file("notreal.json", { type: "application/json" });
notreal.type; // => "application/json;charset=utf-8"
```

For convenience, Bun exposes `stdin`, `stdout` and `stderr` as instances of `BunFile`.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
Bun.stdin; // readonly
Bun.stdout;
Bun.stderr;
```

### Deleting files (`file.delete()`)

You can delete a file by calling the `.delete()` function.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
await Bun.file("logs.json").delete();
```

***

## Writing files (`Bun.write()`)

`Bun.write(destination, data): Promise<number>`

The `Bun.write` function is a multi-tool for writing payloads of all kinds to disk.

The first argument is the `destination` which can have any of the following types:

* `string`: A path to a location on the file system. Use the `"path"` module to manipulate paths.
* `URL`: A `file://` descriptor.
* `BunFile`: A file reference.

The second argument is the data to be written. It can be any of the following:

* `string`
* `Blob` (including `BunFile`)
* `ArrayBuffer` or `SharedArrayBuffer`
* `TypedArray` (`Uint8Array`, et. al.)
* `Response`

All possible permutations are handled using the fastest available system calls on the current platform.

<Accordion title="See syscalls">
  | Output               | Input          | System call                   | Platform |
  | -------------------- | -------------- | ----------------------------- | -------- |
  | file                 | file           | copy\_file\_range             | Linux    |
  | file                 | pipe           | sendfile                      | Linux    |
  | pipe                 | pipe           | splice                        | Linux    |
  | terminal             | file           | sendfile                      | Linux    |
  | terminal             | terminal       | sendfile                      | Linux    |
  | socket               | file or pipe   | sendfile (if http, not https) | Linux    |
  | file (doesn't exist) | file (path)    | clonefile                     | macOS    |
  | file (exists)        | file           | fcopyfile                     | macOS    |
  | file                 | Blob or string | write                         | macOS    |
  | file                 | Blob or string | write                         | Linux    |
</Accordion>

To write a string to disk:

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
const data = `It was the best of times, it was the worst of times.`;
await Bun.write("output.txt", data);
```

To copy a file to another location on disk:

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
const input = Bun.file("input.txt");
const output = Bun.file("output.txt"); // doesn't exist yet!
await Bun.write(output, input);
```

To write a byte array to disk:

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
const encoder = new TextEncoder();
const data = encoder.encode("datadatadata"); // Uint8Array
await Bun.write("output.txt", data);
```

To write a file to `stdout`:

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
const input = Bun.file("input.txt");
await Bun.write(Bun.stdout, input);
```

To write the body of an HTTP response to disk:

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
const response = await fetch("https://bun.com");
await Bun.write("index.html", response);
```

***

## Incremental writing with `FileSink`

Bun provides a native incremental file writing API called `FileSink`. To retrieve a `FileSink` instance from a `BunFile`:

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
const file = Bun.file("output.txt");
const writer = file.writer();
```

To incrementally write to the file, call `.write()`.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
const file = Bun.file("output.txt");
const writer = file.writer();

writer.write("it was the best of times\n");
writer.write("it was the worst of times\n");
```

These chunks will be buffered internally. To flush the buffer to disk, use `.flush()`. This returns the number of flushed bytes.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
writer.flush(); // write buffer to disk
```

The buffer will also auto-flush when the `FileSink`'s *high water mark* is reached; that is, when its internal buffer is full. This value can be configured.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
const file = Bun.file("output.txt");
const writer = file.writer({ highWaterMark: 1024 * 1024 }); // 1MB
```

To flush the buffer and close the file:

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
writer.end();
```

Note that, by default, the `bun` process will stay alive until this `FileSink` is explicitly closed with `.end()`. To opt out of this behavior, you can "unref" the instance.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
writer.unref();

// to "re-ref" it later
writer.ref();
```

***

## Directories

Bun's implementation of `node:fs` is fast, and we haven't implemented a Bun-specific API for reading directories just yet. For now, you should use `node:fs` for working with directories in Bun.

### Reading directories (readdir)

To read a directory in Bun, use `readdir` from `node:fs`.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
import { readdir } from "node:fs/promises";

// read all the files in the current directory
const files = await readdir(import.meta.dir);
```

#### Reading directories recursively

To recursively read a directory in Bun, use `readdir` with `recursive: true`.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
import { readdir } from "node:fs/promises";

// read all the files in the current directory, recursively
const files = await readdir("../", { recursive: true });
```

### Creating directories (mkdir)

To recursively create a directory, use `mkdir` in `node:fs`:

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
import { mkdir } from "node:fs/promises";

await mkdir("path/to/dir", { recursive: true });
```

***

## Benchmarks

The following is a 3-line implementation of the Linux `cat` command.

```ts cat.ts icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
// Usage
// bun ./cat.ts ./path-to-file

import { resolve } from "path";

const path = resolve(process.argv.at(-1));
await Bun.write(Bun.stdout, Bun.file(path));
```

To run the file:

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun ./cat.ts ./path-to-file
```

It runs 2x faster than GNU `cat` for large files on Linux.

<Frame>
  <img alt="Cat screenshot" />
</Frame>

***

## Reference

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
interface Bun {
  stdin: BunFile;
  stdout: BunFile;
  stderr: BunFile;

  file(path: string | number | URL, options?: { type?: string }): BunFile;

  write(
    destination: string | number | BunFile | URL,
    input: string | Blob | ArrayBuffer | SharedArrayBuffer | TypedArray | Response,
  ): Promise<number>;
}

interface BunFile {
  readonly size: number;
  readonly type: string;

  text(): Promise<string>;
  stream(): ReadableStream;
  arrayBuffer(): Promise<ArrayBuffer>;
  json(): Promise<any>;
  writer(params: { highWaterMark?: number }): FileSink;
  exists(): Promise<boolean>;
}

export interface FileSink {
  write(chunk: string | ArrayBufferView | ArrayBuffer | SharedArrayBuffer): number;
  flush(): number | Promise<number>;
  end(error?: Error): number | Promise<number>;
  start(options?: { highWaterMark?: number }): void;
  ref(): void;
  unref(): void;
}
```


# File System Router
Source: https://bun.com/docs/runtime/file-system-router

Bun provides a fast API for resolving routes against file-system paths

This API is primarily intended for library authors. At the moment only Next.js-style file-system routing is supported, but other styles may be added in the future.

## Next.js-style

The `FileSystemRouter` class can resolve routes against a `pages` directory. (The Next.js 13 `app` directory is not yet supported.) Consider the following `pages` directory:

```txt theme={"theme":{"light":"github-light","dark":"dracula"}}
pages
├── index.tsx
├── settings.tsx
├── blog
│   ├── [slug].tsx
│   └── index.tsx
└── [[...catchall]].tsx
```

The `FileSystemRouter` can be used to resolve routes against this directory:

```ts router.ts theme={"theme":{"light":"github-light","dark":"dracula"}}
const router = new Bun.FileSystemRouter({
  style: "nextjs",
  dir: "./pages",
  origin: "https://mydomain.com",
  assetPrefix: "_next/static/"
});

router.match("/");

// =>
{
  filePath: "/path/to/pages/index.tsx",
  kind: "exact",
  name: "/",
  pathname: "/",
  src: "https://mydomain.com/_next/static/pages/index.tsx"
}
```

Query parameters will be parsed and returned in the `query` property.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
router.match("/settings?foo=bar");

// =>
{
  filePath: "/Users/colinmcd94/Documents/bun/fun/pages/settings.tsx",
  kind: "dynamic",
  name: "/settings",
  pathname: "/settings?foo=bar",
  src: "https://mydomain.com/_next/static/pages/settings.tsx",
  query: {
    foo: "bar"
  }
}
```

The router will automatically parse URL parameters and return them in the `params` property:

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
router.match("/blog/my-cool-post");

// =>
{
  filePath: "/Users/colinmcd94/Documents/bun/fun/pages/blog/[slug].tsx",
  kind: "dynamic",
  name: "/blog/[slug]",
  pathname: "/blog/my-cool-post",
  src: "https://mydomain.com/_next/static/pages/blog/[slug].tsx",
  params: {
    slug: "my-cool-post"
  }
}
```

The `.match()` method also accepts `Request` and `Response` objects. The `url` property will be used to resolve the route.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
router.match(new Request("https://example.com/blog/my-cool-post"));
```

The router will read the directory contents on initialization. To re-scan the files, use the `.reload()` method.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
router.reload();
```

## Reference

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
interface Bun {
  class FileSystemRouter {
    constructor(params: {
      dir: string;
      style: "nextjs";
      origin?: string;
      assetPrefix?: string;
      fileExtensions?: string[];
    });

    reload(): void;

    match(path: string | Request | Response): {
      filePath: string;
      kind: "exact" | "catch-all" | "optional-catch-all" | "dynamic";
      name: string;
      pathname: string;
      src: string;
      params?: Record<string, string>;
      query?: Record<string, string>;
    } | null
  }
}
```


# File Types
Source: https://bun.com/docs/runtime/file-types

File types and loaders supported by Bun's bundler and runtime

The Bun bundler implements a set of default loaders out of the box. As a rule of thumb, the bundler and the runtime both support the same set of file types out of the box.

`.js` `.cjs` `.mjs` `.mts` `.cts` `.ts` `.tsx` `.jsx` `.css` `.json` `.jsonc` `.json5` `.toml` `.yaml` `.yml` `.txt` `.wasm` `.node` `.html` `.sh`

Bun uses the file extension to determine which built-in *loader* should be used to parse the file. Every loader has a name, such as `js`, `tsx`, or `json`. These names are used when building [plugins](/bundler/plugins) that extend Bun with custom loaders.

You can explicitly specify which loader to use using the `'type'` import attribute.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
import my_toml from "./my_file" with { type: "toml" };
// or with dynamic imports
const { default: my_toml } = await import("./my_file", { with: { type: "toml" } });
```

***

## Built-in loaders

### `js`

**JavaScript**. Default for `.cjs` and `.mjs`.

Parses the code and applies a set of default transforms like dead-code elimination and tree shaking. Note that Bun does not attempt to down-convert syntax at the moment.

### `jsx`

**JavaScript + JSX.**. Default for `.js` and `.jsx`.

Same as the `js` loader, but JSX syntax is supported. By default, JSX is down-converted to plain JavaScript; the details of how this is done depends on the `jsx*` compiler options in your `tsconfig.json`. Refer to the TypeScript documentation [on JSX](https://www.typescriptlang.org/docs/handbook/jsx.html) for more information.

### `ts`

**TypeScript loader**. Default for `.ts`, `.mts`, and `.cts`.

Strips out all TypeScript syntax, then behaves identically to the `js` loader. Bun does not perform typechecking.

### `tsx`

**TypeScript + JSX loader**. Default for `.tsx`. Transpiles both TypeScript and JSX to vanilla JavaScript.

### `json`

**JSON loader**. Default for `.json`.

JSON files can be directly imported.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
import pkg from "./package.json";
pkg.name; // => "my-package"
```

During bundling, the parsed JSON is inlined into the bundle as a JavaScript object.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
var pkg = {
  name: "my-package",
  // ... other fields
};
pkg.name;
```

If a `.json` file is passed as an entrypoint to the bundler, it will be converted to a `.js` module that `export default`s the parsed object.

<CodeGroup>
  ```json Input theme={"theme":{"light":"github-light","dark":"dracula"}}
  {
    "name": "John Doe",
    "age": 35,
    "email": "johndoe@example.com"
  }
  ```

  ```ts Output theme={"theme":{"light":"github-light","dark":"dracula"}}
  export default {
    name: "John Doe",
    age: 35,
    email: "johndoe@example.com",
  };
  ```
</CodeGroup>

### `jsonc`

**JSON with Comments loader**. Default for `.jsonc`.

JSONC (JSON with Comments) files can be directly imported. Bun will parse them, stripping out comments and trailing commas.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
import config from "./config.jsonc";
console.log(config);
```

During bundling, the parsed JSONC is inlined into the bundle as a JavaScript object, identical to the `json` loader.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
var config = {
  option: "value",
};
```

<Note>
  Bun automatically uses the `jsonc` loader for `tsconfig.json`, `jsconfig.json`, `package.json`, and `bun.lock` files.
</Note>

### `toml`

**TOML loader**. Default for `.toml`.

TOML files can be directly imported. Bun will parse them with its fast native TOML parser.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
import config from "./bunfig.toml";
config.logLevel; // => "debug"

// via import attribute:
// import myCustomTOML from './my.config' with {type: "toml"};
```

During bundling, the parsed TOML is inlined into the bundle as a JavaScript object.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
var config = {
  logLevel: "debug",
  // ...other fields
};
config.logLevel;
```

If a `.toml` file is passed as an entrypoint, it will be converted to a `.js` module that `export default`s the parsed object.

<CodeGroup>
  ```toml Input theme={"theme":{"light":"github-light","dark":"dracula"}}
  name = "John Doe"
  age = 35
  email = "johndoe@example.com"
  ```

  ```ts Output theme={"theme":{"light":"github-light","dark":"dracula"}}
  export default {
    name: "John Doe",
    age: 35,
    email: "johndoe@example.com",
  };
  ```
</CodeGroup>

### `yaml`

**YAML loader**. Default for `.yaml` and `.yml`.

YAML files can be directly imported. Bun will parse them with its fast native YAML parser.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
import config from "./config.yaml";
console.log(config);

// via import attribute:
import data from "./data.txt" with { type: "yaml" };
```

During bundling, the parsed YAML is inlined into the bundle as a JavaScript object.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
var config = {
  name: "my-app",
  version: "1.0.0",
  // ...other fields
};
```

If a `.yaml` or `.yml` file is passed as an entrypoint, it will be converted to a `.js` module that `export default`s the parsed object.

<CodeGroup>
  ```yaml Input theme={"theme":{"light":"github-light","dark":"dracula"}}
  name: John Doe
  age: 35
  email: johndoe@example.com
  ```

  ```ts Output theme={"theme":{"light":"github-light","dark":"dracula"}}
  export default {
    name: "John Doe",
    age: 35,
    email: "johndoe@example.com",
  };
  ```
</CodeGroup>

### `json5`

**JSON5 loader**. Default for `.json5`.

JSON5 files can be directly imported. Bun will parse them with its fast native JSON5 parser. JSON5 is a superset of JSON that supports comments, trailing commas, unquoted keys, single-quoted strings, and more.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
import config from "./config.json5";
console.log(config);

// via import attribute:
import data from "./data.txt" with { type: "json5" };
```

During bundling, the parsed JSON5 is inlined into the bundle as a JavaScript object.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
var config = {
  name: "my-app",
  version: "1.0.0",
  // ...other fields
};
```

If a `.json5` file is passed as an entrypoint, it will be converted to a `.js` module that `export default`s the parsed object.

<CodeGroup>
  ```json5 Input theme={"theme":{"light":"github-light","dark":"dracula"}}
  {
    // Configuration
    name: "John Doe",
    age: 35,
    email: "johndoe@example.com",
  }
  ```

  ```ts Output theme={"theme":{"light":"github-light","dark":"dracula"}}
  export default {
    name: "John Doe",
    age: 35,
    email: "johndoe@example.com",
  };
  ```
</CodeGroup>

### `text`

**Text loader**. Default for `.txt`.

The contents of the text file are read and inlined into the bundle as a string.
Text files can be directly imported. The file is read and returned as a string.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
import contents from "./file.txt";
console.log(contents); // => "Hello, world!"

// To import an html file as text
// The "type' attribute can be used to override the default loader.
import html from "./index.html" with { type: "text" };
```

When referenced during a build, the contents are inlined into the bundle as a string.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
var contents = `Hello, world!`;
console.log(contents);
```

If a `.txt` file is passed as an entrypoint, it will be converted to a `.js` module that `export default`s the file contents.

<CodeGroup>
  ```txt Input theme={"theme":{"light":"github-light","dark":"dracula"}}
  Hello, world!
  ```

  ```ts Output theme={"theme":{"light":"github-light","dark":"dracula"}}
  export default "Hello, world!";
  ```
</CodeGroup>

### `napi`

**Native addon loader**. Default for `.node`.

In the runtime, native addons can be directly imported.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
import addon from "./addon.node";
console.log(addon);
```

In the bundler, `.node` files are handled using the [`file`](#file) loader.

### `sqlite`

**SQLite loader**. `with { "type": "sqlite" }` import attribute

In the runtime and bundler, SQLite databases can be directly imported. This will load the database using [`bun:sqlite`](/runtime/sqlite).

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
import db from "./my.db" with { type: "sqlite" };
```

This is only supported when the `target` is `bun`.

By default, the database is external to the bundle (so that you can potentially use a database loaded elsewhere), so the database file on-disk won't be bundled into the final output.

You can change this behavior with the `"embed"` attribute:

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
// embed the database into the bundle
import db from "./my.db" with { type: "sqlite", embed: "true" };
```

When using a [standalone executable](/bundler/executables), the database is embedded into the single-file executable.

Otherwise, the database to embed is copied into the `outdir` with a hashed filename.

### `html`

The html loader processes HTML files and bundles any referenced assets. It will:

* Bundle and hash referenced JavaScript files (`<script src="...">`)
* Bundle and hash referenced CSS files (`<link rel="stylesheet" href="...">`)
* Hash referenced images (`<img src="...">`)
* Preserve external URLs (by default, anything starting with `http://` or `https://`)

For example, given this HTML file:

<CodeGroup>
  ```html src/index.html theme={"theme":{"light":"github-light","dark":"dracula"}}
  <!DOCTYPE html>
  <html>
    <body>
      <img src="./image.jpg" alt="Local image" />
      <img src="https://example.com/image.jpg" alt="External image" />
      <script type="module" src="./script.js"></script>
    </body>
  </html>
  ```
</CodeGroup>

It will output a new HTML file with the bundled assets:

<CodeGroup>
  ```html dist/output.html theme={"theme":{"light":"github-light","dark":"dracula"}}
  <!DOCTYPE html>
  <html>
    <body>
      <img src="./image-HASHED.jpg" alt="Local image" />
      <img src="https://example.com/image.jpg" alt="External image" />
      <script type="module" src="./output-ALSO-HASHED.js"></script>
    </body>
  </html>
  ```
</CodeGroup>

Under the hood, it uses [`lol-html`](https://github.com/cloudflare/lol-html) to extract script and link tags as entrypoints, and other assets as external.

Currently, the list of selectors is:

* `audio[src]`
* `iframe[src]`
* `img[src]`
* `img[srcset]`
* `link:not([rel~='stylesheet']):not([rel~='modulepreload']):not([rel~='manifest']):not([rel~='icon']):not([rel~='apple-touch-icon'])[href]`
* `link[as='font'][href], link[type^='font/'][href]`
* `link[as='image'][href]`
* `link[as='style'][href]`
* `link[as='video'][href], link[as='audio'][href]`
* `link[as='worker'][href]`
* `link[rel='icon'][href], link[rel='apple-touch-icon'][href]`
* `link[rel='manifest'][href]`
* `link[rel='stylesheet'][href]`
* `script[src]`
* `source[src]`
* `source[srcset]`
* `video[poster]`
* `video[src]`

<Note>
  **HTML Loader Behavior in Different Contexts**

  The `html` loader behaves differently depending on how it's used:

  1. **Static Build:** When you run `bun build ./index.html`, Bun produces a static site with all assets bundled and hashed.

  2. **Runtime:** When you run `bun run server.ts` (where `server.ts` imports an HTML file), Bun bundles assets on-the-fly during development, enabling features like hot module replacement.

  3. **Full-stack Build:** When you run `bun build --target=bun server.ts` (where `server.ts` imports an HTML file), the import resolves to a manifest object that `Bun.serve` uses to efficiently serve pre-bundled assets in production.
</Note>

### `css`

**CSS loader**. Default for `.css`.

CSS files can be directly imported. This is primarily useful for [full-stack applications](/bundler/html-static) where CSS is bundled alongside HTML.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
import "./styles.css";
```

There isn't any value returned from the import, it's only used for side effects.

### `sh` loader

**Bun Shell loader**. Default for `.sh` files

This loader is used to parse [Bun Shell](/runtime/shell) scripts. It's only supported when starting Bun itself, so it's not available in the bundler or in the runtime.

```sh theme={"theme":{"light":"github-light","dark":"dracula"}}
bun run ./script.sh
```

### `file`

**File loader**. Default for all unrecognized file types.

The file loader resolves the import as a *path/URL* to the imported file. It's commonly used for referencing media or font assets.

```ts logo.ts theme={"theme":{"light":"github-light","dark":"dracula"}}
import logo from "./logo.svg";
console.log(logo);
```

*In the runtime*, Bun checks that the `logo.svg` file exists and converts it to an absolute path to the location of `logo.svg` on disk.

```bash theme={"theme":{"light":"github-light","dark":"dracula"}}
bun run logo.ts
/path/to/project/logo.svg
```

*In the bundler*, things are slightly different. The file is copied into `outdir` as-is, and the import is resolved as a relative path pointing to the copied file.

```ts Output theme={"theme":{"light":"github-light","dark":"dracula"}}
var logo = "./logo.svg";
console.log(logo);
```

If a value is specified for `publicPath`, the import will use value as a prefix to construct an absolute path/URL.

| Public path                  | Resolved import                    |
| ---------------------------- | ---------------------------------- |
| `""` (default)               | `/logo.svg`                        |
| `"/assets"`                  | `/assets/logo.svg`                 |
| `"https://cdn.example.com/"` | `https://cdn.example.com/logo.svg` |

<Note>
  The location and file name of the copied file is determined by the value of [`naming.asset`](/bundler#naming).
</Note>

This loader is copied into the `outdir` as-is. The name of the copied file is determined using the value of
`naming.asset`.

<Accordion title="Fixing TypeScript import errors">
  If you're using TypeScript, you may get an error like this:

  ```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
  // TypeScript error
  // Cannot find module './logo.svg' or its corresponding type declarations.
  ```

  This can be fixed by creating `*.d.ts` file anywhere in your project (any name will work) with the following contents:

  ```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
  declare module "*.svg" {
    const content: string;
    export default content;
  }
  ```

  This tells TypeScript that any default imports from `.svg` should be treated as a string.
</Accordion>


# Glob
Source: https://bun.com/docs/runtime/glob

Use Bun's fast native implementation of file globbing

## Quickstart

**Scan a directory for files matching `*.ts`**:

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
import { Glob } from "bun";

const glob = new Glob("**/*.ts");

// Scans the current working directory and each of its sub-directories recursively
for await (const file of glob.scan(".")) {
  console.log(file); // => "index.ts"
}
```

**Match a string against a glob pattern**:

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
import { Glob } from "bun";

const glob = new Glob("*.ts");

glob.match("index.ts"); // => true
glob.match("index.js"); // => false
```

`Glob` is a class which implements the following interface:

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
class Glob {
  scan(root: string | ScanOptions): AsyncIterable<string>;
  scanSync(root: string | ScanOptions): Iterable<string>;

  match(path: string): boolean;
}

interface ScanOptions {
  /**
   * The root directory to start matching from. Defaults to `process.cwd()`
   */
  cwd?: string;

  /**
   * Allow patterns to match entries that begin with a period (`.`).
   *
   * @default false
   */
  dot?: boolean;

  /**
   * Return the absolute path for entries.
   *
   * @default false
   */
  absolute?: boolean;

  /**
   * Indicates whether to traverse descendants of symbolic link directories.
   *
   * @default false
   */
  followSymlinks?: boolean;

  /**
   * Throw an error when symbolic link is broken
   *
   * @default false
   */
  throwErrorOnBrokenSymlink?: boolean;

  /**
   * Return only files.
   *
   * @default true
   */
  onlyFiles?: boolean;
}
```

## Supported Glob Patterns

Bun supports the following glob patterns:

### `?` - Match any single character

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
const glob = new Glob("???.ts");
glob.match("foo.ts"); // => true
glob.match("foobar.ts"); // => false
```

### `*` - Matches zero or more characters, except for path separators (`/` or `\`)

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
const glob = new Glob("*.ts");
glob.match("index.ts"); // => true
glob.match("src/index.ts"); // => false
```

### `**` - Match any number of characters including `/`

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
const glob = new Glob("**/*.ts");
glob.match("index.ts"); // => true
glob.match("src/index.ts"); // => true
glob.match("src/index.js"); // => false
```

### `[ab]` - Matches one of the characters contained in the brackets, as well as character ranges

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
const glob = new Glob("ba[rz].ts");
glob.match("bar.ts"); // => true
glob.match("baz.ts"); // => true
glob.match("bat.ts"); // => false
```

You can use character ranges (e.g `[0-9]`, `[a-z]`) as well as the negation operators `^` or `!` to match anything *except* the characters contained within the braces (e.g `[^ab]`, `[!a-z]`)

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
const glob = new Glob("ba[a-z][0-9][^4-9].ts");
glob.match("bar01.ts"); // => true
glob.match("baz83.ts"); // => true
glob.match("bat22.ts"); // => true
glob.match("bat24.ts"); // => false
glob.match("ba0a8.ts"); // => false
```

### `{a,b,c}` - Match any of the given patterns

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
const glob = new Glob("{a,b,c}.ts");
glob.match("a.ts"); // => true
glob.match("b.ts"); // => true
glob.match("c.ts"); // => true
glob.match("d.ts"); // => false
```

These match patterns can be deeply nested (up to 10 levels), and contain any of the wildcards from above.

### `!` - Negates the result at the start of a pattern

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
const glob = new Glob("!index.ts");
glob.match("index.ts"); // => false
glob.match("foo.ts"); // => true
```

### `\` - Escapes any of the special characters above

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
const glob = new Glob("\\!index.ts");
glob.match("!index.ts"); // => true
glob.match("index.ts"); // => false
```

## Node.js `fs.glob()` compatibility

Bun also implements Node.js's `fs.glob()` functions with additional features:

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
import { glob, globSync, promises } from "node:fs";

// Array of patterns
const files = await promises.glob(["**/*.ts", "**/*.js"]);

// Exclude patterns
const filtered = await promises.glob("**/*", {
  exclude: ["node_modules/**", "*.test.*"],
});
```

All three functions (`fs.glob()`, `fs.globSync()`, `fs.promises.glob()`) support:

* Array of patterns as the first argument
* `exclude` option to filter results


# Globals
Source: https://bun.com/docs/runtime/globals

Use Bun's global objects

Bun implements the following globals.

| Global                                                                                                                  | Source         | Notes                                                                                                                                                                                                                                         |
| ----------------------------------------------------------------------------------------------------------------------- | -------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [`AbortController`](https://developer.mozilla.org/en-US/docs/Web/API/AbortController)                                   | Web            |                                                                                                                                                                                                                                               |
| [`AbortSignal`](https://developer.mozilla.org/en-US/docs/Web/API/AbortSignal)                                           | Web            |                                                                                                                                                                                                                                               |
| [`alert`](https://developer.mozilla.org/en-US/docs/Web/API/Window/alert)                                                | Web            | Intended for command-line tools                                                                                                                                                                                                               |
| [`Blob`](https://developer.mozilla.org/en-US/docs/Web/API/Blob)                                                         | Web            |                                                                                                                                                                                                                                               |
| [`Buffer`](https://nodejs.org/api/buffer.html#class-buffer)                                                             | Node.js        | See [Node.js > `Buffer`](/runtime/nodejs-compat#node-buffer)                                                                                                                                                                                  |
| `Bun`                                                                                                                   | Bun            | Subject to change as additional APIs are added                                                                                                                                                                                                |
| [`ByteLengthQueuingStrategy`](https://developer.mozilla.org/en-US/docs/Web/API/ByteLengthQueuingStrategy)               | Web            |                                                                                                                                                                                                                                               |
| [`confirm`](https://developer.mozilla.org/en-US/docs/Web/API/Window/confirm)                                            | Web            | Intended for command-line tools                                                                                                                                                                                                               |
| [`__dirname`](https://nodejs.org/api/globals.html#__dirname)                                                            | Node.js        |                                                                                                                                                                                                                                               |
| [`__filename`](https://nodejs.org/api/globals.html#__filename)                                                          | Node.js        |                                                                                                                                                                                                                                               |
| [`atob()`](https://developer.mozilla.org/en-US/docs/Web/API/atob)                                                       | Web            |                                                                                                                                                                                                                                               |
| [`btoa()`](https://developer.mozilla.org/en-US/docs/Web/API/btoa)                                                       | Web            |                                                                                                                                                                                                                                               |
| `BuildMessage`                                                                                                          | Bun            |                                                                                                                                                                                                                                               |
| [`clearImmediate()`](https://developer.mozilla.org/en-US/docs/Web/API/Window/clearImmediate)                            | Web            |                                                                                                                                                                                                                                               |
| [`clearInterval()`](https://developer.mozilla.org/en-US/docs/Web/API/Window/clearInterval)                              | Web            |                                                                                                                                                                                                                                               |
| [`clearTimeout()`](https://developer.mozilla.org/en-US/docs/Web/API/Window/clearTimeout)                                | Web            |                                                                                                                                                                                                                                               |
| [`console`](https://developer.mozilla.org/en-US/docs/Web/API/console)                                                   | Web            |                                                                                                                                                                                                                                               |
| [`CountQueuingStrategy`](https://developer.mozilla.org/en-US/docs/Web/API/CountQueuingStrategy)                         | Web            |                                                                                                                                                                                                                                               |
| [`Crypto`](https://developer.mozilla.org/en-US/docs/Web/API/Crypto)                                                     | Web            |                                                                                                                                                                                                                                               |
| [`crypto`](https://developer.mozilla.org/en-US/docs/Web/API/crypto)                                                     | Web            |                                                                                                                                                                                                                                               |
| [`CryptoKey`](https://developer.mozilla.org/en-US/docs/Web/API/CryptoKey)                                               | Web            |                                                                                                                                                                                                                                               |
| [`CustomEvent`](https://developer.mozilla.org/en-US/docs/Web/API/CustomEvent)                                           | Web            |                                                                                                                                                                                                                                               |
| [`Event`](https://developer.mozilla.org/en-US/docs/Web/API/Event)                                                       | Web            | Also [`ErrorEvent`](https://developer.mozilla.org/en-US/docs/Web/API/ErrorEvent) [`CloseEvent`](https://developer.mozilla.org/en-US/docs/Web/API/CloseEvent) [`MessageEvent`](https://developer.mozilla.org/en-US/docs/Web/API/MessageEvent). |
| [`EventTarget`](https://developer.mozilla.org/en-US/docs/Web/API/EventTarget)                                           | Web            |                                                                                                                                                                                                                                               |
| [`exports`](https://nodejs.org/api/globals.html#exports)                                                                | Node.js        |                                                                                                                                                                                                                                               |
| [`fetch`](https://developer.mozilla.org/en-US/docs/Web/API/fetch)                                                       | Web            |                                                                                                                                                                                                                                               |
| [`FormData`](https://developer.mozilla.org/en-US/docs/Web/API/FormData)                                                 | Web            |                                                                                                                                                                                                                                               |
| [`global`](https://nodejs.org/api/globals.html#global)                                                                  | Node.js        | See [Node.js > `global`](/runtime/nodejs-compat#global).                                                                                                                                                                                      |
| [`globalThis`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/globalThis)             | Cross-platform | Aliases to `global`                                                                                                                                                                                                                           |
| [`Headers`](https://developer.mozilla.org/en-US/docs/Web/API/Headers)                                                   | Web            |                                                                                                                                                                                                                                               |
| [`HTMLRewriter`](/runtime/html-rewriter)                                                                                | Cloudflare     |                                                                                                                                                                                                                                               |
| [`JSON`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/JSON)                         | Web            |                                                                                                                                                                                                                                               |
| [`MessageEvent`](https://developer.mozilla.org/en-US/docs/Web/API/MessageEvent)                                         | Web            |                                                                                                                                                                                                                                               |
| [`module`](https://nodejs.org/api/globals.html#module)                                                                  | Node.js        |                                                                                                                                                                                                                                               |
| [`performance`](https://developer.mozilla.org/en-US/docs/Web/API/performance)                                           | Web            |                                                                                                                                                                                                                                               |
| [`process`](https://nodejs.org/api/process.html)                                                                        | Node.js        | See [Node.js > `process`](/runtime/nodejs-compat#node-process)                                                                                                                                                                                |
| [`prompt`](https://developer.mozilla.org/en-US/docs/Web/API/Window/prompt)                                              | Web            | Intended for command-line tools                                                                                                                                                                                                               |
| [`queueMicrotask()`](https://developer.mozilla.org/en-US/docs/Web/API/queueMicrotask)                                   | Web            |                                                                                                                                                                                                                                               |
| [`ReadableByteStreamController`](https://developer.mozilla.org/en-US/docs/Web/API/ReadableByteStreamController)         | Web            |                                                                                                                                                                                                                                               |
| [`ReadableStream`](https://developer.mozilla.org/en-US/docs/Web/API/ReadableStream)                                     | Web            |                                                                                                                                                                                                                                               |
| [`ReadableStreamDefaultController`](https://developer.mozilla.org/en-US/docs/Web/API/ReadableStreamDefaultController)   | Web            |                                                                                                                                                                                                                                               |
| [`ReadableStreamDefaultReader`](https://developer.mozilla.org/en-US/docs/Web/API/ReadableStreamDefaultReader)           | Web            |                                                                                                                                                                                                                                               |
| [`reportError`](https://developer.mozilla.org/en-US/docs/Web/API/reportError)                                           | Web            |                                                                                                                                                                                                                                               |
| [`require()`](https://nodejs.org/api/globals.html#require)                                                              | Node.js        |                                                                                                                                                                                                                                               |
| `ResolveMessage`                                                                                                        | Bun            |                                                                                                                                                                                                                                               |
| [`Response`](https://developer.mozilla.org/en-US/docs/Web/API/Response)                                                 | Web            |                                                                                                                                                                                                                                               |
| [`Request`](https://developer.mozilla.org/en-US/docs/Web/API/Request)                                                   | Web            |                                                                                                                                                                                                                                               |
| [`setImmediate()`](https://developer.mozilla.org/en-US/docs/Web/API/Window/setImmediate)                                | Web            |                                                                                                                                                                                                                                               |
| [`setInterval()`](https://developer.mozilla.org/en-US/docs/Web/API/Window/setInterval)                                  | Web            |                                                                                                                                                                                                                                               |
| [`setTimeout()`](https://developer.mozilla.org/en-US/docs/Web/API/Window/setTimeout)                                    | Web            |                                                                                                                                                                                                                                               |
| [`ShadowRealm`](https://github.com/tc39/proposal-shadowrealm)                                                           | Web            | Stage 3 proposal                                                                                                                                                                                                                              |
| [`SubtleCrypto`](https://developer.mozilla.org/en-US/docs/Web/API/SubtleCrypto)                                         | Web            |                                                                                                                                                                                                                                               |
| [`DOMException`](https://developer.mozilla.org/en-US/docs/Web/API/DOMException)                                         | Web            |                                                                                                                                                                                                                                               |
| [`TextDecoder`](https://developer.mozilla.org/en-US/docs/Web/API/TextDecoder)                                           | Web            |                                                                                                                                                                                                                                               |
| [`TextEncoder`](https://developer.mozilla.org/en-US/docs/Web/API/TextEncoder)                                           | Web            |                                                                                                                                                                                                                                               |
| [`TransformStream`](https://developer.mozilla.org/en-US/docs/Web/API/TransformStream)                                   | Web            |                                                                                                                                                                                                                                               |
| [`TransformStreamDefaultController`](https://developer.mozilla.org/en-US/docs/Web/API/TransformStreamDefaultController) | Web            |                                                                                                                                                                                                                                               |
| [`URL`](https://developer.mozilla.org/en-US/docs/Web/API/URL)                                                           | Web            |                                                                                                                                                                                                                                               |
| [`URLSearchParams`](https://developer.mozilla.org/en-US/docs/Web/API/URLSearchParams)                                   | Web            |                                                                                                                                                                                                                                               |
| [`WebAssembly`](https://nodejs.org/api/globals.html#webassembly)                                                        | Web            |                                                                                                                                                                                                                                               |
| [`WritableStream`](https://developer.mozilla.org/en-US/docs/Web/API/WritableStream)                                     | Web            |                                                                                                                                                                                                                                               |
| [`WritableStreamDefaultController`](https://developer.mozilla.org/en-US/docs/Web/API/WritableStreamDefaultController)   | Web            |                                                                                                                                                                                                                                               |
| [`WritableStreamDefaultWriter`](https://developer.mozilla.org/en-US/docs/Web/API/WritableStreamDefaultWriter)           | Web            |                                                                                                                                                                                                                                               |


# Hashing
Source: https://bun.com/docs/runtime/hashing

Bun provides a set of utility functions for hashing and verifying passwords with various cryptographically secure algorithms

<Note>
  Bun implements the `createHash` and `createHmac` functions from [`node:crypto`](https://nodejs.org/api/crypto.html) in
  addition to the Bun-native APIs documented below.
</Note>

***

## `Bun.password`

`Bun.password` is a collection of utility functions for hashing and verifying passwords with various cryptographically secure algorithms.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
const password = "super-secure-pa$$word";

const hash = await Bun.password.hash(password);
// => $argon2id$v=19$m=65536,t=2,p=1$tFq+9AVr1bfPxQdh6E8DQRhEXg/M/SqYCNu6gVdRRNs$GzJ8PuBi+K+BVojzPfS5mjnC8OpLGtv8KJqF99eP6a4

const isMatch = await Bun.password.verify(password, hash);
// => true
```

The second argument to `Bun.password.hash` accepts a params object that lets you pick and configure the hashing algorithm.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
const password = "super-secure-pa$$word";

// use argon2 (default)
const argonHash = await Bun.password.hash(password, {
  algorithm: "argon2id", // "argon2id" | "argon2i" | "argon2d"
  memoryCost: 4, // memory usage in kibibytes
  timeCost: 3, // the number of iterations
});

// use bcrypt
const bcryptHash = await Bun.password.hash(password, {
  algorithm: "bcrypt",
  cost: 4, // number between 4-31
});
```

The algorithm used to create the hash is stored in the hash itself. When using `bcrypt`, the returned hash is encoded in [Modular Crypt Format](https://passlib.readthedocs.io/en/stable/modular_crypt_format.html) for compatibility with most existing `bcrypt` implementations; with `argon2` the result is encoded in the newer [PHC format](https://github.com/P-H-C/phc-string-format/blob/master/phc-sf-spec.md).

The `verify` function automatically detects the algorithm based on the input hash and use the correct verification method. It can correctly infer the algorithm from both PHC- or MCF-encoded hashes.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
const password = "super-secure-pa$$word";

const hash = await Bun.password.hash(password, {
  /* config */
});

const isMatch = await Bun.password.verify(password, hash);
// => true
```

Synchronous versions of all functions are also available. Keep in mind that these functions are computationally expensive, so using a blocking API may degrade application performance.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
const password = "super-secure-pa$$word";

const hash = Bun.password.hashSync(password, {
  /* config */
});

const isMatch = Bun.password.verifySync(password, hash);
// => true
```

### Salt

When you use `Bun.password.hash`, a salt is automatically generated and included in the hash.

### bcrypt - Modular Crypt Format

In the following [Modular Crypt Format](https://passlib.readthedocs.io/en/stable/modular_crypt_format.html) hash (used by `bcrypt`):

Input:

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
await Bun.password.hash("hello", {
  algorithm: "bcrypt",
});
```

Output:

```sh theme={"theme":{"light":"github-light","dark":"dracula"}}
$2b$10$Lyj9kHYZtiyfxh2G60TEfeqs7xkkGiEFFDi3iJGc50ZG/XJ1sxIFi;
```

The format is composed of:

* `bcrypt`: `$2b`
* `rounds`: `$10` - rounds (log10 of the actual number of rounds)
* `salt`: `$Lyj9kHYZtiyfxh2G60TEfeqs7xkkGiEFFDi3iJGc50ZG/XJ1sxIFi`
* `hash`: `$GzJ8PuBi+K+BVojzPfS5mjnC8OpLGtv8KJqF99eP6a4`

By default, the bcrypt library truncates passwords longer than 72 bytes. In Bun, if you pass `Bun.password.hash` a password longer than 72 bytes and use the `bcrypt` algorithm, the password will be hashed via SHA-512 before being passed to bcrypt.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
await Bun.password.hash("hello".repeat(100), {
  algorithm: "bcrypt",
});
```

So instead of sending bcrypt a 500-byte password silently truncated to 72 bytes, Bun will hash the password using SHA-512 and send the hashed password to bcrypt (only if it exceeds 72 bytes). This is a more secure default behavior.

### argon2 - PHC format

In the following [PHC format](https://github.com/P-H-C/phc-string-format/blob/master/phc-sf-spec.md) hash (used by `argon2`):

Input:

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
await Bun.password.hash("hello", {
  algorithm: "argon2id",
});
```

Output:

```sh theme={"theme":{"light":"github-light","dark":"dracula"}}
$argon2id$v=19$m=65536,t=2,p=1$xXnlSvPh4ym5KYmxKAuuHVlDvy2QGHBNuI6bJJrRDOs$2YY6M48XmHn+s5NoBaL+ficzXajq2Yj8wut3r0vnrwI
```

The format is composed of:

* `algorithm`: `$argon2id`
* `version`: `$v=19`
* `memory cost`: `65536`
* `iterations`: `t=2`
* `parallelism`: `p=1`
* `salt`: `$xXnlSvPh4ym5KYmxKAuuHVlDvy2QGHBNuI6bJJrRDOs`
* `hash`: `$2YY6M48XmHn+s5NoBaL+ficzXajq2Yj8wut3r0vnrwI`

***

## `Bun.hash`

`Bun.hash` is a collection of utilities for *non-cryptographic* hashing. Non-cryptographic hashing algorithms are optimized for speed of computation over collision-resistance or security.

The standard `Bun.hash` functions uses [Wyhash](https://github.com/wangyi-fudan/wyhash) to generate a 64-bit hash from an input of arbitrary size.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
Bun.hash("some data here");
// 11562320457524636935n
```

The input can be a string, `TypedArray`, `DataView`, `ArrayBuffer`, or `SharedArrayBuffer`.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
const arr = new Uint8Array([1, 2, 3, 4]);

Bun.hash("some data here");
Bun.hash(arr);
Bun.hash(arr.buffer);
Bun.hash(new DataView(arr.buffer));
```

Optionally, an integer seed can be specified as the second parameter. For 64-bit hashes seeds above `Number.MAX_SAFE_INTEGER` should be given as BigInt to avoid loss of precision.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
Bun.hash("some data here", 1234);
// 15724820720172937558n
```

Additional hashing algorithms are available as properties on `Bun.hash`. The API is the same for each, only changing the return type from number for 32-bit hashes to bigint for 64-bit hashes.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
Bun.hash.wyhash("data", 1234); // equivalent to Bun.hash()
Bun.hash.crc32("data", 1234);
Bun.hash.adler32("data", 1234);
Bun.hash.cityHash32("data", 1234);
Bun.hash.cityHash64("data", 1234);
Bun.hash.xxHash32("data", 1234);
Bun.hash.xxHash64("data", 1234);
Bun.hash.xxHash3("data", 1234);
Bun.hash.murmur32v3("data", 1234);
Bun.hash.murmur32v2("data", 1234);
Bun.hash.murmur64v2("data", 1234);
Bun.hash.rapidhash("data", 1234);
```

***

## `Bun.CryptoHasher`

`Bun.CryptoHasher` is a general-purpose utility class that lets you incrementally compute a hash of string or binary data using a range of cryptographic hash algorithms. The following algorithms are supported:

* `"blake2b256"`
* `"blake2b512"`
* `"md4"`
* `"md5"`
* `"ripemd160"`
* `"sha1"`
* `"sha224"`
* `"sha256"`
* `"sha384"`
* `"sha512"`
* `"sha512-224"`
* `"sha512-256"`
* `"sha3-224"`
* `"sha3-256"`
* `"sha3-384"`
* `"sha3-512"`
* `"shake128"`
* `"shake256"`

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
const hasher = new Bun.CryptoHasher("sha256");
hasher.update("hello world");
hasher.digest();
// Uint8Array(32) [ <byte>, <byte>, ... ]
```

Once initialized, data can be incrementally fed to to the hasher using `.update()`. This method accepts `string`, `TypedArray`, and `ArrayBuffer`.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
const hasher = new Bun.CryptoHasher("sha256");

hasher.update("hello world");
hasher.update(new Uint8Array([1, 2, 3]));
hasher.update(new ArrayBuffer(10));
```

If a `string` is passed, an optional second parameter can be used to specify the encoding (default `'utf-8'`). The following encodings are supported:

| Category                   | Encodings                                   |
| -------------------------- | ------------------------------------------- |
| Binary encodings           | `"base64"` `"base64url"` `"hex"` `"binary"` |
| Character encodings        | `"utf8"` `"utf-8"` `"utf16le"` `"latin1"`   |
| Legacy character encodings | `"ascii"` `"binary"` `"ucs2"` `"ucs-2"`     |

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
hasher.update("hello world"); // defaults to utf8
hasher.update("hello world", "hex");
hasher.update("hello world", "base64");
hasher.update("hello world", "latin1");
```

After the data has been feed into the hasher, a final hash can be computed using `.digest()`. By default, this method returns a `Uint8Array` containing the hash.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
const hasher = new Bun.CryptoHasher("sha256");
hasher.update("hello world");

hasher.digest();
// => Uint8Array(32) [ 185, 77, 39, 185, 147, ... ]
```

The `.digest()` method can optionally return the hash as a string. To do so, specify an encoding:

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
hasher.digest("base64");
// => "uU0nuZNNPgilLlLX2n2r+sSE7+N6U4DukIj3rOLvzek="

hasher.digest("hex");
// => "b94d27b9934d3e08a52e52d7da7dabfac484efe37a5380ee9088f7ace2efcde9"
```

Alternatively, the method can write the hash into a pre-existing `TypedArray` instance. This may be desirable in some performance-sensitive applications.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
const arr = new Uint8Array(32);

hasher.digest(arr);

console.log(arr);
// => Uint8Array(32) [ 185, 77, 39, 185, 147, ... ]
```

### HMAC in `Bun.CryptoHasher`

`Bun.CryptoHasher` can be used to compute HMAC digests. To do so, pass the key to the constructor.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
const hasher = new Bun.CryptoHasher("sha256", "secret-key");
hasher.update("hello world");
console.log(hasher.digest("hex"));
// => "095d5a21fe6d0646db223fdf3de6436bb8dfb2fab0b51677ecf6441fcf5f2a67"
```

When using HMAC, a more limited set of algorithms are supported:

* `"blake2b512"`
* `"md5"`
* `"sha1"`
* `"sha224"`
* `"sha256"`
* `"sha384"`
* `"sha512-224"`
* `"sha512-256"`
* `"sha512"`

Unlike the non-HMAC `Bun.CryptoHasher`, the HMAC `Bun.CryptoHasher` instance is not reset after `.digest()` is called, and attempting to use the same instance again will throw an error.

Other methods like `.copy()` and `.update()` are supported (as long as it's before `.digest()`), but methods like `.digest()` that finalize the hasher are not.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
const hasher = new Bun.CryptoHasher("sha256", "secret-key");
hasher.update("hello world");

const copy = hasher.copy();
copy.update("!");
console.log(copy.digest("hex"));
// => "3840176c3d8923f59ac402b7550404b28ab11cb0ef1fa199130a5c37864b5497"

console.log(hasher.digest("hex"));
// => "095d5a21fe6d0646db223fdf3de6436bb8dfb2fab0b51677ecf6441fcf5f2a67"
```


# HTMLRewriter
Source: https://bun.com/docs/runtime/html-rewriter

Use Bun's HTMLRewriter to transform HTML documents with CSS selectors

HTMLRewriter lets you use CSS selectors to transform HTML documents. It works with `Request`, `Response`, as well as `string`. Bun's implementation is based on Cloudflare's [lol-html](https://github.com/cloudflare/lol-html).

***

## Usage

A common usecase is rewriting URLs in HTML content. Here's an example that rewrites image sources and link URLs to use a CDN domain:

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
// Replace all images with a rickroll
const rewriter = new HTMLRewriter().on("img", {
  element(img) {
    // Famous rickroll video thumbnail
    img.setAttribute("src", "https://img.youtube.com/vi/dQw4w9WgXcQ/maxresdefault.jpg");

    // Wrap the image in a link to the video
    img.before('<a href="https://www.youtube.com/watch?v=dQw4w9WgXcQ" target="_blank">', {
      html: true,
    });
    img.after("</a>", { html: true });

    // Add some fun alt text
    img.setAttribute("alt", "Definitely not a rickroll");
  },
});

// An example HTML document
const html = `
<html>
<body>
  <img src="/cat.jpg">
  <img src="dog.png">
  <img src="https://example.com/bird.webp">
</body>
</html>
`;

const result = rewriter.transform(html);
console.log(result);
```

This replaces all images with a thumbnail of Rick Astley and wraps each `<img>` in a link, producing a diff like this:

```html theme={"theme":{"light":"github-light","dark":"dracula"}}
<html>
  <body>
    <img src="/cat.jpg" /> <!-- [!code --] -->
    <img src="dog.png" /> <!-- [!code --] -->
    <img src="https://example.com/bird.webp" /> <!-- [!code --] -->
    <a href="https://www.youtube.com/watch?v=dQw4w9WgXcQ" target="_blank"> <!-- [!code ++] -->
      <img src="https://img.youtube.com/vi/dQw4w9WgXcQ/maxresdefault.jpg" alt="Definitely not a rickroll" /> <!-- [!code ++] -->
    </a> <!-- [!code ++] -->
    <a href="https://www.youtube.com/watch?v=dQw4w9WgXcQ" target="_blank"> <!-- [!code ++] -->
      <img src="https://img.youtube.com/vi/dQw4w9WgXcQ/maxresdefault.jpg" alt="Definitely not a rickroll" /> <!-- [!code ++] -->
    </a> <!-- [!code ++] -->
    <a href="https://www.youtube.com/watch?v=dQw4w9WgXcQ" target="_blank"> <!-- [!code ++] -->
      <img src="https://img.youtube.com/vi/dQw4w9WgXcQ/maxresdefault.jpg" alt="Definitely not a rickroll" /> <!-- [!code ++] -->
    </a> <!-- [!code ++] -->
  </body>
</html>
```

Now every image on the page will be replaced with a thumbnail of Rick Astley, and clicking any image will lead to [a very famous video](https://www.youtube.com/watch?v=dQw4w9WgXcQ).

### Input types

HTMLRewriter can transform HTML from various sources. The input is automatically handled based on its type:

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
// From Response
rewriter.transform(new Response("<div>content</div>"));

// From string
rewriter.transform("<div>content</div>");

// From ArrayBuffer
rewriter.transform(new TextEncoder().encode("<div>content</div>").buffer);

// From Blob
rewriter.transform(new Blob(["<div>content</div>"]));

// From File
rewriter.transform(Bun.file("index.html"));
```

Note that Cloudflare Workers implementation of HTMLRewriter only supports `Response` objects.

### Element Handlers

The `on(selector, handlers)` method allows you to register handlers for HTML elements that match a CSS selector. The handlers are called for each matching element during parsing:

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
rewriter.on("div.content", {
  // Handle elements
  element(element) {
    element.setAttribute("class", "new-content");
    element.append("<p>New content</p>", { html: true });
  },
  // Handle text nodes
  text(text) {
    text.replace("new text");
  },
  // Handle comments
  comments(comment) {
    comment.remove();
  },
});
```

The handlers can be asynchronous and return a Promise. Note that async operations will block the transformation until they complete:

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
rewriter.on("div", {
  async element(element) {
    await Bun.sleep(1000);
    element.setInnerContent("<span>replace</span>", { html: true });
  },
});
```

### CSS Selector Support

The `on()` method supports a wide range of CSS selectors:

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
// Tag selectors
rewriter.on("p", handler);

// Class selectors
rewriter.on("p.red", handler);

// ID selectors
rewriter.on("h1#header", handler);

// Attribute selectors
rewriter.on("p[data-test]", handler); // Has attribute
rewriter.on('p[data-test="one"]', handler); // Exact match
rewriter.on('p[data-test="one" i]', handler); // Case-insensitive
rewriter.on('p[data-test="one" s]', handler); // Case-sensitive
rewriter.on('p[data-test~="two"]', handler); // Word match
rewriter.on('p[data-test^="a"]', handler); // Starts with
rewriter.on('p[data-test$="1"]', handler); // Ends with
rewriter.on('p[data-test*="b"]', handler); // Contains
rewriter.on('p[data-test|="a"]', handler); // Dash-separated

// Combinators
rewriter.on("div span", handler); // Descendant
rewriter.on("div > span", handler); // Direct child

// Pseudo-classes
rewriter.on("p:nth-child(2)", handler);
rewriter.on("p:first-child", handler);
rewriter.on("p:nth-of-type(2)", handler);
rewriter.on("p:first-of-type", handler);
rewriter.on("p:not(:first-child)", handler);

// Universal selector
rewriter.on("*", handler);
```

### Element Operations

Elements provide various methods for manipulation. All modification methods return the element instance for chaining:

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
rewriter.on("div", {
  element(el) {
    // Attributes
    el.setAttribute("class", "new-class").setAttribute("data-id", "123");

    const classAttr = el.getAttribute("class"); // "new-class"
    const hasId = el.hasAttribute("id"); // boolean
    el.removeAttribute("class");

    // Content manipulation
    el.setInnerContent("New content"); // Escapes HTML by default
    el.setInnerContent("<p>HTML content</p>", { html: true }); // Parses HTML
    el.setInnerContent(""); // Clear content

    // Position manipulation
    el.before("Content before").after("Content after").prepend("First child").append("Last child");

    // HTML content insertion
    el.before("<span>before</span>", { html: true })
      .after("<span>after</span>", { html: true })
      .prepend("<span>first</span>", { html: true })
      .append("<span>last</span>", { html: true });

    // Removal
    el.remove(); // Remove element and contents
    el.removeAndKeepContent(); // Remove only the element tags

    // Properties
    console.log(el.tagName); // Lowercase tag name
    console.log(el.namespaceURI); // Element's namespace URI
    console.log(el.selfClosing); // Whether element is self-closing (e.g. <div />)
    console.log(el.canHaveContent); // Whether element can contain content (false for void elements like <br>)
    console.log(el.removed); // Whether element was removed

    // Attributes iteration
    for (const [name, value] of el.attributes) {
      console.log(name, value);
    }

    // End tag handling
    el.onEndTag(endTag => {
      endTag.before("Before end tag");
      endTag.after("After end tag");
      endTag.remove(); // Remove the end tag
      console.log(endTag.name); // Tag name in lowercase
    });
  },
});
```

### Text Operations

Text handlers provide methods for text manipulation. Text chunks represent portions of text content and provide information about their position in the text node:

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
rewriter.on("p", {
  text(text) {
    // Content
    console.log(text.text); // Text content
    console.log(text.lastInTextNode); // Whether this is the last chunk
    console.log(text.removed); // Whether text was removed

    // Manipulation
    text.before("Before text").after("After text").replace("New text").remove();

    // HTML content insertion
    text
      .before("<span>before</span>", { html: true })
      .after("<span>after</span>", { html: true })
      .replace("<span>replace</span>", { html: true });
  },
});
```

### Comment Operations

Comment handlers allow comment manipulation with similar methods to text nodes:

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
rewriter.on("*", {
  comments(comment) {
    // Content
    console.log(comment.text); // Comment text
    comment.text = "New comment text"; // Set comment text
    console.log(comment.removed); // Whether comment was removed

    // Manipulation
    comment.before("Before comment").after("After comment").replace("New comment").remove();

    // HTML content insertion
    comment
      .before("<span>before</span>", { html: true })
      .after("<span>after</span>", { html: true })
      .replace("<span>replace</span>", { html: true });
  },
});
```

### Document Handlers

The `onDocument(handlers)` method allows you to handle document-level events. These handlers are called for events that occur at the document level rather than within specific elements:

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
rewriter.onDocument({
  // Handle doctype
  doctype(doctype) {
    console.log(doctype.name); // "html"
    console.log(doctype.publicId); // public identifier if present
    console.log(doctype.systemId); // system identifier if present
  },
  // Handle text nodes
  text(text) {
    console.log(text.text);
  },
  // Handle comments
  comments(comment) {
    console.log(comment.text);
  },
  // Handle document end
  end(end) {
    end.append("<!-- Footer -->", { html: true });
  },
});
```

### Response Handling

When transforming a Response:

* The status code, headers, and other response properties are preserved
* The body is transformed while maintaining streaming capabilities
* Content-encoding (like gzip) is handled automatically
* The original response body is marked as used after transformation
* Headers are cloned to the new response

## Error Handling

HTMLRewriter operations can throw errors in several cases:

* Invalid selector syntax in `on()` method
* Invalid HTML content in transformation methods
* Stream errors when processing Response bodies
* Memory allocation failures
* Invalid input types (e.g., passing Symbol)
* Body already used errors

Errors should be caught and handled appropriately:

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
try {
  const result = rewriter.transform(input);
  // Process result
} catch (error) {
  console.error("HTMLRewriter error:", error);
}
```

***

## See also

You can also read the [Cloudflare documentation](https://developers.cloudflare.com/workers/runtime-apis/html-rewriter/), which this API is intended to be compatible with.


# Cookies
Source: https://bun.com/docs/runtime/http/cookies

Work with cookies in HTTP requests and responses using Bun's built-in Cookie API.

Bun provides a built-in API for working with cookies in HTTP requests and responses. The `BunRequest` object includes a `cookies` property that provides a `CookieMap` for easily accessing and manipulating cookies. When using `routes`, `Bun.serve()` automatically tracks `request.cookies.set` and applies them to the response.

## Reading cookies

Read cookies from incoming requests using the `cookies` property on the `BunRequest` object:

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
Bun.serve({
  routes: {
    "/profile": req => {
      // Access cookies from the request
      const userId = req.cookies.get("user_id");
      const theme = req.cookies.get("theme") || "light";

      return Response.json({
        userId,
        theme,
        message: "Profile page",
      });
    },
  },
});
```

## Setting cookies

To set cookies, use the `set` method on the `CookieMap` from the `BunRequest` object.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
Bun.serve({
  routes: {
    "/login": req => {
      const cookies = req.cookies;

      // Set a cookie with various options
      cookies.set("user_id", "12345", {
        maxAge: 60 * 60 * 24 * 7, // 1 week
        httpOnly: true,
        secure: true,
        path: "/",
      });

      // Add a theme preference cookie
      cookies.set("theme", "dark");

      // Modified cookies from the request are automatically applied to the response
      return new Response("Login successful");
    },
  },
});
```

`Bun.serve()` automatically tracks modified cookies from the request and applies them to the response.

## Deleting cookies

To delete a cookie, use the `delete` method on the `request.cookies` (`CookieMap`) object:

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
Bun.serve({
  routes: {
    "/logout": req => {
      // Delete the user_id cookie
      req.cookies.delete("user_id", {
        path: "/",
      });

      return new Response("Logged out successfully");
    },
  },
});
```

Deleted cookies become a `Set-Cookie` header on the response with the `maxAge` set to `0` and an empty `value`.


# Error Handling
Source: https://bun.com/docs/runtime/http/error-handling

Learn how to handle errors in Bun's development server

To activate development mode, set `development: true`.

```ts title="server.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
Bun.serve({
  development: true, // [!code ++]
  fetch(req) {
    throw new Error("woops!");
  },
});
```

In development mode, Bun will surface errors in-browser with a built-in error page.

<Frame>
  <img alt="Bun's built-in 500 page" />
</Frame>

### `error` callback

To handle server-side errors, implement an `error` handler. This function should return a `Response` to serve to the client when an error occurs. This response will supersede Bun's default error page in `development` mode.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
Bun.serve({
  fetch(req) {
    throw new Error("woops!");
  },
  error(error) {
    return new Response(`<pre>${error}\n${error.stack}</pre>`, {
      headers: {
        "Content-Type": "text/html",
      },
    });
  },
});
```

<Info>[Learn more about debugging in Bun](/runtime/debugger)</Info>


# Metrics
Source: https://bun.com/docs/runtime/http/metrics

Monitor server activity with built-in metrics

### `server.pendingRequests` and `server.pendingWebSockets`

Monitor server activity with built-in counters:

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
const server = Bun.serve({
  fetch(req, server) {
    return new Response(
      `Active requests: ${server.pendingRequests}\n` + `Active WebSockets: ${server.pendingWebSockets}`,
    );
  },
});
```

### `server.subscriberCount(topic)`

Get count of subscribers for a WebSocket topic:

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
const server = Bun.serve({
  fetch(req, server) {
    const chatUsers = server.subscriberCount("chat");
    return new Response(`${chatUsers} users in chat`);
  },
  websocket: {
    message(ws) {
      ws.subscribe("chat");
    },
  },
});
```


# Routing
Source: https://bun.com/docs/runtime/http/routing

Define routes in `Bun.serve` using static paths, parameters, and wildcards

You can add routes to `Bun.serve()` by using the `routes` property (for static paths, parameters, and wildcards) or by handling unmatched requests with the [`fetch`](#fetch) method.

`Bun.serve()`'s router builds on top uWebSocket's [tree-based approach](https://github.com/oven-sh/bun/blob/0d1a00fa0f7830f8ecd99c027fce8096c9d459b6/packages/bun-uws/src/HttpRouter.h#L57-L64) to add [SIMD-accelerated route parameter decoding](https://github.com/oven-sh/bun/blob/main/src/bun.js/bindings/decodeURIComponentSIMD.cpp#L21-L271) and [JavaScriptCore structure caching](https://github.com/oven-sh/bun/blob/main/src/bun.js/bindings/ServerRouteList.cpp#L100-L101) to push the performance limits of what modern hardware allows.

## Basic Setup

```ts title="server.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
Bun.serve({
  routes: {
    "/": () => new Response("Home"),
    "/api": () => Response.json({ success: true }),
    "/users": async () => Response.json({ users: [] }),
  },
  fetch() {
    return new Response("Unmatched route");
  },
});
```

Routes in `Bun.serve()` receive a `BunRequest` (which extends [`Request`](https://developer.mozilla.org/en-US/docs/Web/API/Request)) and return a [`Response`](https://developer.mozilla.org/en-US/docs/Web/API/Response) or `Promise<Response>`. This makes it easier to use the same code for both sending & receiving HTTP requests.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
// Simplified for brevity
interface BunRequest<T extends string> extends Request {
  params: Record<T, string>;
  readonly cookies: CookieMap;
}
```

## Asynchronous Routes

### Async/await

You can use async/await in route handlers to return a `Promise<Response>`.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
import { sql, serve } from "bun";

serve({
  port: 3001,
  routes: {
    "/api/version": async () => {
      const [version] = await sql`SELECT version()`;
      return Response.json(version);
    },
  },
});
```

### Promise

You can also return a `Promise<Response>` from a route handler.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
import { sql, serve } from "bun";

serve({
  routes: {
    "/api/version": () => {
      return new Promise(resolve => {
        setTimeout(async () => {
          const [version] = await sql`SELECT version()`;
          resolve(Response.json(version));
        }, 100);
      });
    },
  },
});
```

***

## Route precedence

Routes are matched in order of specificity:

1. Exact routes (`/users/all`)
2. Parameter routes (`/users/:id`)
3. Wildcard routes (`/users/*`)
4. Global catch-all (`/*`)

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
Bun.serve({
  routes: {
    // Most specific first
    "/api/users/me": () => new Response("Current user"),
    "/api/users/:id": req => new Response(`User ${req.params.id}`),
    "/api/*": () => new Response("API catch-all"),
    "/*": () => new Response("Global catch-all"),
  },
});
```

***

## Type-safe route parameters

TypeScript parses route parameters when passed as a string literal, so that your editor will show autocomplete when accessing `request.params`.

```ts title="index.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import type { BunRequest } from "bun";

Bun.serve({
  routes: {
    // TypeScript knows the shape of params when passed as a string literal
    "/orgs/:orgId/repos/:repoId": req => {
      const { orgId, repoId } = req.params;
      return Response.json({ orgId, repoId });
    },

    "/orgs/:orgId/repos/:repoId/settings": (
      // optional: you can explicitly pass a type to BunRequest:
      req: BunRequest<"/orgs/:orgId/repos/:repoId/settings">,
    ) => {
      const { orgId, repoId } = req.params;
      return Response.json({ orgId, repoId });
    },
  },
});
```

Percent-encoded route parameter values are automatically decoded. Unicode characters are supported. Invalid unicode is replaced with the unicode replacement character `&0xFFFD;`.

### Static responses

Routes can also be `Response` objects (without the handler function). Bun.serve() optimizes it for zero-allocation dispatch - perfect for health checks, redirects, and fixed content:

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
Bun.serve({
  routes: {
    // Health checks
    "/health": new Response("OK"),
    "/ready": new Response("Ready", {
      headers: {
        // Pass custom headers
        "X-Ready": "1",
      },
    }),

    // Redirects
    "/blog": Response.redirect("https://bun.com/blog"),

    // API responses
    "/api/config": Response.json({
      version: "1.0.0",
      env: "production",
    }),
  },
});
```

Static responses do not allocate additional memory after initialization. You can generally expect at least a 15% performance improvement over manually returning a `Response` object.

Static route responses are cached for the lifetime of the server object. To reload static routes, call `server.reload(options)`.

### File Responses vs Static Responses

When serving files in routes, there are two distinct behaviors depending on whether you buffer the file content or serve it directly:

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
Bun.serve({
  routes: {
    // Static route - content is buffered in memory at startup
    "/logo.png": new Response(await Bun.file("./logo.png").bytes()),

    // File route - content is read from filesystem on each request
    "/download.zip": new Response(Bun.file("./download.zip")),
  },
});
```

**Static routes** (`new Response(await file.bytes())`) buffer content in memory at startup:

* **Zero filesystem I/O** during requests - content served entirely from memory
* **ETag support** - Automatically generates and validates ETags for caching
* **If-None-Match** - Returns `304 Not Modified` when client ETag matches
* **No 404 handling** - Missing files cause startup errors, not runtime 404s
* **Memory usage** - Full file content stored in RAM
* **Best for**: Small static assets, API responses, frequently accessed files

**File routes** (`new Response(Bun.file(path))`) read from filesystem per request:

* **Filesystem reads** on each request - checks file existence and reads content
* **Built-in 404 handling** - Returns `404 Not Found` if file doesn't exist or becomes inaccessible
* **Last-Modified support** - Uses file modification time for `If-Modified-Since` headers
* **If-Modified-Since** - Returns `304 Not Modified` when file hasn't changed since client's cached version
* **Range request support** - Automatically handles partial content requests with `Content-Range` headers
* **Streaming transfers** - Uses buffered reader with backpressure handling for efficient memory usage
* **Memory efficient** - Only buffers small chunks during transfer, not entire file
* **Best for**: Large files, dynamic content, user uploads, files that change frequently

***

## Streaming files

To stream a file, return a `Response` object with a `BunFile` object as the body.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
Bun.serve({
  fetch(req) {
    return new Response(Bun.file("./hello.txt"));
  },
});
```

<Info>
  ⚡️ **Speed** — Bun automatically uses the [`sendfile(2)`](https://man7.org/linux/man-pages/man2/sendfile.2.html)
  system call when possible, enabling zero-copy file transfers in the kernel—the fastest way to send files.
</Info>

You can send part of a file using the [`slice(start, end)`](https://developer.mozilla.org/en-US/docs/Web/API/Blob/slice) method on the `Bun.file` object. This automatically sets the `Content-Range` and `Content-Length` headers on the `Response` object.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
Bun.serve({
  fetch(req) {
    // parse `Range` header
    const [start = 0, end = Infinity] = req.headers
      .get("Range") // Range: bytes=0-100
      .split("=") // ["Range: bytes", "0-100"]
      .at(-1) // "0-100"
      .split("-") // ["0", "100"]
      .map(Number); // [0, 100]

    // return a slice of the file
    const bigFile = Bun.file("./big-video.mp4");
    return new Response(bigFile.slice(start, end));
  },
});
```

***

## `fetch` request handler

The `fetch` handler handles incoming requests that weren't matched by any route. It receives a [`Request`](https://developer.mozilla.org/en-US/docs/Web/API/Request) object and returns a [`Response`](https://developer.mozilla.org/en-US/docs/Web/API/Response) or [`Promise<Response>`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise).

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
Bun.serve({
  fetch(req) {
    const url = new URL(req.url);
    if (url.pathname === "/") return new Response("Home page!");
    if (url.pathname === "/blog") return new Response("Blog!");
    return new Response("404!");
  },
});
```

The `fetch` handler supports async/await:

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
import { sleep, serve } from "bun";

serve({
  async fetch(req) {
    const start = performance.now();
    await sleep(10);
    const end = performance.now();
    return new Response(`Slept for ${end - start}ms`);
  },
});
```

Promise-based responses are also supported:

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
Bun.serve({
  fetch(req) {
    // Forward the request to another server.
    return fetch("https://example.com");
  },
});
```

You can also access the `Server` object from the `fetch` handler. It's the second argument passed to the `fetch` function.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
// `server` is passed in as the second argument to `fetch`.
const server = Bun.serve({
  fetch(req, server) {
    const ip = server.requestIP(req);
    return new Response(`Your IP is ${ip.address}`);
  },
});
```


# Server
Source: https://bun.com/docs/runtime/http/server

Use `Bun.serve` to start a high-performance HTTP server in Bun

## Basic Setup

```ts title="index.ts" icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
const server = Bun.serve({
  // `routes` requires Bun v1.2.3+
  routes: {
    // Static routes
    "/api/status": new Response("OK"),

    // Dynamic routes
    "/users/:id": req => {
      return new Response(`Hello User ${req.params.id}!`);
    },

    // Per-HTTP method handlers
    "/api/posts": {
      GET: () => new Response("List posts"),
      POST: async req => {
        const body = await req.json();
        return Response.json({ created: true, ...body });
      },
    },

    // Wildcard route for all routes that start with "/api/" and aren't otherwise matched
    "/api/*": Response.json({ message: "Not found" }, { status: 404 }),

    // Redirect from /blog/hello to /blog/hello/world
    "/blog/hello": Response.redirect("/blog/hello/world"),

    // Serve a file by lazily loading it into memory
    "/favicon.ico": Bun.file("./favicon.ico"),
  },

  // (optional) fallback for unmatched routes:
  // Required if Bun's version < 1.2.3
  fetch(req) {
    return new Response("Not Found", { status: 404 });
  },
});

console.log(`Server running at ${server.url}`);
```

***

## HTML imports

Bun supports importing HTML files directly into your server code, enabling full-stack applications with both server-side and client-side code. HTML imports work in two modes:

**Development (`bun --hot`):** Assets are bundled on-demand at runtime, enabling hot module replacement (HMR) for a fast, iterative development experience. When you change your frontend code, the browser automatically updates without a full page reload.

**Production (`bun build`):** When building with `bun build --target=bun`, the `import index from "./index.html"` statement resolves to a pre-built manifest object containing all bundled client assets. `Bun.serve` consumes this manifest to serve optimized assets with zero runtime bundling overhead. This is ideal for deploying to production.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
import myReactSinglePageApp from "./index.html";

Bun.serve({
  routes: {
    "/": myReactSinglePageApp,
  },
});
```

HTML imports don't just serve HTML — it's a full-featured frontend bundler, transpiler, and toolkit built using Bun's [bundler](/bundler), JavaScript transpiler and CSS parser. You can use this to build full-featured frontends with React, TypeScript, Tailwind CSS, and more.

For a complete guide on building full-stack applications with HTML imports, including detailed examples and best practices, see [/docs/bundler/fullstack](/bundler/fullstack).

***

## Configuration

### Changing the `port` and `hostname`

To configure which port and hostname the server will listen on, set `port` and `hostname` in the options object.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
Bun.serve({
  port: 8080, // defaults to $BUN_PORT, $PORT, $NODE_PORT otherwise 3000 // [!code ++]
  hostname: "mydomain.com", // defaults to "0.0.0.0" // [!code ++]
  fetch(req) {
    return new Response("404!");
  },
});
```

To randomly select an available port, set `port` to `0`.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
const server = Bun.serve({
  port: 0, // random port // [!code ++]
  fetch(req) {
    return new Response("404!");
  },
});

// server.port is the randomly selected port
console.log(server.port);
```

You can view the chosen port by accessing the `port` property on the server object, or by accessing the `url` property.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
console.log(server.port); // 3000
console.log(server.url); // http://localhost:3000
```

### Configuring a default port

Bun supports several options and environment variables to configure the default port. The default port is used when the `port` option is not set.

* `--port` CLI flag

```sh theme={"theme":{"light":"github-light","dark":"dracula"}}
bun --port=4002 server.ts
```

* `BUN_PORT` environment variable

```sh theme={"theme":{"light":"github-light","dark":"dracula"}}
BUN_PORT=4002 bun server.ts
```

* `PORT` environment variable

```sh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
PORT=4002 bun server.ts
```

* `NODE_PORT` environment variable

```sh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
NODE_PORT=4002 bun server.ts
```

***

## Unix domain sockets

To listen on a [unix domain socket](https://en.wikipedia.org/wiki/Unix_domain_socket), pass the `unix` option with the path to the socket.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
Bun.serve({
  unix: "/tmp/my-socket.sock", // path to socket
  fetch(req) {
    return new Response(`404!`);
  },
});
```

### Abstract namespace sockets

Bun supports Linux abstract namespace sockets. To use an abstract namespace socket, prefix the `unix` path with a null byte.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
Bun.serve({
  unix: "\0my-abstract-socket", // abstract namespace socket
  fetch(req) {
    return new Response(`404!`);
  },
});
```

Unlike unix domain sockets, abstract namespace sockets are not bound to the filesystem and are automatically removed when the last reference to the socket is closed.

***

## idleTimeout

To configure the idle timeout, set the `idleTimeout` field in Bun.serve.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
Bun.serve({
  // 10 seconds:
  idleTimeout: 10,

  fetch(req) {
    return new Response("Bun!");
  },
});
```

This is the maximum amount of time a connection is allowed to be idle before the server closes it. A connection is idling if there is no data sent or received.

***

## export default syntax

Thus far, the examples on this page have used the explicit `Bun.serve` API. Bun also supports an alternate syntax.

```ts server.ts theme={"theme":{"light":"github-light","dark":"dracula"}}
import type { Serve } from "bun";

export default {
  fetch(req) {
    return new Response("Bun!");
  },
} satisfies Serve.Options<undefined>;
```

The type parameter `<undefined>` represents WebSocket data — if you add a `websocket` handler with custom data attached via `server.upgrade(req, { data: ... })`, replace `undefined` with your data type.

Instead of passing the server options into `Bun.serve`, `export default` it. This file can be executed as-is; when Bun sees a file with a `default` export containing a `fetch` handler, it passes it into `Bun.serve` under the hood.

***

## Hot Route Reloading

Update routes without server restarts using `server.reload()`:

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
const server = Bun.serve({
  routes: {
    "/api/version": () => Response.json({ version: "1.0.0" }),
  },
});

// Deploy new routes without downtime
server.reload({
  routes: {
    "/api/version": () => Response.json({ version: "2.0.0" }),
  },
});
```

***

## Server Lifecycle Methods

### `server.stop()`

To stop the server from accepting new connections:

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
const server = Bun.serve({
  fetch(req) {
    return new Response("Hello!");
  },
});

// Gracefully stop the server (waits for in-flight requests)
await server.stop();

// Force stop and close all active connections
await server.stop(true);
```

By default, `stop()` allows in-flight requests and WebSocket connections to complete. Pass `true` to immediately terminate all connections.

### `server.ref()` and `server.unref()`

Control whether the server keeps the Bun process alive:

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
// Don't keep process alive if server is the only thing running
server.unref();

// Restore default behavior - keep process alive
server.ref();
```

### `server.reload()`

Update the server's handlers without restarting:

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
const server = Bun.serve({
  routes: {
    "/api/version": Response.json({ version: "v1" }),
  },
  fetch(req) {
    return new Response("v1");
  },
});

// Update to new handler
server.reload({
  routes: {
    "/api/version": Response.json({ version: "v2" }),
  },
  fetch(req) {
    return new Response("v2");
  },
});
```

This is useful for development and hot reloading. Only `fetch`, `error`, and `routes` can be updated.

***

## Per-Request Controls

### `server.timeout(Request, seconds)`

Set a custom idle timeout for individual requests:

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
const server = Bun.serve({
  async fetch(req, server) {
    // Set 60 second timeout for this request
    server.timeout(req, 60);

    // If they take longer than 60 seconds to send the body, the request will be aborted
    await req.text();

    return new Response("Done!");
  },
});
```

Pass `0` to disable the timeout for a request.

### `server.requestIP(Request)`

Get client IP and port information:

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
const server = Bun.serve({
  fetch(req, server) {
    const address = server.requestIP(req);
    if (address) {
      return new Response(`Client IP: ${address.address}, Port: ${address.port}`);
    }
    return new Response("Unknown client");
  },
});
```

Returns `null` for closed requests or Unix domain sockets.

***

## Server Metrics

### `server.pendingRequests` and `server.pendingWebSockets`

Monitor server activity with built-in counters:

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
const server = Bun.serve({
  fetch(req, server) {
    return new Response(
      `Active requests: ${server.pendingRequests}\n` + `Active WebSockets: ${server.pendingWebSockets}`,
    );
  },
});
```

### `server.subscriberCount(topic)`

Get count of subscribers for a WebSocket topic:

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
const server = Bun.serve({
  fetch(req, server) {
    const chatUsers = server.subscriberCount("chat");
    return new Response(`${chatUsers} users in chat`);
  },
  websocket: {
    message(ws) {
      ws.subscribe("chat");
    },
  },
});
```

***

## Benchmarks

Below are Bun and Node.js implementations of a simple HTTP server that responds `Bun!` to each incoming `Request`.

```ts Bun theme={"theme":{"light":"github-light","dark":"dracula"}}
Bun.serve({
  fetch(req: Request) {
    return new Response("Bun!");
  },
  port: 3000,
});
```

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
require("http")
  .createServer((req, res) => res.end("Bun!"))
  .listen(8080);
```

The `Bun.serve` server can handle roughly 2.5x more requests per second than Node.js on Linux.

| Runtime | Requests per second |
| ------- | ------------------- |
| Node 16 | \~64,000            |
| Bun     | \~160,000           |

<Frame>
  ![image](https://user-images.githubusercontent.com/709451/162389032-fc302444-9d03-46be-ba87-c12bd8ce89a0.png)
</Frame>

***

## Practical example: REST API

Here's a basic database-backed REST API using Bun's router with zero dependencies:

<CodeGroup>
  ```ts server.ts expandable icon="file-code" theme={"theme":{"light":"github-light","dark":"dracula"}}
  import type { Post } from "./types.ts";
  import { Database } from "bun:sqlite";

  const db = new Database("posts.db");
  db.exec(`
    CREATE TABLE IF NOT EXISTS posts (
      id TEXT PRIMARY KEY,
      title TEXT NOT NULL,
      content TEXT NOT NULL,
      created_at TEXT NOT NULL
    )
  `);

  Bun.serve({
    routes: {
      // List posts
      "/api/posts": {
        GET: () => {
          const posts = db.query("SELECT * FROM posts").all();
          return Response.json(posts);
        },

        // Create post
        POST: async req => {
          const post: Omit<Post, "id" | "created_at"> = await req.json();
          const id = crypto.randomUUID();

          db.query(
            `INSERT INTO posts (id, title, content, created_at)
             VALUES (?, ?, ?, ?)`,
          ).run(id, post.title, post.content, new Date().toISOString());

          return Response.json({ id, ...post }, { status: 201 });
        },
      },

      // Get post by ID
      "/api/posts/:id": req => {
        const post = db.query("SELECT * FROM posts WHERE id = ?").get(req.params.id);

        if (!post) {
          return new Response("Not Found", { status: 404 });
        }

        return Response.json(post);
      },
    },

    error(error) {
      console.error(error);
      return new Response("Internal Server Error", { status: 500 });
    },
  });
  ```

  ```ts types.ts icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
  export interface Post {
    id: string;
    title: string;
    content: string;
    created_at: string;
  }
  ```
</CodeGroup>

***

## Reference

```ts expandable See TypeScript Definitions theme={"theme":{"light":"github-light","dark":"dracula"}}
interface Server extends Disposable {
  /**
   * Stop the server from accepting new connections.
   * @param closeActiveConnections If true, immediately terminates all connections
   * @returns Promise that resolves when the server has stopped
   */
  stop(closeActiveConnections?: boolean): Promise<void>;

  /**
   * Update handlers without restarting the server.
   * Only fetch and error handlers can be updated.
   */
  reload(options: Serve): void;

  /**
   * Make a request to the running server.
   * Useful for testing or internal routing.
   */
  fetch(request: Request | string): Response | Promise<Response>;

  /**
   * Upgrade an HTTP request to a WebSocket connection.
   * @returns true if upgrade successful, false if failed
   */
  upgrade<T = undefined>(
    request: Request,
    options?: {
      headers?: Bun.HeadersInit;
      data?: T;
    },
  ): boolean;

  /**
   * Publish a message to all WebSocket clients subscribed to a topic.
   * @returns Bytes sent, 0 if dropped, -1 if backpressure applied
   */
  publish(
    topic: string,
    data: string | ArrayBufferView | ArrayBuffer | SharedArrayBuffer,
    compress?: boolean,
  ): ServerWebSocketSendStatus;

  /**
   * Get count of WebSocket clients subscribed to a topic.
   */
  subscriberCount(topic: string): number;

  /**
   * Get client IP address and port.
   * @returns null for closed requests or Unix sockets
   */
  requestIP(request: Request): SocketAddress | null;

  /**
   * Set custom idle timeout for a request.
   * @param seconds Timeout in seconds, 0 to disable
   */
  timeout(request: Request, seconds: number): void;

  /**
   * Keep process alive while server is running.
   */
  ref(): void;

  /**
   * Allow process to exit if server is only thing running.
   */
  unref(): void;

  /** Number of in-flight HTTP requests */
  readonly pendingRequests: number;

  /** Number of active WebSocket connections */
  readonly pendingWebSockets: number;

  /** Server URL including protocol, hostname and port */
  readonly url: URL;

  /** Port server is listening on */
  readonly port: number;

  /** Hostname server is bound to */
  readonly hostname: string;

  /** Whether server is in development mode */
  readonly development: boolean;

  /** Server instance identifier */
  readonly id: string;
}

interface WebSocketHandler<T = undefined> {
  /** Maximum WebSocket message size in bytes */
  maxPayloadLength?: number;

  /** Bytes of queued messages before applying backpressure */
  backpressureLimit?: number;

  /** Whether to close connection when backpressure limit hit */
  closeOnBackpressureLimit?: boolean;

  /** Called when backpressure is relieved */
  drain?(ws: ServerWebSocket<T>): void | Promise<void>;

  /** Seconds before idle timeout */
  idleTimeout?: number;

  /** Enable per-message deflate compression */
  perMessageDeflate?:
    | boolean
    | {
        compress?: WebSocketCompressor | boolean;
        decompress?: WebSocketCompressor | boolean;
      };

  /** Send ping frames to keep connection alive */
  sendPings?: boolean;

  /** Whether server receives its own published messages */
  publishToSelf?: boolean;

  /** Called when connection opened */
  open?(ws: ServerWebSocket<T>): void | Promise<void>;

  /** Called when message received */
  message(ws: ServerWebSocket<T>, message: string | Buffer): void | Promise<void>;

  /** Called when connection closed */
  close?(ws: ServerWebSocket<T>, code: number, reason: string): void | Promise<void>;

  /** Called when ping frame received */
  ping?(ws: ServerWebSocket<T>, data: Buffer): void | Promise<void>;

  /** Called when pong frame received */
