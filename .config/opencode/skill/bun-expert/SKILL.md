---
name: bun-expert
description: Expert guidance for Bun.js runtime development using JavaScriptCore engine. Covers bundling, bundler, testing, package management, runtime APIs, deployment, and framework integrations. Use when working with Bun projects, performance optimization, or troubleshooting Bun-specific issues.
license: MIT
metadata:
  author: OpenCode
  version: "1.0"
  docs_source: https://bun.com/docs
---

# Bun.js Expert

Use this skill when working with Bun.js runtime, bundler, testing, or package management. Bun is a fast JavaScript runtime built on JavaScriptCore with built-in bundler, test runner, and package manager.

## Core Concepts

### What is Bun?
Bun is an all-in-one JavaScript runtime built on JavaScriptCore (WebKit's JS engine). It includes:
- **Runtime**: Execute JavaScript/TypeScript with native performance
- **Bundler**: Built-in bundler compatible with esbuild plugins
- **Package Manager**: npm-compatible with `bun install` (17x faster than npm)
- **Test Runner**: Jest-compatible with `bun test`
- **Dev Server**: Hot reloading for fullstack development

### When to Use Bun
- **High-performance applications**: JavaScriptCore offers better startup than V8
- **CLI tools**: Bytecode caching provides 2-4x faster startup
- **Fullstack apps**: Built-in bundler and dev server
- **Monorepos**: Workspace support with lockfile generation

## Quick Reference

### Common Commands
```bash
# Run a file
bun run index.ts

# Install dependencies
bun install

# Build for production
bun build ./index.ts --outdir=./dist

# Run tests
bun test

# Create single-file executable
bun build ./cli.ts --compile --outfile=mycli
```

### Key Flags
- `--bytecode`: Enable bytecode caching for faster startup
- `--minify`: Minify output (JS, CSS, HTML)
- `--sourcemap`: Generate source maps
- `--target=bun|node|browser`: Target environment
- `--compile`: Create standalone executable
- `--watch`: Watch mode for development
- `--hot`: Hot reloading (fullstack dev server)

## Core Modules

See detailed documentation in references:
- @references/bundler.md - Complete bundler documentation
- @references/runtime-apis.md - Runtime APIs and utilities
- @references/package-manager.md - Package management
- @references/testing.md - Test runner documentation
- @references/deployment.md - Deployment guides
- @references/frameworks.md - Framework integrations

## Best Practices

### Performance
1. **Use bytecode caching** for CLIs and frequently-run tools
2. **Minify before bytecode** to reduce file size
3. **Enable sourcemaps** for production debugging
4. **Use `--target=bun`** for Bun-specific optimizations

### Development
1. Use `.env` files for environment variables (auto-loaded)
2. Leverage built-in TypeScript support (no tsconfig needed)
3. Use workspaces for monorepos
4. Prefer `Bun.*` APIs for file I/O (faster than Node.js APIs)

### Production
1. Generate bytecode in CI/CD (don't commit `.jsc` files)
2. Use `--compile` for standalone CLI distribution
3. Set `NODE_ENV=production` for optimizations
4. Use lockfiles (`bun.lockb`) for reproducible builds

## Common Patterns

### HTTP Server
```typescript
const server = Bun.serve({
  port: 3000,
  fetch(req) {
    return new Response("Hello World");
  },
});
console.log(`Server running at http://localhost:${server.port}`);
```

### File Operations
```typescript
// Fast file reading
const file = Bun.file("./data.json");
const contents = await file.json();

// Fast file writing
await Bun.write("./output.txt", "Hello World");
```

### Environment Variables
```typescript
// Auto-loaded from .env
const apiKey = process.env.API_KEY;
// Or use Bun.env
const apiKey = Bun.env.API_KEY;
```

## Troubleshooting

### Common Issues

**Bytecode version mismatch**: Regenerate bytecode after Bun updates
```bash
bun build --bytecode ./index.ts --outdir=./dist
```

**Top-level await not supported with bytecode**:
```typescript
// ❌ Won't work with --bytecode
const data = await fetch("https://api.example.com");

// ✅ Wrap in function
async function init() {
  const data = await fetch("https://api.example.com");
  return data;
}
export default init;
```

**Module resolution issues**: Bun uses ESM-first resolution
```json
{
  "moduleResolution": "bundler",
  "target": "ESNext"
}
```

## Resources

- @references/bundler.md - Bundler configuration and optimization
- @references/runtime-apis.md - Runtime API documentation
- @references/package-manager.md - Package management guide
- @references/deployment.md - Deployment platforms and Docker
- @references/frameworks.md - Framework integration examples
- @references/bytecode.md - Bytecode caching deep dive
- @references/css.md - CSS bundling and processing
- @references/plugins.md - Writing bundler plugins