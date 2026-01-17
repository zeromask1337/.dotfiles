---
name: vue-expert
description: Expert guidance for Vue.js development using Composition API, script setup, reactivity, components, and best practices. Use when building Vue applications, components, or solving Vue-specific problems.
metadata:
  author: opencode
  version: "4.0"
  source: https://vuejs.org/llms-full.txt
  updated: 2026-01-17
---

# Vue.js Expert Skill

Comprehensive Vue.js development guidance based on official Vue 3 documentation. Focused on modern patterns with Composition API and `<script setup>`.

## Core Philosophy

**Always prefer `<script setup>` syntax** - it's the recommended approach for all SFCs:
- More succinct with less boilerplate
- Better TypeScript inference and IDE support
- Better runtime performance
- Direct template access to all top-level bindings

## Component Structure

### Basic Template

```vue
<script setup>
import { ref, computed } from 'vue'

// State
const count = ref(0)
const doubled = computed(() => count.value * 2)

// Methods
function increment() {
  count.value++
}
</script>

<template>
  <button @click="increment">Count: {{ count }}</button>
  <p>Doubled: {{ doubled }}</p>
</template>

<style scoped>
/* Component styles */
</style>
```

### Reactivity System

**Fundamental reactive primitives:**

- **`ref()`** - For primitive values and direct object references
  - Auto-unwraps in templates
  - Use `.value` in `<script>`
  
- **`reactive()`** - For deeply reactive objects
  - No need for `.value`
  - Cannot replace entire object (use `Object.assign()` instead)

- **`computed()`** - For derived state
  - Cached based on dependencies
  - Read-only by default

- **`watch()` / `watchEffect()`** - For side effects
  - `watch()` - Explicit dependencies
  - `watchEffect()` - Auto-track dependencies

```vue
<script setup>
import { ref, reactive, computed, watch, watchEffect } from 'vue'

// Primitives with ref
const count = ref(0)
const message = ref('Hello')

// Objects with reactive
const user = reactive({
  name: 'Alice',
  age: 25
})

// Computed values
const fullInfo = computed(() => `${user.name}, ${user.age}`)

// Explicit watch
watch(count, (newVal, oldVal) => {
  console.log(`Count: ${oldVal} → ${newVal}`)
})

// Auto-tracking watch
watchEffect(() => {
  console.log(`User: ${user.name}`)
})
</script>
```

## Props & Events

### Props Declaration

**Runtime-based (JavaScript):**

```vue
<script setup>
const props = defineProps({
  title: String,
  count: {
    type: Number,
    required: true,
    default: 0
  },
  tags: {
    type: Array,
    default: () => []
  }
})
</script>
```

**Type-based (TypeScript):**

```vue
<script setup lang="ts">
interface Props {
  title?: string
  count: number
  tags?: string[]
}

const props = defineProps<Props>()
</script>
```

**Vue 3.5+ Reactive Props Destructure:**

```vue
<script setup>
// Props are automatically reactive when destructured (3.5+)
const { title, count = 0 } = defineProps(['title', 'count'])

// Can use directly in watchers
watchEffect(() => console.log(title))
</script>
```

**Vue 3.4 and below - Use `withDefaults`:**

```vue
<script setup lang="ts">
interface Props {
  msg?: string
  labels?: string[]
}

const props = withDefaults(defineProps<Props>(), {
  msg: 'hello',
  labels: () => ['one', 'two'] // Use functions for arrays/objects
})
</script>
```

### Events

**Runtime declaration:**

```vue
<script setup>
const emit = defineEmits(['update', 'delete'])

function handleUpdate(value) {
  emit('update', value)
}
</script>
```

**Type-based (Vue 3.3+ succinct syntax):**

```vue
<script setup lang="ts">
const emit = defineEmits<{
  update: [id: number, value: string]
  delete: [id: number]
}>()
</script>
```

## v-model Pattern

**Vue 3.4+ with `defineModel()`:**

