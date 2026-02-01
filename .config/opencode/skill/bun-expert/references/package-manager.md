# Add a dependency
Source: https://bun.com/docs/guides/install/add



To add an npm package as a dependency, use `bun add`.

```sh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun add zod
```

***

This will add the package to `dependencies` in `package.json`. By default, the `^` range specifier will be used, to indicate that any future minor or patch versions are acceptable.

```json package.json icon="file-json" theme={"theme":{"light":"github-light","dark":"dracula"}}
{
  "dependencies": {
    "zod": "^3.0.0" // [!code ++]
  }
}
```

***

To "pin" to an exact version of the package, use `--exact`. This will add the package to `dependencies` without the `^`, pinning your project to the exact version you installed.

```sh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun add zod --exact
```

***

To specify an exact version or a tag:

```sh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun add zod@3.0.0
bun add zod@next
```

***

See [Docs > Package manager](/pm/cli/install) for complete documentation of Bun's package manager.


# Add a development dependency
Source: https://bun.com/docs/guides/install/add-dev



To add an npm package as a development dependency, use `bun add --development`.

```sh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun add zod --dev
bun add zod -d # shorthand
```

***

This will add the package to `devDependencies` in `package.json`.

```json theme={"theme":{"light":"github-light","dark":"dracula"}}
{
  "devDependencies": {
    "zod": "^3.0.0" // [!code ++]
  }
}
```

***

See [Docs > Package manager](/pm/cli/install) for complete documentation of Bun's package manager.


# Add a Git dependency
Source: https://bun.com/docs/guides/install/add-git



Bun supports directly adding GitHub repositories as dependencies of your project.

```sh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun add github:lodash/lodash
```

***

This will add the following line to your `package.json`:

```json package.json icon="file-json" theme={"theme":{"light":"github-light","dark":"dracula"}}
{
  "dependencies": {
    "lodash": "github:lodash/lodash"
  }
}
```

***

Bun supports a number of protocols for specifying Git dependencies.

```sh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun add git+https://github.com/lodash/lodash.git
bun add git+ssh://github.com/lodash/lodash.git#4.17.21
bun add git@github.com:lodash/lodash.git
bun add github:colinhacks/zod
```

**Note:** GitHub dependencies download via HTTP tarball when possible for faster installation.

***

See [Docs > Package manager](/pm/cli/install) for complete documentation of Bun's package manager.


# Add an optional dependency
Source: https://bun.com/docs/guides/install/add-optional



To add an npm package as an optional dependency, use the `--optional` flag.

```sh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun add zod --optional
```

***

This will add the package to `optionalDependencies` in `package.json`.

```json package.json icon="file-json" theme={"theme":{"light":"github-light","dark":"dracula"}}
{
  "optionalDependencies": {
    "zod": "^3.0.0" // [!code ++]
  }
}
```

***

See [Docs > Package manager](/pm/cli/install) for complete documentation of Bun's package manager.


# Add a peer dependency
Source: https://bun.com/docs/guides/install/add-peer



To add an npm package as a peer dependency, use the `--peer` flag.

```sh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun add @types/bun --peer
```

***

This will add the package to `peerDependencies` in `package.json`.

```json package.json icon="file-json" theme={"theme":{"light":"github-light","dark":"dracula"}}
{
  "peerDependencies": {
    "@types/bun": "^1.3.3" // [!code ++]
  }
}
```

***

Running `bun install` will install peer dependencies by default, unless marked optional in `peerDependenciesMeta`.

```json package.json icon="file-json" theme={"theme":{"light":"github-light","dark":"dracula"}}
{
  "peerDependencies": {
    "@types/bun": "^1.3.3"
  },
  "peerDependenciesMeta": {
    "@types/bun": { // [!code ++]
      "optional": true // [!code ++]
    } // [!code ++]
  }
}
```

***

See [Docs > Package manager](/pm/cli/install) for complete documentation of Bun's package manager.


# Add a tarball dependency
Source: https://bun.com/docs/guides/install/add-tarball



Bun's package manager can install any publicly available tarball URL as a dependency of your project.

```sh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun add zod@https://registry.npmjs.org/zod/-/zod-3.21.4.tgz
```

***

Running this command will download, extract, and install the tarball to your project's `node_modules` directory. It will also add the following line to your `package.json`:

```json package.json icon="file-json" theme={"theme":{"light":"github-light","dark":"dracula"}}
{
  "dependencies": {
    "zod": "https://registry.npmjs.org/zod/-/zod-3.21.4.tgz" // [!code ++]
  }
}
```

***

The package `"zod"` can now be imported as usual.

```ts theme={"theme":{"light":"github-light","dark":"dracula"}}
import { z } from "zod";
```

***

See [Docs > Package manager](/pm/cli/install) for complete documentation of Bun's package manager.


# Using bun install with an Azure Artifacts npm registry
Source: https://bun.com/docs/guides/install/azure-artifacts



