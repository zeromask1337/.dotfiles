---
name: vue-expert
description: Expert guidance for Vue.js development using Composition API, script setup, reactivity, components, and best practices. Use when building Vue applications, components, or solving Vue-specific problems.
metadata:
  author: opencode
  version: "1.0"
  source: https://vuejs.org/llms-full.txt
---

Expert Vue.js development skill focused on modern patterns, Composition API, and best practices from official Vue documentation.

## Core Principles

### Component Structure

**Prefer `<script setup>` syntax** - recommended for all SFCs:
- More succinct with less boilerplate
- Better TypeScript inference
- Better runtime performance
- Top-level bindings auto-exposed to template

```vue
<script setup>
import { ref, computed } from 'vue'

const count = ref(0)
const doubled = computed(() => count.value * 2)
</script>

<template>
  <button @click="count++">{{ count }}</button>
</template>
```

### Reactivity

**Use Composition API reactivity primitives**:
- `ref()` for primitive values (auto-unwraps in templates)
- `reactive()` for objects
- `computed()` for derived state
- `watch()`/`watchEffect()` for side effects

```vue
<script setup>
import { ref, reactive, computed, watch } from 'vue'

// Primitives
const count = ref(0)

// Objects
const state = reactive({
  user: { name: 'John' }
})

// Computed
const doubled = computed(() => count.value * 2)

// Watchers
watch(count, (newVal, oldVal) => {
  console.log(`Count changed from ${oldVal} to ${newVal}`)
})
</script>
```

**Vue 3.5+ Reactive Props Destructure**:
```vue
<script setup>
const { foo, bar = 'default' } = defineProps(['foo', 'bar'])

// foo and bar are reactive and can be used directly
watchEffect(() => console.log(foo))
</script>
```

## Component Patterns

### Props & Emits

**Runtime declaration**:
```vue
<script setup>
const props = defineProps({
  foo: String,
  bar: { type: Number, required: true }
})

const emit = defineEmits(['change', 'update'])
emit('change', newValue)
</script>
```

**Type-based declaration (TypeScript)**:
```vue
<script setup lang="ts">
const props = defineProps<{
  foo: string
  bar?: number
}>()

// Vue 3.3+ succinct syntax
const emit = defineEmits<{
  change: [id: number]
  update: [value: string]
}>()
</script>
```

**Default values (Vue 3.5+)**:
```vue
<script setup lang="ts">
interface Props {
  msg?: string
  labels?: string[]
}

// Natural default values with destructuring
const { msg = 'hello', labels = ['one', 'two'] } = defineProps<Props>()
</script>
```

**For Vue 3.4 and below, use `withDefaults`**:
```vue
<script setup lang="ts">
const props = withDefaults(defineProps<Props>(), {
  msg: 'hello',
  labels: () => ['one', 'two'] // Functions for objects/arrays
})
</script>
```

### v-model Pattern

**Vue 3.4+ `defineModel()`**:
```vue
<script setup>
// Parent uses: <MyComponent v-model="value" />
const model = defineModel()

// Mutate directly
model.value = 'new value'

// Named model: <MyComponent v-model:count="count" />
const count = defineModel('count', { type: Number, default: 0 })

// With modifiers
const [modelValue, modifiers] = defineModel({
  set(value) {
    if (modifiers.trim) {
      return value.trim()
    }
    return value
  }
})
</script>
```

### Component Registration

**Auto-import pattern (preferred)**:
```vue
<script setup>
import MyComponent from './MyComponent.vue'
import { MyButton } from './components'
</script>

<template>
  <!-- PascalCase recommended -->
  <MyComponent />
  <MyButton />
</template>
```

**Dynamic components**:
```vue
<script setup>
import Foo from './Foo.vue'
import Bar from './Bar.vue'
</script>

<template>
  <component :is="condition ? Foo : Bar" />
</template>
```

**Namespaced components**:
```vue
<script setup>
import * as Form from './form-components'
</script>

<template>
  <Form.Input>
    <Form.Label>Label</Form.Label>
  </Form.Input>
</template>
```

### Slots

