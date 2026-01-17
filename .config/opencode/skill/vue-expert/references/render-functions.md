# Render Functions & JSX

Templates compile down to *render functions*. You usually write templates, but render functions are useful for:
- advanced dynamic rendering
- higher-order components / renderless patterns
- libraries / headless components
- TSX / JSX-heavy codebases

## Basics: `h()`

A VNode is created via `h()`.

```ts
import { h } from 'vue'

export default {
  setup() {
    return () => h('div', 'hello')
  }
}
```

VNode props (second arg to `h`) can include:
- component props
- DOM attributes / properties
- event listeners

```ts
return () =>
  h('button', { onClick: () => console.log('click') }, 'Click')
```

## Render function from `setup()`

`setup()` can return a render function instead of bindings.

```ts
import { ref, h } from 'vue'

export default {
  setup() {
    const count = ref(0)

    return () =>
      h('button', { onClick: () => count.value++ }, String(count.value))
  }
}
```

Tradeoff: if you return a render function, you can't also return other bindings for template usage.

## Functional components

A functional component is a function returning VNodes.

```ts
import { h } from 'vue'

export const Hello = (props: { msg: string }) => h('div', props.msg)
```

## JSX / TSX

Vue supports JSX/TSX as an alternative authoring format.

Example (TSX):

```tsx
import { defineComponent, ref } from 'vue'

export default defineComponent(() => {
  const count = ref(0)
  return () => (
    <button onClick={() => count.value++}>{count.value}</button>
  )
})
```

General guidance:
- keep component names PascalCase
- in TSX, ensure TypeScript config supports JSX (`jsx: preserve`) and your build pipeline has Vue JSX transform

## Slots in render functions

Slots are functions.

```ts
import { h } from 'vue'

export default {
  setup(_props, { slots }) {
    return () => h('div', slots.default?.({ msg: 'hi' }))
  }
}
```

## Built-ins in render functions

When using built-ins like `<Transition>` in render functions, import them explicitly.

```ts
import { h, Transition } from 'vue'

return () =>
  h(
    Transition,
    { name: 'fade' },
    { default: () => h('div', 'hello') }
  )
```