```vue
<script setup>
// Default model - consumed as v-model
const model = defineModel()
model.value = 'new value' // Emits update:modelValue

// Named model - consumed as v-model:count
const count = defineModel('count', { type: Number, default: 0 })

// With modifiers
const [modelValue, modifiers] = defineModel({
  set(value) {
    return modifiers.trim ? value.trim() : value
  }
})
</script>

<template>
  <input v-model="model" />
</template>
```

**Usage in parent:**

```vue
<template>
  <MyComponent v-model="text" />
  <MyComponent v-model:count="count" />
</template>
```

## Component Registration & Usage

### Import & Use

```vue
<script setup>
import MyComponent from './MyComponent.vue'
import { UserCard } from '@/components'
</script>

<template>
  <!-- PascalCase preferred -->
  <MyComponent />
  <UserCard />
</template>
```

### Dynamic Components

```vue
<script setup>
import ComponentA from './ComponentA.vue'
import ComponentB from './ComponentB.vue'
import { shallowRef } from 'vue'

const currentComponent = shallowRef(ComponentA)
</script>

<template>
  <component :is="currentComponent" />
  <component :is="someCondition ? ComponentA : ComponentB" />
</template>
```

### Async Components

```vue
<script setup>
import { defineAsyncComponent } from 'vue'

const AsyncComp = defineAsyncComponent(() =>
  import('./HeavyComponent.vue')
)
</script>
```

### Namespaced Components

```vue
<script setup>
import * as Form from './form-components'
</script>

<template>
  <Form.Input>
    <Form.Label>Name</Form.Label>
  </Form.Input>
</template>
```

## Slots

### Basic Slots

```vue
<!-- Child.vue -->
<template>
  <div class="container">
    <header>
      <slot name="header"></slot>
    </header>
    <main>
      <slot></slot> <!-- default slot -->
    </main>
  </div>
</template>

<!-- Parent.vue -->
<template>
  <Child>
    <template #header>
      <h1>Page Title</h1>
    </template>
    <p>Main content</p>
  </Child>
</template>
```

### Scoped Slots

```vue
<!-- List.vue -->
<script setup>
import { ref } from 'vue'

const items = ref([
  { id: 1, name: 'Item 1' },
  { id: 2, name: 'Item 2' }
])
</script>

<template>
  <div v-for="item in items" :key="item.id">
    <slot :item="item" :index="index"></slot>
  </div>
</template>

<!-- Parent.vue -->
<template>
  <List v-slot="{ item, index }">
    <div>{{ index }}: {{ item.name }}</div>
  </List>
</template>
```

### TypeScript Slot Types (Vue 3.3+)

```vue
<script setup lang="ts">
const slots = defineSlots<{
  default(props: { msg: string }): any
  header(props: { title: string }): any
}>()
</script>
```

## Lifecycle Hooks

```vue
<script setup>
import {
  onBeforeMount,
  onMounted,
  onBeforeUpdate,
  onUpdated,
  onBeforeUnmount,
  onUnmounted,
  onErrorCaptured
} from 'vue'

onBeforeMount(() => {
  // Before component is mounted
})

onMounted(() => {
  // Component mounted - DOM access available
  // Ideal for: API calls, DOM manipulation, timers
})

onBeforeUpdate(() => {
  // Before reactive state change triggers re-render
})

onUpdated(() => {
  // After re-render (use sparingly)
})

onBeforeUnmount(() => {
  // Before component unmounts
})

onUnmounted(() => {
  // Component unmounted - cleanup here
  // Clear timers, event listeners, subscriptions
})

onErrorCaptured((err, instance, info) => {
  // Capture errors from child components
  return false // Stop propagation
})
</script>
```

## Template Syntax

### Directives

- **`v-if` / `v-else-if` / `v-else`** - Conditional rendering (removes from DOM)
- **`v-show`** - Toggle visibility (CSS display property)
- **`v-for`** - List rendering (always use `:key`)
- **`v-on` or `@`** - Event binding
- **`v-bind` or `:`** - Attribute binding
- **`v-model`** - Two-way binding
- **`v-once`** - Render once, skip updates
- **`v-memo`** - Memoize sub-tree (Vue 3.2+)