<Note>
  In [Azure
  Artifact's](https://learn.microsoft.com/en-us/azure/devops/artifacts/npm/npmrc?view=azure-devops\&tabs=windows%2Cclassic)
  instructions for `.npmrc`, they say to base64 encode the password. Do not do this for `bun install`. Bun will
  automatically base64 encode the password for you if needed.
</Note>

[Azure Artifacts](https://azure.microsoft.com/en-us/products/devops/artifacts) is a package management system for Azure DevOps. It allows you to host your own private npm registry, npm packages, and other types of packages as well.

***

### Configure with bunfig.toml

***

To use it with `bun install`, add a `bunfig.toml` file to your project with the following contents. Make sure to replace `my-azure-artifacts-user` with your Azure Artifacts username, such as `jarred1234`.

```toml bunfig.toml icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
[install.registry]
url = "https://pkgs.dev.azure.com/my-azure-artifacts-user/_packaging/my-azure-artifacts-user/npm/registry"
username = "my-azure-artifacts-user"
# You can use an environment variable here
password = "$NPM_PASSWORD"
```

***

Then assign your Azure Personal Access Token to the `NPM_PASSWORD` environment variable. Bun [automatically reads](/runtime/environment-variables) `.env` files, so create a file called `.env` in your project root. There is no need to base-64 encode this token! Bun will do this for you.

```ini .env icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
NPM_PASSWORD=<paste token here>
```

***

### Configure with environment variables

***

To configure Azure Artifacts without `bunfig.toml`, you can set the `NPM_CONFIG_REGISTRY` environment variable. The URL should include `:username` and `:_password` as query parameters. Replace `<USERNAME>` and `<PASSWORD>` with the appropriate values.

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
NPM_CONFIG_REGISTRY=https://pkgs.dev.azure.com/my-azure-artifacts-user/_packaging/my-azure-artifacts-user/npm/registry/:username=<USERNAME>:_password=<PASSWORD>
```

***

### Don't base64 encode the password

***

In [Azure Artifact's](https://learn.microsoft.com/en-us/azure/devops/artifacts/npm/npmrc?view=azure-devops\&tabs=windows%2Cclassic) instructions for `.npmrc`, they say to base64 encode the password. Do not do this for `bun install`. Bun will automatically base64 encode the password for you if needed.

<Note>**Tip** — If it ends with `==`, it probably is base64 encoded.</Note>

***

To decode a base64-encoded password, open your browser console and run:

```js browser icon="computer" theme={"theme":{"light":"github-light","dark":"dracula"}}
atob("<base64-encoded password>");
```

***

Alternatively, use the `base64` command line tool, but doing so means it may be saved in your terminal history which is not recommended:

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
echo "base64-encoded-password" | base64 --decode
```


# Install dependencies with Bun in GitHub Actions
Source: https://bun.com/docs/guides/install/cicd



Use the official [`setup-bun`](https://github.com/oven-sh/setup-bun) GitHub Action to install `bun` in your GitHub Actions runner.

```yaml workflow.yml icon="file-code" theme={"theme":{"light":"github-light","dark":"dracula"}}
title: my-workflow
jobs:
  my-job:
    title: my-job
    runs-on: ubuntu-latest
    steps:
      # ...
      - uses: actions/checkout@v4
      - uses: oven-sh/setup-bun@v2 // [!code ++]

      # run any `bun` or `bunx` command
      - run: bun install // [!code ++]
```

***

To specify a version of Bun to install:

```yaml workflow.yml icon="file-code" theme={"theme":{"light":"github-light","dark":"dracula"}}
title: my-workflow
jobs:
  my-job:
    title: my-job
    runs-on: ubuntu-latest
    steps:
      # ...
      - uses: oven-sh/setup-bun@v2
         with: # [!code ++]
          version: "latest" # or "canary" # [!code ++]
```

***

Refer to the [README.md](https://github.com/oven-sh/setup-bun) for complete documentation of the `setup-bun` GitHub Action.


# Override the default npm registry for bun install
Source: https://bun.com/docs/guides/install/custom-registry



The default registry is `registry.npmjs.org`. This can be globally configured in `bunfig.toml`.

```toml bunfig.toml icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
[install]
# set default registry as a string
registry = "https://registry.npmjs.org"

# if needed, set a token
registry = { url = "https://registry.npmjs.org", token = "123456" }

# if needed, set a username/password
registry = "https://usertitle:password@registry.npmjs.org"
```

***

Your `bunfig.toml` can reference environment variables. Bun automatically loads environment variables from `.env.local`, `.env.[NODE_ENV]`, and `.env`. See [Docs > Environment variables](/runtime/environment-variables) for more information.

```toml bunfig.toml icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
[install]
registry = { url = "https://registry.npmjs.org", token = "$npm_token" }
```

***

See [Docs > Package manager](/pm/cli/install) for complete documentation of Bun's package manager.


# bun add
Source: https://bun.com/docs/pm/cli/add

Add packages to your project with Bun's fast package manager

To add a particular package:

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun add preact
```

To specify a version, version range, or tag:

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun add zod@3.20.0
bun add zod@^3.0.0
bun add zod@latest
```

## `--dev`

<Note>**Alias** — `--development`, `-d`, `-D`</Note>

To add a package as a dev dependency (`"devDependencies"`):

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun add --dev @types/react
bun add -d @types/react
```

## `--optional`

To add a package as an optional dependency (`"optionalDependencies"`):

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun add --optional lodash
```

## `--peer`

To add a package as a peer dependency (`"peerDependencies"`):

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun add --peer @types/bun
```

## `--exact`

<Note>**Alias** — `-E`</Note>

To add a package and pin to the resolved version, use `--exact`. This will resolve the version of the package and add it to your `package.json` with an exact version number instead of a version range.

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun add react --exact
bun add react -E
```

This will add the following to your `package.json`:

```json package.json icon="file-json" theme={"theme":{"light":"github-light","dark":"dracula"}}
{
  "dependencies": {
    // without --exact
    "react": "^18.2.0", // this matches >= 18.2.0 < 19.0.0

    // with --exact
    "react": "18.2.0" // this matches only 18.2.0 exactly
  }
}
```

To view a complete list of options for this command:

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun add --help
```

## `--global`

<Note>
  **Note** — This would not modify package.json of your current project folder. **Alias** - `bun add --global`, `bun add
      -g`, `bun install --global` and `bun install -g`
</Note>

To install a package globally, use the `-g`/`--global` flag. This will not modify the `package.json` of your current project. Typically this is used for installing command-line tools.

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun add --global cowsay # or `bun add -g cowsay`
cowsay "Bun!"
```

```txt theme={"theme":{"light":"github-light","dark":"dracula"}}
 ______
< Bun! >
 ------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```

<Accordion title="Configuring global installation behavior">
  ```toml bunfig.toml icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
  [install]
  # where `bun add --global` installs packages
  globalDir = "~/.bun/install/global"

  # where globally-installed package bins are linked
  globalBinDir = "~/.bun/bin"
  ```
</Accordion>

## Trusted dependencies

Unlike other npm clients, Bun does not execute arbitrary lifecycle scripts for installed dependencies, such as `postinstall`. These scripts represent a potential security risk, as they can execute arbitrary code on your machine.

To tell Bun to allow lifecycle scripts for a particular package, add the package to `trustedDependencies` in your package.json.

```json package.json icon="file-json" theme={"theme":{"light":"github-light","dark":"dracula"}}
{
  "name": "my-app",
  "version": "1.0.0",
  "trustedDependencies": ["my-trusted-package"] // [!code ++]
}
```

Bun reads this field and will run lifecycle scripts for `my-trusted-package`.

## Git dependencies

To add a dependency from a public or private git repository:

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun add git@github.com:moment/moment.git
```

<Note>
  To install private repositories, your system needs the appropriate SSH credentials to access the repository.
</Note>

Bun supports a variety of protocols, including [`github`](https://docs.npmjs.com/cli/v9/configuring-npm/package-json#github-urls), [`git`](https://docs.npmjs.com/cli/v9/configuring-npm/package-json#git-urls-as-dependencies), `git+ssh`, `git+https`, and many more.

```json package.json icon="file-json" theme={"theme":{"light":"github-light","dark":"dracula"}}
{
  "dependencies": {
    "dayjs": "git+https://github.com/iamkun/dayjs.git",
    "lodash": "git+ssh://github.com/lodash/lodash.git#4.17.21",
    "moment": "git@github.com:moment/moment.git",
    "zod": "github:colinhacks/zod"
  }
}
```

## Tarball dependencies

A package name can correspond to a publicly hosted `.tgz` file. During installation, Bun will download and install the package from the specified tarball URL, rather than from the package registry.

```sh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun add zod@https://registry.npmjs.org/zod/-/zod-3.21.4.tgz
```

This will add the following line to your `package.json`:

```json package.json icon="file-json" theme={"theme":{"light":"github-light","dark":"dracula"}}
{
  "dependencies": {
    "zod": "https://registry.npmjs.org/zod/-/zod-3.21.4.tgz"
  }
}
```

***

## CLI Usage

```bash theme={"theme":{"light":"github-light","dark":"dracula"}}
bun add <package> <@version>
```

### Dependency Management

<ParamField type="boolean">
  Don't install devDependencies. Alias: <code>-p</code>
</ParamField>

<ParamField type="string">
  Exclude <code>dev</code>, <code>optional</code>, or <code>peer</code> dependencies from install
</ParamField>

<ParamField type="boolean">
  Install globally. Alias: <code>-g</code>
</ParamField>

<ParamField type="boolean">
  Add dependency to <code>devDependencies</code>. Alias: <code>-d</code>
</ParamField>

<ParamField type="boolean">
  Add dependency to <code>optionalDependencies</code>
</ParamField>

<ParamField type="boolean">
  Add dependency to <code>peerDependencies</code>
</ParamField>

<ParamField type="boolean">
  Add the exact version instead of the <code>^</code> range. Alias: <code>-E</code>
</ParamField>

<ParamField type="boolean">
  Only add dependencies to <code>package.json</code> if they are not already present
</ParamField>

### Project Files & Lockfiles

<ParamField type="boolean">
  Write a <code>yarn.lock</code> file (yarn v1). Alias: <code>-y</code>
</ParamField>

<ParamField type="boolean">
  Don't update <code>package.json</code> or save a lockfile
</ParamField>

<ParamField type="boolean">
  Save to <code>package.json</code> (true by default)
</ParamField>

<ParamField type="boolean">
  Disallow changes to lockfile
</ParamField>

<ParamField type="boolean">
  Add to <code>trustedDependencies</code> in the project's <code>package.json</code> and install the package(s)
</ParamField>

<ParamField type="boolean">
  Save a text-based lockfile
</ParamField>

<ParamField type="boolean">
  Generate a lockfile without installing dependencies
</ParamField>

### Installation Control

<ParamField type="boolean">
  Don't install anything
</ParamField>

<ParamField type="boolean">
  Always request the latest versions from the registry & reinstall all dependencies. Alias: <code>-f</code>
</ParamField>

<ParamField type="boolean">
  Skip verifying integrity of newly downloaded packages
</ParamField>

<ParamField type="boolean">
  Skip lifecycle scripts in the project's <code>package.json</code> (dependency scripts are never run)
</ParamField>

<ParamField type="boolean">
  Recursively analyze & install dependencies of files passed as arguments (using Bun's bundler). Alias:
  <code>-a</code>
</ParamField>

### Network & Registry

<ParamField type="string">
  Provide a Certificate Authority signing certificate
</ParamField>

<ParamField type="string">
  Same as <code>--ca</code>, but as a file path to the certificate
</ParamField>

<ParamField type="string">
  Use a specific registry by default, overriding <code>.npmrc</code>, <code>bunfig.toml</code>, and environment
  variables
</ParamField>

<ParamField type="number">
  Maximum number of concurrent network requests (default 48)
</ParamField>

### Performance & Resource

<ParamField type="string">
  Platform-specific optimizations for installing dependencies. Possible values: <code>clonefile</code> (default),
  <code>hardlink</code>, <code>symlink</code>, <code>copyfile</code>
</ParamField>

<ParamField type="number">
  Maximum number of concurrent jobs for lifecycle scripts (default 5)
</ParamField>

### Caching

<ParamField type="string">
  Store & load cached data from a specific directory path
</ParamField>

<ParamField type="boolean">
  Ignore manifest cache entirely
</ParamField>

### Output & Logging

<ParamField type="boolean">
  Don't log anything
</ParamField>

<ParamField type="boolean">
  Excessively verbose logging
</ParamField>

<ParamField type="boolean">
  Disable the progress bar
</ParamField>

<ParamField type="boolean">
  Don't print a summary
</ParamField>

### Global Configuration & Context

<ParamField type="string">
  Specify path to config file (<code>bunfig.toml</code>). Alias: <code>-c</code>
</ParamField>

<ParamField type="string">
  Set a specific current working directory
</ParamField>

### Help

<ParamField type="boolean">
  Print this help menu. Alias: <code>-h</code>
</ParamField>


# bun audit
Source: https://bun.com/docs/pm/cli/audit

Check your installed packages for known security vulnerabilities

Run the command in a project with a `bun.lock` file:

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun audit
```

Bun sends the list of installed packages and versions to NPM, and prints a report of any vulnerabilities that were found. Packages installed from registries other than the default registry are skipped.

If no vulnerabilities are found, the command prints:

```
No vulnerabilities found
```

When vulnerabilities are detected, each affected package is listed along with the severity, a short description and a link to the advisory. At the end of the report Bun prints a summary and hints for updating:

```
3 vulnerabilities (1 high, 2 moderate)
To update all dependencies to the latest compatible versions:
  bun update
To update all dependencies to the latest versions (including breaking changes):
  bun update --latest
```

### Filtering options

**`--audit-level=<low|moderate|high|critical>`** - Only show vulnerabilities at this severity level or higher:

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun audit --audit-level=high
```

**`--prod`** - Audit only production dependencies (excludes devDependencies):

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun audit --prod
```

**`--ignore <CVE>`** - Ignore specific CVEs (can be used multiple times):

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun audit --ignore CVE-2022-25883 --ignore CVE-2023-26136
```

### `--json`

Use the `--json` flag to print the raw JSON response from the registry instead of the formatted report:

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun audit --json
```

### Exit code

`bun audit` will exit with code `0` if no vulnerabilities are found and `1` if the report lists any vulnerabilities. This will still happen even if `--json` is passed.


# bun info
Source: https://bun.com/docs/pm/cli/info

Display package metadata from the npm registry

`bun info` displays package metadata from the npm registry.

## Usage

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun info react
```

This will display information about the `react` package, including its latest version, description, homepage, dependencies, and more.

## Viewing specific versions

To view information about a specific version:

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun info react@18.0.0
```

## Viewing specific properties

You can also query specific properties from the package metadata:

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun info react version
bun info react dependencies
bun info react repository.url
```

## JSON output

To get the output in JSON format, use the `--json` flag:

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun info react --json
```

## Alias

`bun pm view` is an alias for `bun info`:

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun pm view react  # equivalent to: bun info react
```

## Examples

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
# View basic package information
bun info is-number

# View a specific version
bun info is-number@7.0.0

# View all available versions
bun info is-number versions

# View package dependencies
bun info express dependencies

# View package homepage
bun info lodash homepage

# Get JSON output
bun info react --json
```


# bun install
Source: https://bun.com/docs/pm/cli/install

Install packages with Bun's fast package manager

## Basic Usage

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun install react
bun install react@19.1.1 # specific version
bun install react@latest # specific tag
```

The `bun` CLI contains a Node.js-compatible package manager designed to be a dramatically faster replacement for `npm`, `yarn`, and `pnpm`. It's a standalone tool that will work in pre-existing Node.js projects; if your project has a `package.json`, `bun install` can help you speed up your workflow.

<Note>
  **⚡️ 25x faster** — Switch from `npm install` to `bun install` in any Node.js project to make your installations up to 25x faster.

  <Frame>
    ![Bun installation speed
    comparison](https://user-images.githubusercontent.com/709451/147004342-571b6123-17a9-49a2-8bfd-dcfc5204047e.png)
  </Frame>
</Note>

To install all dependencies of a project:

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun install
```

Running `bun install` will:

* **Install** all `dependencies`, `devDependencies`, and `optionalDependencies`. Bun will install `peerDependencies` by default.
* **Run** your project's `{pre|post}install` and `{pre|post}prepare` scripts at the appropriate time. For security reasons Bun *does not execute* lifecycle scripts of installed dependencies.
* **Write** a `bun.lock` lockfile to the project root.

***

## Logging

To modify logging verbosity:

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun install --verbose # debug logging
bun install --silent  # no logging
```

***

## Lifecycle scripts

Unlike other npm clients, Bun does not execute arbitrary lifecycle scripts like `postinstall` for installed dependencies. Executing arbitrary scripts represents a potential security risk.

To tell Bun to allow lifecycle scripts for a particular package, add the package to `trustedDependencies` in your package.json.

```json package.json icon="file-json" theme={"theme":{"light":"github-light","dark":"dracula"}}
{
  "name": "my-app",
  "version": "1.0.0",
  "trustedDependencies": ["my-trusted-package"] // [!code ++]
}
```

Then re-install the package. Bun will read this field and run lifecycle scripts for `my-trusted-package`.

Lifecycle scripts will run in parallel during installation. To adjust the maximum number of concurrent scripts, use the `--concurrent-scripts` flag. The default is two times the reported cpu count or GOMAXPROCS.

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun install --concurrent-scripts 5
```

Bun automatically optimizes postinstall scripts for popular packages (like `esbuild`, `sharp`, etc.) by determining which scripts need to run. To disable these optimizations:

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
BUN_FEATURE_FLAG_DISABLE_NATIVE_DEPENDENCY_LINKER=1 bun install
BUN_FEATURE_FLAG_DISABLE_IGNORE_SCRIPTS=1 bun install
```

***

## Workspaces

Bun supports `"workspaces"` in package.json. For complete documentation refer to [Package manager > Workspaces](/pm/workspaces).

```json package.json icon="file-json" theme={"theme":{"light":"github-light","dark":"dracula"}}
{
  "name": "my-app",
  "version": "1.0.0",
  "workspaces": ["packages/*"], // [!code ++]
  "dependencies": {
    "preact": "^10.5.13"
  }
}
```

***

## Installing dependencies for specific packages

In a monorepo, you can install the dependencies for a subset of packages using the `--filter` flag.

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
# Install dependencies for all workspaces except `pkg-c`
bun install --filter '!pkg-c'

# Install dependencies for only `pkg-a` in `./packages/pkg-a`
bun install --filter './packages/pkg-a'
```

For more information on filtering with `bun install`, refer to [Package Manager > Filtering](/pm/filter#bun-install-and-bun-outdated)

***

## Overrides and resolutions

Bun supports npm's `"overrides"` and Yarn's `"resolutions"` in `package.json`. These are mechanisms for specifying a version range for *metadependencies*—the dependencies of your dependencies. Refer to [Package manager > Overrides and resolutions](/pm/overrides) for complete documentation.

```json package.json icon="file-json" theme={"theme":{"light":"github-light","dark":"dracula"}}
{
  "name": "my-app",
  "dependencies": {
    "foo": "^2.0.0"
  },
  "overrides": { // [!code ++]
    "bar": "~4.4.0" // [!code ++]
  } // [!code ++]
}
```

***

## Global packages

To install a package globally, use the `-g`/`--global` flag. Typically this is used for installing command-line tools.

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun install --global cowsay # or `bun install -g cowsay`
cowsay "Bun!"
```

```txt theme={"theme":{"light":"github-light","dark":"dracula"}}
 ______
< Bun! >
 ------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```

***

## Production mode

To install in production mode (i.e. without `devDependencies` or `optionalDependencies`):

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun install --production
```

For reproducible installs, use `--frozen-lockfile`. This will install the exact versions of each package specified in the lockfile. If your `package.json` disagrees with `bun.lock`, Bun will exit with an error. The lockfile will not be updated.

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun install --frozen-lockfile
```

For more information on Bun's lockfile `bun.lock`, refer to [Package manager > Lockfile](/pm/lockfile).

***

## Omitting dependencies

To omit dev, peer, or optional dependencies use the `--omit` flag.

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
# Exclude "devDependencies" from the installation. This will apply to the
# root package and workspaces if they exist. Transitive dependencies will
# not have "devDependencies".
bun install --omit dev

# Install only dependencies from "dependencies"
bun install --omit=dev --omit=peer --omit=optional
```

***

## Dry run

To perform a dry run (i.e. don't actually install anything):

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun install --dry-run
```

***
# Lockfile
Source: https://bun.com/docs/pm/lockfile

Bun's lockfile format and configuration

Running `bun install` will create a lockfile called `bun.lock`.

#### Should it be committed to git?

Yes

#### Generate a lockfile without installing?

To generate a lockfile without installing to `node_modules` you can use the `--lockfile-only` flag. The lockfile will always be saved to disk, even if it is up-to-date with the `package.json`(s) for your project.

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun install --lockfile-only
```

<Note>
  Using `--lockfile-only` will still populate the global install cache with registry metadata and git/tarball
  dependencies.
</Note>

#### Can I opt out?

To install without creating a lockfile:

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun install --no-save
```

To install a Yarn lockfile *in addition* to `bun.lock`.

<CodeGroup>
  ```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
  bun install --yarn
  ```

  ```toml bunfig.toml icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
  [install.lockfile]
  # whether to save a non-Bun lockfile alongside bun.lock
  # only "yarn" is supported
  print = "yarn"
  ```
</CodeGroup>

#### Text-based lockfile

Bun v1.2 changed the default lockfile format to the text-based `bun.lock`. Existing binary `bun.lockb` lockfiles can be migrated to the new format by running `bun install --save-text-lockfile --frozen-lockfile --lockfile-only` and deleting `bun.lockb`.

More information about the new lockfile format can be found on [our blogpost](https://bun.com/blog/bun-lock-text-lockfile).

#### Automatic lockfile migration

When running `bun install` in a project without a `bun.lock`, Bun automatically migrates existing lockfiles:

* `yarn.lock` (v1)
* `package-lock.json` (npm)
* `pnpm-lock.yaml` (pnpm)

The original lockfile is preserved and can be removed manually after verification.


# .npmrc support
Source: https://bun.com/docs/pm/npmrc



Bun supports loading configuration options from [`.npmrc`](https://docs.npmjs.com/cli/v10/configuring-npm/npmrc) files, allowing you to reuse existing registry/scope configurations.

<Note>
  We recommend migrating your `.npmrc` file to Bun's [`bunfig.toml`](/runtime/bunfig) format, as it provides more
  flexible options and can let you configure Bun-specific options.
</Note>

***

## Supported options

### Set the default registry

The default registry is used to resolve packages, its default value is `npm`'s official registry (`https://registry.npmjs.org/`).

To change it, you can set the `registry` option in `.npmrc`:

```ini .npmrc icon="npm" theme={"theme":{"light":"github-light","dark":"dracula"}}
registry=http://localhost:4873/
```

The equivalent `bunfig.toml` option is [`install.registry`](/runtime/bunfig#install-registry):

```toml bunfig.toml icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
install.registry = "http://localhost:4873/"
```

### Set the registry for a specific scope

`@<scope>:registry` allows you to set the registry for a specific scope:

```ini .npmrc icon="npm" theme={"theme":{"light":"github-light","dark":"dracula"}}
@myorg:registry=http://localhost:4873/
```

The equivalent `bunfig.toml` option is to add a key in [`install.scopes`](/runtime/bunfig#install-registry):

```toml bunfig.toml icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
[install.scopes]
myorg = "http://localhost:4873/"
```

### Configure options for a specific registry

`//<registry_url>/:<key>=<value>` allows you to set options for a specific registry:

```ini .npmrc icon="npm" theme={"theme":{"light":"github-light","dark":"dracula"}}
# set an auth token for the registry
# ${...} is a placeholder for environment variables
//http://localhost:4873/:_authToken=${NPM_TOKEN}


# or you could set a username and password
# note that the password is base64 encoded
//http://localhost:4873/:username=myusername

//http://localhost:4873/:_password=${NPM_PASSWORD}

# or use _auth, which is your username and password
# combined into a single string, which is then base 64 encoded
//http://localhost:4873/:_auth=${NPM_AUTH}
```

The following options are supported:

* `_authToken`
* `username`
* `_password` (base64 encoded password)
* `_auth` (base64 encoded username:password, e.g. `btoa(username + ":" + password)`)
* `email`

The equivalent `bunfig.toml` option is to add a key in [`install.scopes`](/runtime/bunfig#install-registry):

```toml bunfig.toml icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
[install.scopes]
myorg = { url = "http://localhost:4873/", username = "myusername", password = "$NPM_PASSWORD" }
```

### `link-workspace-packages`: Control workspace package installation

Controls how workspace packages are installed when available locally:

```ini .npmrc icon="npm" theme={"theme":{"light":"github-light","dark":"dracula"}}
link-workspace-packages=true
```

The equivalent `bunfig.toml` option is [`install.linkWorkspacePackages`](/runtime/bunfig#install-linkworkspacepackages):

```toml bunfig.toml icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
[install]
linkWorkspacePackages = true
```

### `save-exact`: Save exact versions

Always saves exact versions without the `^` prefix:

```ini .npmrc icon="npm" theme={"theme":{"light":"github-light","dark":"dracula"}}
save-exact=true
```

The equivalent `bunfig.toml` option is [`install.exact`](/runtime/bunfig#install-exact):

```toml bunfig.toml icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
[install]
exact = true
```

### `ignore-scripts`: Skip lifecycle scripts

Prevents running lifecycle scripts during installation:

```ini .npmrc icon="npm" theme={"theme":{"light":"github-light","dark":"dracula"}}
ignore-scripts=true
```

This is equivalent to using the `--ignore-scripts` flag with `bun install`.

### `dry-run`: Preview changes without installing

Shows what would be installed without actually installing:

```ini .npmrc icon="npm" theme={"theme":{"light":"github-light","dark":"dracula"}}
dry-run=true
```

The equivalent `bunfig.toml` option is [`install.dryRun`](/runtime/bunfig#install-dryrun):

```toml bunfig.toml icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
[install]
dryRun = true
```

### `cache`: Configure cache directory

Set the cache directory path, or disable caching:

```ini .npmrc icon="npm" theme={"theme":{"light":"github-light","dark":"dracula"}}
# set a custom cache directory
cache=/path/to/cache

# or disable caching
cache=false
```

The equivalent `bunfig.toml` option is [`install.cache`](/runtime/bunfig#install-cache):

```toml bunfig.toml icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
[install.cache]
# set a custom cache directory
dir = "/path/to/cache"

# or disable caching
disable = true
```

### `ca` and `cafile`: Configure CA certificates

Configure custom CA certificates for registry connections:

```ini .npmrc icon="npm" theme={"theme":{"light":"github-light","dark":"dracula"}}
# single CA certificate
ca="-----BEGIN CERTIFICATE-----\n...\n-----END CERTIFICATE-----"

# multiple CA certificates
ca[]="-----BEGIN CERTIFICATE-----\n...\n-----END CERTIFICATE-----"
ca[]="-----BEGIN CERTIFICATE-----\n...\n-----END CERTIFICATE-----"

# or specify a path to a CA file
cafile=/path/to/ca-bundle.crt
```

### `omit` and `include`: Control dependency types

Control which dependency types are installed:

```ini .npmrc icon="npm" theme={"theme":{"light":"github-light","dark":"dracula"}}
# omit dev dependencies
omit=dev

# omit multiple types
omit[]=dev
omit[]=optional

# include specific types (overrides omit)
include=dev
```

Valid values: `dev`, `peer`, `optional`

### `install-strategy` and `node-linker`: Installation strategy

Control how packages are installed in `node_modules`. Bun supports two different configuration options for compatibility with different package managers.

**npm's `install-strategy`:**

```ini .npmrc icon="npm" theme={"theme":{"light":"github-light","dark":"dracula"}}
# flat node_modules structure (default)
install-strategy=hoisted

# symlinked structure
install-strategy=linked
```

**pnpm/yarn's `node-linker`:**

The `node-linker` option controls the installation mode. Bun supports values from both pnpm and yarn:

| Value          | Description                                      | Accepted by |
| -------------- | ------------------------------------------------ | ----------- |
| `isolated`     | Symlinked structure with isolated dependencies   | pnpm        |
| `hoisted`      | Flat node\_modules structure                     | pnpm        |
| `pnpm`         | Symlinked structure (same as `isolated`)         | yarn        |
| `node-modules` | Flat node\_modules structure (same as `hoisted`) | yarn        |

```ini .npmrc icon="npm" theme={"theme":{"light":"github-light","dark":"dracula"}}
# symlinked/isolated mode
node-linker=isolated
node-linker=pnpm

# flat/hoisted mode
node-linker=hoisted
node-linker=node-modules
```

### `public-hoist-pattern` and `hoist-pattern`: Control hoisting

Control which packages are hoisted to the root `node_modules`:

```ini .npmrc icon="npm" theme={"theme":{"light":"github-light","dark":"dracula"}}
# packages matching this pattern will be hoisted to the root
public-hoist-pattern=*eslint*

# multiple patterns
public-hoist-pattern[]=*eslint*
public-hoist-pattern[]=*prettier*

# control general hoisting behavior
hoist-pattern=*
```


# Overrides and resolutions
Source: https://bun.com/docs/pm/overrides

Control metadependency versions with npm overrides and Yarn resolutions

Bun supports npm's `"overrides"` and Yarn's `"resolutions"` in `package.json`. These are mechanisms for specifying a version range for *metadependencies*—the dependencies of your dependencies.

```json package.json icon="file-json" theme={"theme":{"light":"github-light","dark":"dracula"}}
{
  "name": "my-app",
  "dependencies": {
    "foo": "^2.0.0"
  },
  "overrides": { // [!code ++]
    "bar": "~4.4.0" // [!code ++]
  } // [!code ++]
}
```

By default, Bun will install the latest version of all dependencies and metadependencies, according to the ranges specified in each package's `package.json`. Let's say you have a project with one dependency, `foo`, which in turn has a dependency on `bar`. This means `bar` is a *metadependency* of our project.

```json package.json icon="file-json" theme={"theme":{"light":"github-light","dark":"dracula"}}
{
  "name": "my-app",
  "dependencies": {
    "foo": "^2.0.0"
  }
}
```

When you run `bun install`, Bun will install the latest versions of each package.

```txt tree layout of node_modules icon="list-tree" theme={"theme":{"light":"github-light","dark":"dracula"}}
node_modules
├── foo@1.2.3
└── bar@4.5.6
```

But what if a security vulnerability was introduced in `bar@4.5.6`? We may want a way to pin `bar` to an older version that doesn't have the vulnerability. This is where `"overrides"`/`"resolutions"` come in.

***

## `"overrides"`

Add `bar` to the `"overrides"` field in `package.json`. Bun will defer to the specified version range when determining which version of `bar` to install, whether it's a dependency or a metadependency.

<Note>
  Bun currently only supports top-level `"overrides"`. [Nested
  overrides](https://docs.npmjs.com/cli/v9/configuring-npm/package-json#overrides) are not supported.
</Note>

```json package.json icon="file-json" theme={"theme":{"light":"github-light","dark":"dracula"}}
{
  "name": "my-app",
  "dependencies": {
    "foo": "^2.0.0"
  },
  "overrides": { // [!code ++]
    "bar": "~4.4.0" // [!code ++]
  } // [!code ++]
}
```

## `"resolutions"`

The syntax is similar for `"resolutions"`, which is Yarn's alternative to `"overrides"`. Bun supports this feature to make migration from Yarn easier.

As with `"overrides"`, *nested resolutions* are not currently supported.

```json package.json icon="file-json" theme={"theme":{"light":"github-light","dark":"dracula"}}
{
  "name": "my-app",
  "dependencies": {
    "foo": "^2.0.0"
  },
  "resolutions": { // [!code ++]
    "bar": "~4.4.0" // [!code ++]
  } // [!code ++]
}
```


# Scopes and registries
Source: https://bun.com/docs/pm/scopes-registries

Configure private registries and scoped packages

The default registry is `registry.npmjs.org`. This can be globally configured in `bunfig.toml`:

```toml bunfig.toml icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
[install]
# set default registry as a string
registry = "https://registry.npmjs.org"
# set a token
registry = { url = "https://registry.npmjs.org", token = "123456" }
# set a username/password
registry = "https://username:password@registry.npmjs.org"
```

To configure a private registry scoped to a particular organization:

```toml bunfig.toml icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
[install.scopes]
# registry as string
"@myorg1" = "https://username:password@registry.myorg.com/"

# registry with username/password
# you can reference environment variables
"@myorg2" = { username = "myusername", password = "$NPM_PASS", url = "https://registry.myorg.com/" }

# registry with token
"@myorg3" = { token = "$npm_token", url = "https://registry.myorg.com/" }
```

### `.npmrc`

Bun also reads `.npmrc` files, [learn more](/pm/npmrc).


# Security Scanner API
Source: https://bun.com/docs/pm/security-scanner-api



Bun's package manager can scan packages for security vulnerabilities before installation, helping protect your applications from supply chain attacks and known vulnerabilities.

***

## Quick Start

Configure a security scanner in your `bunfig.toml`:

```toml bunfig.toml icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
[install.security]
scanner = "@acme/bun-security-scanner"
```

When configured, Bun will:

* Scan all packages before installation
* Display security warnings and advisories
* Cancel installation if critical vulnerabilities are found
* Automatically disable auto-install for security

***

## How It Works

Security scanners analyze packages during `bun install`, `bun add`, and other package operations. They can detect:

* Known security vulnerabilities (CVEs)
* Malicious packages
* License compliance issues
* ...and more!

### Security Levels

Scanners report issues at two severity levels:

* **`fatal`** - Installation stops immediately, exits with non-zero code
* **`warn`** - In interactive terminals, prompts to continue; in CI, exits immediately

***

## Using Pre-built Scanners

Many security companies publish Bun security scanners as npm packages that you can install and use immediately.

### Installing a Scanner

Install a security scanner from npm:

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun add -d @acme/bun-security-scanner
```

<Note>
  Consult your security scanner's documentation for their specific package name and installation instructions. Most
  scanners will be installed with `bun add`.
</Note>

### Configuring the Scanner

After installation, configure it in your `bunfig.toml`:

```toml bunfig.toml icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
[install.security]
scanner = "@acme/bun-security-scanner"
```

### Enterprise Configuration

Some enterprise scanners might support authentication and/or configuration through environment variables:

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
# This might go in ~/.bashrc, for example
export SECURITY_API_KEY="your-api-key"

# The scanner will now use these credentials automatically
bun install
```

Consult your security scanner's documentation to learn which environment variables to set and if any additional configuration is required.

### Authoring your own scanner

For a complete example with tests and CI setup, see the official template:
[github.com/oven-sh/security-scanner-template](https://github.com/oven-sh/security-scanner-template)

## Related

* [Configuration (bunfig.toml)](/runtime/bunfig#install-security-scanner)
* [Package Manager](/installation)
* [Security Scanner Template](https://github.com/oven-sh/security-scanner-template)


# Workspaces
Source: https://bun.com/docs/pm/workspaces

Develop complex monorepos with multiple independent packages

Bun supports [`workspaces`](https://docs.npmjs.com/cli/v9/using-npm/workspaces?v=true#description) in `package.json`. Workspaces make it easy to develop complex software as a *monorepo* consisting of several independent packages.

It's common for a monorepo to have the following structure:

```txt File Tree icon="folder-tree" theme={"theme":{"light":"github-light","dark":"dracula"}}
<root>
├── README.md
├── bun.lock
├── package.json
├── tsconfig.json
└── packages
    ├── pkg-a
    │   ├── index.ts
    │   ├── package.json
    │   └── tsconfig.json
    ├── pkg-b
    │   ├── index.ts
    │   ├── package.json
    │   └── tsconfig.json
    └── pkg-c
        ├── index.ts
        ├── package.json
        └── tsconfig.json
```

In the root `package.json`, the `"workspaces"` key is used to indicate which subdirectories should be considered packages/workspaces within the monorepo. It's conventional to place all the workspace in a directory called `packages`.

```json package.json icon="file-json" theme={"theme":{"light":"github-light","dark":"dracula"}}
{
  "name": "my-project",
  "version": "1.0.0",
  "workspaces": ["packages/*"],
  "devDependencies": {
    "example-package-in-monorepo": "workspace:*"
  }
}
```

<Note>
  **Glob support** — Bun supports full glob syntax in `"workspaces"`, including negative patterns (e.g.
  `!**/excluded/**`). See [here](/runtime/glob#supported-glob-patterns) for a comprehensive list of supported syntax.
</Note>

```json package.json icon="file-json" theme={"theme":{"light":"github-light","dark":"dracula"}}
{
  "name": "my-project",
  "version": "1.0.0",
  "workspaces": ["packages/**", "!packages/**/test/**", "!packages/**/template/**"]
}
```

Each workspace has it's own `package.json`. When referencing other packages in the monorepo, semver or workspace protocols (e.g. `workspace:*`) can be used as the version field in your `package.json`.

```json packages/pkg-a/package.json icon="file-json" theme={"theme":{"light":"github-light","dark":"dracula"}}
{
  "name": "pkg-a",
  "version": "1.0.0",
  "dependencies": {
    "pkg-b": "workspace:*"
  }
}
```

`bun install` will install dependencies for all workspaces in the monorepo, de-duplicating packages if possible. If you only want to install dependencies for specific workspaces, you can use the `--filter` flag.

```bash theme={"theme":{"light":"github-light","dark":"dracula"}}
# Install dependencies for all workspaces starting with `pkg-` except for `pkg-c`
bun install --filter "pkg-*" --filter "!pkg-c"

# Paths can also be used. This is equivalent to the command above.
bun install --filter "./packages/pkg-*" --filter "!pkg-c" # or --filter "!./packages/pkg-c"
```

When publishing, `workspace:` versions are replaced by the package's `package.json` version,

```
"workspace:*" -> "1.0.1"
"workspace:^" -> "^1.0.1"
"workspace:~" -> "~1.0.1"
```

Setting a specific version takes precedence over the package's `package.json` version,

```
"workspace:1.0.2" -> "1.0.2" // Even if current version is 1.0.1
```

Workspaces have a couple major benefits.

* **Code can be split into logical parts.** If one package relies on another, you can simply add it as a dependency in `package.json`. If package `b` depends on `a`, `bun install` will install your local `packages/a` directory into `node_modules` instead of downloading it from the npm registry.
* **Dependencies can be de-duplicated.** If `a` and `b` share a common dependency, it will be *hoisted* to the root `node_modules` directory. This reduces redundant disk usage and minimizes "dependency hell" issues associated with having multiple versions of a package installed simultaneously.
* **Run scripts in multiple packages.** You can use the [`--filter` flag](/pm/filter) to easily run `package.json` scripts in multiple packages in your workspace, , or `--workspaces` to run scripts across all workspaces.

## Share versions with Catalogs

When many packages need the same dependency versions, catalogs let you define
those versions once in the root `package.json` and reference them from your
workspaces using the `catalog:` protocol. Updating the catalog automatically
updates every package that references it. See
[Catalogs](/pm/catalogs) for details.

<Note>
  ⚡️ **Speed** — Installs are fast, even for big monorepos. Bun installs the [Remix](https://github.com/remix-run/remix) monorepo in about `500ms` on Linux.

  * 28x faster than `npm install`
  * 12x faster than `yarn install` (v1)
  * 8x faster than `pnpm install`

  <Image />
</Note>


