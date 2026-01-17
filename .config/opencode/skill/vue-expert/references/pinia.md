# Pinia (Ecosystem)

Pinia is the recommended state management library in the Vue ecosystem (maintained by Vue core team).

## Why Pinia

- Store model matches Composition API style
- Simple API, less ceremony than Vuex
- Strong TypeScript inference

## Store (setup style)

```ts
import { defineStore } from 'pinia'
import { ref, computed } from 'vue'

export const useCounterStore = defineStore('counter', () => {
  const count = ref(0)
  const doubled = computed(() => count.value * 2)

  function inc() {
    count.value++
  }

  return { count, doubled, inc }
})
```

Usage:

```ts
const counter = useCounterStore()
counter.inc()
```

## Testing note

Component tests that use stores usually install Pinia in the test mount config.

## SSR note

For SSR, create a new app instance per request, including router + store instances, to avoid cross-request state leakage.