### List Rendering

```vue
<template>
  <!-- Always use :key with v-for -->
  <div v-for="item in items" :key="item.id">
    {{ item.name }}
  </div>

  <!-- Index as second parameter -->
  <div v-for="(item, index) in items" :key="item.id">
    {{ index }}: {{ item.name }}
  </div>

  <!-- Object iteration -->
  <div v-for="(value, key, index) in object" :key="key">
    {{ key }}: {{ value }}
  </div>
</template>
```

### Event Handling

```vue
<template>
  <!-- Method handler -->
  <button @click="handleClick">Click</button>

  <!-- Inline handler -->
  <button @click="count++">Increment</button>

  <!-- Method with arguments -->
  <button @click="handleClick($event, 'extra')">Click</button>

  <!-- Event modifiers -->
  <form @submit.prevent="onSubmit">
    <button type="submit">Submit</button>
  </form>

  <div @click.stop="doThis">Stop propagation</div>
  <a @click.prevent.stop="doThat">Prevent & stop</a>

  <!-- Key modifiers -->
  <input @keyup.enter="submit" />
  <input @keyup.ctrl.enter="submitWithCtrl" />
  <input @keyup.page-down="onPageDown" />
</template>
```

### Class & Style Binding

```vue
<script setup>
import { ref } from 'vue'

const isActive = ref(true)
const hasError = ref(false)
const activeClass = ref('active')
const errorClass = ref('text-danger')
const activeColor = ref('red')
const fontSize = ref(14)
</script>

<template>
  <!-- Object syntax -->
  <div :class="{ active: isActive, 'text-danger': hasError }"></div>

  <!-- Array syntax -->
  <div :class="[activeClass, errorClass]"></div>
  <div :class="[isActive ? activeClass : '', errorClass]"></div>

  <!-- Combined -->
  <div :class="[{ active: isActive }, errorClass]"></div>

  <!-- Inline styles - object -->
  <div :style="{ color: activeColor, fontSize: fontSize + 'px' }"></div>

  <!-- Inline styles - array -->
  <div :style="[baseStyles, overrideStyles]"></div>
</template>
```

## Custom Directives

```vue
<script setup>
// Directive must follow vNameOfDirective naming convention
const vFocus = {
  mounted: (el) => el.focus()
}

const vClickOutside = {
  mounted(el, binding) {
    el.clickOutsideEvent = (event) => {
      if (!(el === event.target || el.contains(event.target))) {
        binding.value(event)
      }
    }
    document.addEventListener('click', el.clickOutsideEvent)
  },
  unmounted(el) {
    document.removeEventListener('click', el.clickOutsideEvent)
  }
}

// Or import and rename
import { myDirective as vMyDirective } from './directives'
</script>

<template>
  <input v-focus />
  <div v-click-outside="closeDropdown">Dropdown</div>
</template>
```

## Component Exposure

```vue
<script setup>
import { ref } from 'vue'

const count = ref(0)
const message = ref('Hello')

function reset() {
  count.value = 0
}

// Components using <script setup> are closed by default
// Explicitly expose to parent via template refs
defineExpose({
  count,
  reset
  // message is NOT exposed
})
</script>
```

**Parent usage:**

```vue
<script setup>
import { ref, onMounted } from 'vue'
import Child from './Child.vue'

const childRef = ref()

onMounted(() => {
  console.log(childRef.value.count) // Accessible
  childRef.value.reset() // Accessible
})
</script>

<template>
  <Child ref="childRef" />
</template>
```

## Component Options

**Use `defineOptions()` for component metadata (Vue 3.3+):**

```vue
<script setup>
defineOptions({
  name: 'CustomComponentName',
  inheritAttrs: false,
  customOptions: {
    // Custom plugin options
  }
})
</script>
```

## Advanced Patterns

