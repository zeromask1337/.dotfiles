# Testing

Testing guidance for Vue 3 apps.

## Why test

- Prevent regressions
- Encourage smaller, testable units (functions, composables, components)
- Catch failures before release

## Test types

- **Unit**: small isolated logic (functions, composables)
- **Component**: mount + interact + assert rendered DOM output
- **E2E**: multi-page flows with real browser + network

## Unit testing

Unit tests often cover plain JS/TS modules; Vue-specific unit targets are typically:
- composables
- components (whitebox / isolated)

Example:

```js
export function increment(current, max = 10) {
  return current < max ? current + 1 : current
}
```

```js
import { increment } from './helpers'

test('increment', () => {
  expect(increment(0, 10)).toBe(1)
  expect(increment(10, 10)).toBe(10)
  expect(increment(10)).toBe(10)
})
```

## Component testing philosophy

Prefer testing *public interfaces*:
- props, events, slots
- user-visible DOM output

Avoid testing implementation details:
- internal component instance state
- private methods
- brittle snapshots

Guidance:
- Test what a component **does**, not how.
- Interact like a user (click, type), then assert DOM.

## Tooling recommendations

- **Vitest**: recommended for Vite-based Vue projects (fast, minimal integration)
- **@vue/test-utils**: official low-level component test library
- **@testing-library/vue**: user-centric testing style (watch out with Suspense)
- **Cypress**: recommended for E2E; also supports component testing

## Router / store in tests

When a component depends on router / stores (e.g. Pinia), tests typically need to install those plugins in the mount config.