**Basic slots**:
```vue
<!-- Child.vue -->
<template>
  <div>
    <slot></slot> <!-- default slot -->
    <slot name="header"></slot> <!-- named slot -->
  </div>
</template>

<!-- Parent.vue -->
<template>
  <Child>
    <template #header>Header content</template>
    Default content
  </Child>
</template>
```

**Scoped slots**:
```vue
<!-- Child.vue -->
<script setup>
const items = ref(['a', 'b', 'c'])
</script>

<template>
  <div v-for="item in items">
    <slot :item="item"></slot>
  </div>
</template>

<!-- Parent.vue -->
<template>
  <Child v-slot="{ item }">
    {{ item }}
  </Child>
</template>
```

**TypeScript slot types (3.3+)**:
```vue
<script setup lang="ts">
const slots = defineSlots<{
  default(props: { msg: string }): any
  header(): any
}>()
</script>
```

### Expose Pattern

**Components using `<script setup>` are closed by default**:
```vue
<script setup>
import { ref } from 'vue'

const count = ref(0)
const increment = () => count.value++

// Explicitly expose to parent refs
defineExpose({
  count,
  increment
})
</script>
```

### Component Options

**Use `defineOptions()` (3.3+)**:
```vue
<script setup>
defineOptions({
  name: 'CustomName',
  inheritAttrs: false,
  customOptions: { /* ... */ }
})
</script>
```

## Advanced Patterns

### Generics (TypeScript)

```vue
<script setup lang="ts" generic="T extends Item">
import type { Item } from './types'

defineProps<{
  items: T[]
  selected: T
}>()
</script>
```

**Multiple generic parameters**:
```vue
<script 
  setup 
  lang="ts" 
  generic="T extends string | number, U extends Item"
>
defineProps<{
  id: T
  list: U[]
}>()
</script>
```

### Async Setup

**Top-level await**:
```vue
<script setup>
const post = await fetch(`/api/post/1`).then(r => r.json())
// Component becomes async, use with Suspense
</script>
```

### Custom Directives

```vue
<script setup>
// Must follow vNameOfDirective pattern
const vMyDirective = {
  beforeMount: (el) => {
    el.style.color = 'red'
  }
}

// Or import and rename
import { myDirective as vMyDirective } from './directives'
</script>

<template>
  <div v-my-directive>Content</div>
</template>
```

### Composables Pattern

**Create reusable logic**:
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

**Usage**:
```vue
<script setup>
import { useMouse } from './composables/useMouse'

const { x, y } = useMouse()
</script>
```

## Lifecycle & Side Effects

**Composition API lifecycle hooks**:
```vue
<script setup>
import { onMounted, onUpdated, onUnmounted, onBeforeMount } from 'vue'

onBeforeMount(() => {
  // Before mount
})

onMounted(() => {
  // After mount - access DOM
})

onUpdated(() => {
  // After reactive state changes
})

onUnmounted(() => {
  // Cleanup
})
</script>
```

## Template Syntax

### Directives

- `v-if` / `v-else-if` / `v-else` - conditional rendering
- `v-show` - toggle display (element stays in DOM)
- `v-for` - list rendering (always use `:key`)
- `v-on` or `@` - event listeners
- `v-bind` or `:` - attribute binding
- `v-model` - two-way binding

### Event Modifiers

```vue
<template>
  <!-- Prevent default -->
  <form @submit.prevent="onSubmit"></form>
  
  <!-- Stop propagation -->
  <div @click.stop="doThis"></div>
  
  <!-- Chain modifiers -->
  <a @click.stop.prevent="doThat"></a>
  
  <!-- Key modifiers -->
  <input @keyup.enter="submit" />
  <input @keyup.ctrl.enter="submit" />
</template>
```

## Best Practices

### Naming Conventions

- **Components**: PascalCase in templates (`<MyComponent />`)
- **Props**: camelCase in JS, kebab-case in templates
- **Events**: kebab-case (`@my-event`)
- **Composables**: `use` prefix (`useMouse`, `useUser`)

### Performance

- Use `v-show` for frequent toggling, `v-if` for rare changes
- Use `v-once` for static content
- Use `v-memo` to skip updates (Vue 3.2+)
- Lazy load components with `defineAsyncComponent()`
- Use `shallowRef` / `shallowReactive` for large immutable structures

### TypeScript