### Composables

Create reusable stateful logic:

```js
// composables/useMouse.js
import { ref, onMounted, onUnmounted } from 'vue'

export function useMouse() {
  const x = ref(0)
  const y = ref(0)

  function update(event) {
    x.value = event.pageX
    y.value = event.pageY
  }

  onMounted(() => window.addEventListener('mousemove', update))
  onUnmounted(() => window.removeEventListener('mousemove', update))

  return { x, y }
}
```

**Usage:**

```vue
<script setup>
import { useMouse } from '@/composables/useMouse'

const { x, y } = useMouse()
</script>

<template>
  <div>Mouse: {{ x }}, {{ y }}</div>
</template>
```

### Provide/Inject

Share data across component tree without prop drilling:

```vue
<!-- Parent/Ancestor -->
<script setup>
import { provide, ref } from 'vue'

const theme = ref('dark')
provide('theme', theme)

// With reactive updates
provide('updateTheme', (newTheme) => {
  theme.value = newTheme
})
</script>

<!-- Child/Descendant -->
<script setup>
import { inject } from 'vue'

const theme = inject('theme')
const updateTheme = inject('updateTheme')
</script>
```

### TypeScript Generics

```vue
<script setup lang="ts" generic="T extends Item">
import type { Item } from './types'

defineProps<{
  items: T[]
  selected: T
}>()
</script>
```

**Multiple parameters with constraints:**

```vue
<script 
  setup 
  lang="ts" 
  generic="T extends string | number, U extends Item"
>
import type { Item } from './types'

defineProps<{
  id: T
  list: U[]
}>()
</script>
```

### Async Components with Top-level Await

```vue
<script setup>
// Component becomes async - use with Suspense
const posts = await fetch('/api/posts').then(r => r.json())
</script>

<template>
  <div v-for="post in posts" :key="post.id">
    {{ post.title }}
  </div>
</template>
```

**With Suspense:**

```vue
<template>
  <Suspense>
    <template #default>
      <AsyncComponent />
    </template>
    <template #fallback>
      <div>Loading...</div>
    </template>
  </Suspense>
</template>
```

## Common Patterns

### Form Handling

```vue
<script setup>
import { reactive, computed } from 'vue'

const form = reactive({
  username: '',
  email: '',
  age: null,
  terms: false
})

const isValid = computed(() => {
  return form.username && form.email && form.terms
})

async function handleSubmit() {
  if (!isValid.value) return
  
  try {
    await fetch('/api/submit', {
      method: 'POST',
      body: JSON.stringify(form)
    })
  } catch (error) {
    console.error(error)
  }
}
</script>

<template>
  <form @submit.prevent="handleSubmit">
    <input v-model="form.username" placeholder="Username" required />
    <input v-model="form.email" type="email" placeholder="Email" required />
    <input v-model.number="form.age" type="number" placeholder="Age" />
    
    <label>
      <input v-model="form.terms" type="checkbox" />
      I agree to terms
    </label>

    <button type="submit" :disabled="!isValid">Submit</button>
  </form>
</template>
```

### Async Data Fetching

```vue
<script setup>
import { ref, onMounted } from 'vue'

const data = ref(null)
const loading = ref(false)
const error = ref(null)

async function fetchData() {
  loading.value = true
  error.value = null
  
  try {
    const response = await fetch('/api/data')
    if (!response.ok) throw new Error('Failed to fetch')
    data.value = await response.json()
  } catch (e) {
    error.value = e.message
  } finally {
    loading.value = false
  }
}

onMounted(fetchData)
</script>

<template>
  <div v-if="loading">Loading...</div>
  <div v-else-if="error">Error: {{ error }}</div>
  <div v-else-if="data">
    <pre>{{ data }}</pre>
  </div>
</template>
```

### Debounced Input

