# Reactivity API

Vue's *Reactivity API* is a set of functions (`ref`, `reactive`, `computed`, `watch`, `watchEffect`, etc.) that can be used inside or outside components. It is a subset of the Composition API.

## Mental model

- Vue tracks reactive *reads* (dependency collection) and re-runs reactive *effects* when dependencies change.
- Effects include component rendering, `computed()`, `watch()`, and `watchEffect()`.

## `ref()`

A `ref` is an object with a single reactive property: `.value`.

```ts
import { ref } from 'vue'

const count = ref(0)
count.value++
```

Template auto-unwrapping:

```vue
<script setup>
import { ref } from 'vue'
const count = ref(0)
</script>

<template>
  <button @click="count++">{{ count }}</button>
</template>
```

### `shallowRef()`

Use when you want the ref itself reactive, but *not* deep-tracking of nested mutations.

```ts
import { shallowRef } from 'vue'

const state = shallowRef({ large: 'object' })
state.value = { large: 'new object' } // triggers
state.value.large = 'mutate' // does NOT trigger
```

## `reactive()`

Creates a deeply reactive Proxy around an object.

```ts
import { reactive } from 'vue'

const user = reactive({ name: 'Alice', age: 20 })
user.age++
```

Guidance:
- Prefer `ref()` in composables, then return a plain object of refs.
- Avoid returning a `reactive()` object from a composable if consumers will destructure it (destructure breaks reactivity on object properties).

## `computed()`

Derived, cached value based on reactive dependencies.

```ts
import { ref, computed } from 'vue'

const count = ref(1)
const doubled = computed(() => count.value * 2)
```

- `computed()` returns a *computed ref*.
- Access with `.value` in JS; auto-unwrapped in templates.

## `watchEffect()`

Creates a reactive effect with automatic dependency tracking.

```ts
import { ref, watchEffect } from 'vue'

const count = ref(0)

watchEffect(() => {
  // reruns when count.value changes
  console.log(count.value)
})
```

## `watch()`

Watches an explicit source and runs a callback on change.

```ts
import { ref, watch } from 'vue'

const count = ref(0)

watch(count, (next, prev) => {
  console.log({ prev, next })
})
```

Common patterns:

```ts
// watch getter
watch(() => props.id, (id) => {
  // ...
})

// watch multiple
watch([fooRef, barRef], ([foo, bar]) => {
  // ...
})
```

## `toRef()` / `toRefs()`

Use to preserve reactivity when destructuring reactive objects / props (esp. Vue < 3.5).

```ts
import { toRefs } from 'vue'

const { name, age } = toRefs(user)
```

## `toValue()` / `unref()`

Normalize a value that may be:
- a plain value
- a ref
- (for `toValue`) a getter function

```ts
import { toValue, watchEffect } from 'vue'

watchEffect(() => {
  const url = toValue(maybeRefOrGetter)
  // url is a plain value
})
```

## Flush timing (watchers)

Watchers are batched by Vue's scheduler. Conceptually:
- `flush: 'pre'` (default): before component render
- `flush: 'post'`: after component render

## Gotchas

- Don’t pass non-reactive values into `watch()` (e.g. `watch(props.foo, ...)` is wrong). Use `watch(() => props.foo, ...)`.
- Destructured props are only reactive in Vue 3.5+ (compiler transform).
- Prefer effects with cleanup (`onCleanup`) for async / subscriptions.