- Always use `lang="ts"` in `<script setup>`
- Prefer type-based `defineProps` over runtime
- Use generic components when needed
- Leverage Vue's built-in types (`Ref`, `ComputedRef`, etc.)

### Accessibility

- Use semantic HTML
- Include ARIA attributes when needed
- Ensure keyboard navigation
- Test with screen readers
- Maintain color contrast ratios

### State Management

**Pinia (recommended)**:
```js
// stores/counter.js
import { defineStore } from 'pinia'
import { ref, computed } from 'vue'

export const useCounterStore = defineStore('counter', () => {
  const count = ref(0)
  const doubled = computed(() => count.value * 2)
  
  function increment() {
    count.value++
  }

  return { count, doubled, increment }
})
```

**Usage**:
```vue
<script setup>
import { useCounterStore } from '@/stores/counter'

const counter = useCounterStore()
</script>

<template>
  <div>{{ counter.count }}</div>
  <button @click="counter.increment">+</button>
</template>
```

### Provide/Inject Pattern

**Provide at parent level**:
```vue
<script setup>
import { provide, ref } from 'vue'

const theme = ref('dark')
provide('theme', theme)
</script>
```

**Inject in descendants**:
```vue
<script setup>
import { inject } from 'vue'

const theme = inject('theme')
</script>
```

## Common Patterns

### Form Handling

```vue
<script setup>
import { reactive } from 'vue'

const form = reactive({
  name: '',
  email: '',
  age: null
})

function handleSubmit() {
  console.log('Form data:', form)
}
</script>

<template>
  <form @submit.prevent="handleSubmit">
    <input v-model="form.name" placeholder="Name" />
    <input v-model="form.email" type="email" placeholder="Email" />
    <input v-model.number="form.age" type="number" placeholder="Age" />
    <button type="submit">Submit</button>
  </form>
</template>
```

### Async Data Fetching

```vue
<script setup>
import { ref, onMounted } from 'vue'

const data = ref(null)
const loading = ref(true)
const error = ref(null)

async function fetchData() {
  try {
    loading.value = true
    const response = await fetch('/api/data')
    data.value = await response.json()
  } catch (e) {
    error.value = e
  } finally {
    loading.value = false
  }
}

onMounted(fetchData)
</script>

<template>
  <div v-if="loading">Loading...</div>
  <div v-else-if="error">Error: {{ error.message }}</div>
  <div v-else>{{ data }}</div>
</template>
```

### Conditional Classes & Styles

```vue
<template>
  <!-- Object syntax -->
  <div :class="{ active: isActive, 'text-danger': hasError }"></div>
  
  <!-- Array syntax -->
  <div :class="[isActive ? 'active' : '', errorClass]"></div>
  
  <!-- Inline styles -->
  <div :style="{ color: activeColor, fontSize: fontSize + 'px' }"></div>
</template>
```

## Restrictions & Gotchas

- `<script setup>` cannot use `src` attribute
- `<script setup>` does not support In-DOM root templates
- Destructured props lose reactivity in Vue 3.4 and below (use `toRef`/`toRefs` or upgrade to 3.5+)
- `defineProps`, `defineEmits`, `defineModel`, `defineExpose`, `defineOptions`, `defineSlots` are compiler macros - don't import them
- Props options cannot reference local variables (module scope only)
- Default values for objects/arrays in `withDefaults` should be functions

## Migration Notes

**From Options API to Composition API**:
- `data()` → `ref()` / `reactive()`
- `computed` → `computed()`
- `methods` → regular functions
- `watch` → `watch()` / `watchEffect()`
- `mounted()` → `onMounted()`
- `this.$refs` → `ref()` with template refs
- `this.$emit` → `emit` from `defineEmits()`

## Resources

When encountering Vue-specific problems:
1. Check if using latest Vue 3.x syntax
2. Verify Composition API + `<script setup>` usage
3. Ensure proper TypeScript types if applicable
4. Consider reactivity caveats (destructuring, refs, etc.)
5. Check Vue 3.5+ features for modern patterns

For complex state: Use Pinia
For routing: Use Vue Router
For SSR: Use Nuxt or Vite SSR
For build tooling: Use Vite (recommended) or Webpack