```vue
<script setup>
import { ref, watch } from 'vue'

const search = ref('')
const debouncedSearch = ref('')

let timeout = null

watch(search, (newValue) => {
  clearTimeout(timeout)
  timeout = setTimeout(() => {
    debouncedSearch.value = newValue
  }, 300)
})

// Perform search when debouncedSearch changes
watch(debouncedSearch, async (query) => {
  if (!query) return
  // Perform API call
  const results = await fetch(`/api/search?q=${query}`)
})
</script>

<template>
  <input v-model="search" placeholder="Search..." />
</template>
```

## Best Practices

### Naming Conventions

- **Components**: PascalCase in templates (`<MyComponent />`)
- **Props**: camelCase in JS, kebab-case in templates
- **Events**: kebab-case (`@update-user`)
- **Composables**: `use` prefix (`useAuth`, `useFetch`)
- **Directives**: `vDirectiveName` in `<script setup>`

### Performance Optimization

- **Use `v-show`** for frequent toggling
- **Use `v-if`** for rare conditional rendering
- **Use `v-once`** for static content
- **Use `v-memo`** to skip updates (Vue 3.2+)
- **Use `shallowRef` / `shallowReactive`** for large immutable data
- **Lazy load** with `defineAsyncComponent()`
- **Avoid unnecessary reactivity** on large data structures

### Reactivity Gotchas

- Destructured props lose reactivity (Vue < 3.5) - use `toRef()` / `toRefs()`
- Always use `.value` with refs in `<script>`
- Can't replace entire reactive object - use `Object.assign()` or `reactive()` wrapper
- Use `shallowRef` for large objects that don't need deep reactivity

### TypeScript Best Practices

- Use `lang="ts"` in `<script setup>`
- Prefer type-based `defineProps` over runtime
- Use Vue's built-in types: `Ref`, `ComputedRef`, `UnwrapRef`
- Leverage generics for reusable components
- Type your composables return values

## State Management

**For complex apps, use Pinia (official state management):**

```js
// stores/counter.js
import { defineStore } from 'pinia'
import { ref, computed } from 'vue'

export const useCounterStore = defineStore('counter', () => {
  // State
  const count = ref(0)
  
  // Getters
  const doubled = computed(() => count.value * 2)
  
  // Actions
  function increment() {
    count.value++
  }
  
  async function asyncIncrement() {
    await new Promise(r => setTimeout(r, 1000))
    count.value++
  }

  return { count, doubled, increment, asyncIncrement }
})
```

**Usage:**

```vue
<script setup>
import { useCounterStore } from '@/stores/counter'

const store = useCounterStore()

// Direct access
console.log(store.count)

// Call actions
store.increment()
</script>

<template>
  <div>{{ store.count }}</div>
  <button @click="store.increment">+</button>
</template>
```

## Restrictions & Limitations

- `<script setup>` cannot use `src` attribute
- `<script setup>` doesn't support In-DOM root templates
- Compiler macros (`defineProps`, `defineEmits`, etc.) don't need imports
- Props options cannot reference local variables (module scope only)
- Default values for objects/arrays should be factory functions
- Avoid interactive git commands (no `-i` flags)

## Migration from Options API

| Options API | Composition API |
|-------------|----------------|
| `data()` | `ref()` / `reactive()` |
| `computed` | `computed()` |
| `methods` | Regular functions |
| `watch` | `watch()` / `watchEffect()` |
| `mounted()` | `onMounted()` |
| `this.$refs` | `ref()` with template refs |
| `this.$emit` | `emit` from `defineEmits()` |
| `this.$props` | `props` from `defineProps()` |

## Additional Resources

For complex scenarios, reference:
- [references/accessibility.md](references/accessibility.md) - Accessibility best practices
- [references/animations.md](references/animations.md) - Animation techniques
- [references/sfc-spec.md](references/sfc-spec.md) - Single File Component specification
- [references/application-api.md](references/application-api.md) - Application-level API reference

**Ecosystem:**
- **Router**: Vue Router
- **State**: Pinia
- **SSR**: Nuxt
- **Build**: Vite (recommended)
- **Testing**: Vitest + Vue Test Utils
