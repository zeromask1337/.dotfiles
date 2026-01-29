# Composition API Complete Reference

Comprehensive guide to Vue 3's Composition API and `<script setup>` syntax.

## `<script setup>` Basics

Compile-time syntactic sugar for Composition API in SFCs. Recommended syntax for Vue 3.

### Key Benefits

- More succinct code with less boilerplate
- Pure TypeScript prop/emit declarations
- Better runtime performance (template compiled in same scope)
- Better IDE type-inference performance

### Basic Syntax

```vue
<script setup>
console.log('Runs on each component instance creation')
</script>
```

### Top-Level Bindings Auto-Expose

All top-level bindings (variables, functions, imports) are directly usable in template:

```vue
<script setup>
import { capitalize } from './helpers'

const msg = 'Hello!'

function log() {
  console.log(msg)
}
</script>

<template>
  <button @click="log">{{ capitalize(msg) }}</button>
</template>
```

## defineProps()

Declare component props with full type inference.

### Runtime Declaration

```vue
<script setup>
const props = defineProps({
  foo: String,
  bar: {
    type: Number,
    required: true,
    default: 0
  }
})

console.log(props.foo)
</script>
```

### Type-Based Declaration (TypeScript)

```vue
<script setup lang="ts">
const props = defineProps<{
  foo: string
  bar?: number
}>()
</script>
```

### Reactive Props Destructure (Vue 3.5+)

Destructured props are automatically reactive:

```vue
<script setup>
const { foo } = defineProps(['foo'])

// foo is reactive! Compiler transforms to props.foo
watchEffect(() => {
  console.log(foo) // Re-runs when foo prop changes
})
</script>
```

Compiled to:

```js
const props = defineProps(['foo'])

watchEffect(() => {
  console.log(props.foo)
})
```

### Default Values (Vue 3.5+)

Use JavaScript native default syntax:

```vue
<script setup lang="ts">
interface Props {
  msg?: string
  labels?: string[]
}

const { msg = 'hello', labels = ['one', 'two'] } = defineProps<Props>()
</script>
```

### withDefaults (Vue 3.4 and below)

```vue
<script setup lang="ts">
interface Props {
  msg?: string
  labels?: string[]
}

const props = withDefaults(defineProps<Props>(), {
  msg: 'hello',
  labels: () => ['one', 'two'] // Functions for objects/arrays!
})
</script>
```

**Important:** Default values for objects/arrays must be wrapped in functions to avoid shared references.

### Important Rules

- **Compiler macros** - Don't import `defineProps`, it's automatically available
- **Module scope only** - Props options can't reference local variables, only imports
- **Hoisted** - Props definition is hoisted to module scope
- **Either/or** - Can't use both runtime and type declaration simultaneously

## defineEmits()

Declare events emitted by component.

### Runtime Declaration

```vue
<script setup>
const emit = defineEmits(['change', 'delete'])

emit('change', newValue)
emit('delete')
</script>
```

### Type-Based Declaration

Vue 3.3+ succinct syntax (recommended):

```vue
<script setup lang="ts">
const emit = defineEmits<{
  change: [id: number]          // Named tuple syntax
  update: [value: string]
  delete: []                     // No parameters
}>()
</script>
```

Legacy syntax:

```vue
<script setup lang="ts">
const emit = defineEmits<{
  (e: 'change', id: number): void
  (e: 'update', value: string): void
}>()
</script>
```

## defineModel() (Vue 3.4+)

Declare two-way binding prop for `v-model`.

### Basic Usage

```vue
<script setup>
// Parent: <MyComponent v-model="value" />
const model = defineModel()

// Mutating automatically emits "update:modelValue"
model.value = 'new value'
</script>
```

### With Options

```vue
<script setup>
const model = defineModel({ type: String, required: true })
</script>
```

### Named Models

```vue
<script setup>
// Parent: <MyComponent v-model:count="count" />
const count = defineModel('count')

// Parent: <MyComponent v-model:title="title" />
const title = defineModel('title', { type: String, default: 'Untitled' })

function increment() {
  count.value++ // Emits "update:count"
}
</script>
```

### Modifiers & Transformers

```vue
<script setup>
const [modelValue, modifiers] = defineModel()

// Check modifiers
if (modifiers.trim) {
  // Handle .trim modifier
}

// Transform with get/set
const [modelValue, modifiers] = defineModel({
  get(value) {
    return value.toUpperCase()
  },
  set(value) {
    if (modifiers.trim) {
      return value.trim()
    }
    return value
  }
})
</script>
```

### TypeScript

```vue
<script setup lang="ts">
const modelValue = defineModel<string>()
//    ^? Ref<string | undefined>

// Required removes undefined
const modelValue = defineModel<string>({ required: true })
//    ^? Ref<string>

// With modifier types
const [modelValue, modifiers] = defineModel<string, 'trim' | 'uppercase'>()
//                 ^? Record<'trim' | 'uppercase', true | undefined>
</script>
```

### Caveat

If you provide a `default` but parent doesn't pass value, parent and child can desync:

```vue
<!-- Child.vue -->
<script setup>
const model = defineModel({ default: 1 })
// model.value = 1
</script>

<!-- Parent.vue -->
<script setup>
const myRef = ref() // undefined
</script>
<template>
  <Child v-model="myRef"></Child>
  <!-- myRef is undefined, but child's model is 1 -->
</template>
```

## defineExpose()

Explicitly expose properties to parent component via template refs.

```vue
<script setup>
import { ref } from 'vue'

const count = ref(0)
const privateData = ref('hidden')

function increment() {
  count.value++
}

// Only expose these to parent
defineExpose({
  count,
  increment
})
</script>
```

Parent access:

```vue
<script setup>
import { ref } from 'vue'
import MyComponent from './MyComponent.vue'

const child = ref()

function accessChild() {
  console.log(child.value.count)
  child.value.increment()
  // child.value.privateData - undefined!
}
</script>

<template>
  <MyComponent ref="child" />
</template>
```

**Important:** Components using `<script setup>` are **closed by default**. Without `defineExpose`, parent gets `{}`.

## defineOptions() (Vue 3.3+)

Declare component options directly in `<script setup>`.

```vue
<script setup>
defineOptions({
  name: 'CustomName',
  inheritAttrs: false,
  customOptions: {
    /* plugin-specific options */
  }
})
</script>
```

Replaces need for separate `<script>` block for these options.

**Limitations:** Options are hoisted to module scope and can't access local variables (except literal constants).

## defineSlots() (Vue 3.3+, TypeScript only)

Provide type hints for slot props.

```vue
<script setup lang="ts">
const slots = defineSlots<{
  default(props: { msg: string }): any
  header(props: { title: string }): any
  footer(): any
}>()
</script>

<template>
  <div>
    <slot name="header" :title="pageTitle"></slot>
    <slot :msg="message"></slot>
    <slot name="footer"></slot>
  </div>
</template>
```

Returns `slots` object (equivalent to `useSlots()`).

## useSlots() & useAttrs()

Access slots and attrs in `<script setup>`.

```vue
<script setup>
import { useSlots, useAttrs } from 'vue'

const slots = useSlots()
const attrs = useAttrs()

// Rarely needed - prefer $slots and $attrs in template
</script>

<template>
  <div v-if="$slots.header">
    <slot name="header"></slot>
  </div>
  <div :class="$attrs.class">
    {{ $attrs['data-id'] }}
  </div>
</template>
```

**When to use:** Needed in `<script>` for programmatic slot/attrs access.

## Using Components

Import and use directly - no registration needed:

```vue
<script setup>
import MyComponent from './MyComponent.vue'
</script>

<template>
  <MyComponent />
  <!-- kebab-case also works -->
  <my-component />
</template>
```

### Dynamic Components

```vue
<script setup>
import Foo from './Foo.vue'
import Bar from './Bar.vue'
</script>

<template>
  <component :is="condition ? Foo : Bar" />
</template>
```

### Recursive Components

SFC can reference itself via filename:

```vue
<!-- FileTree.vue -->
<script setup>
import { ref } from 'vue'

defineProps(['node'])
</script>

<template>
  <div>
    {{ node.name }}
    <FileTree
      v-for="child in node.children"
      :key="child.id"
      :node="child"
    />
  </div>
</template>
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

## Custom Directives

Must follow `vNameOfDirective` naming pattern:

```vue
<script setup>
const vMyDirective = {
  beforeMount: (el) => {
    el.focus()
  },
  mounted: (el) => {
    console.log('mounted')
  }
}
</script>

<template>
  <input v-my-directive />
</template>
```

Import and rename:

```vue
<script setup>
import { myDirective as vMyDirective } from './directives'
</script>

<template>
  <div v-my-directive></div>
</template>
```

## Generics (TypeScript)

Generic type parameters via `generic` attribute:

```vue
<script setup lang="ts" generic="T">
defineProps<{
  items: T[]
  selected: T
}>()
</script>
```

### Multiple Parameters & Constraints

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

### Default Types

```vue
<script setup lang="ts" generic="T = string">
defineProps<{
  value: T
}>()
</script>
```

### Reference Generic Component

Use `vue-component-type-helpers` package:

```vue
<script setup lang="ts">
import { ref } from 'vue'
import type { ComponentExposed } from 'vue-component-type-helpers'
import GenericComponent from './GenericComponent.vue'

// InstanceType won't work with generic components!
const instance = ref<ComponentExposed<typeof GenericComponent>>()
</script>
```

## Top-Level await

Code becomes `async setup()`:

```vue
<script setup>
const post = await fetch('/api/post/1').then(r => r.json())
// Component is now async
</script>
```

**Requirements:** Must use with `<Suspense>` component.

**Behavior:** Preserves component instance context after `await`.

## Usage with Normal `<script>`

Combine when needed:

```vue
<script>
// Module scope - runs once
runSideEffectOnce()

export default {
  inheritAttrs: false
}
</script>

<script setup>
// Setup scope - runs per instance
import { ref } from 'vue'
const count = ref(0)
</script>
```

**When to use:**
- Side effects that run once (pre-3.3)
- Named exports
- Options not expressible in `<script setup>` (pre-3.3)

**Don't:**
- Duplicate props/emits/expose between blocks
- Mix Options API and Composition API in confusing ways

## Import Statements

Follow ES module spec. Can use build tool aliases:

```vue
<script setup>
import { ref } from 'vue'
import { helper } from './utils'
import { Component } from '@/components'  // @ alias
import { Other } from '~/lib'            // ~ alias
</script>
```

## Restrictions

1. **Cannot use `src` attribute** - `<script setup>` must be inline
2. **No In-DOM root template** - Can't use with apps mounted to raw HTML
3. **Different execution semantics** - Moving to external `.js`/`.ts` loses SFC context

## Migration from Options API

| Options API | Composition API (`<script setup>`) |
|---|---|
| `data()` | `ref()`, `reactive()` |
| `computed` | `computed()` |
| `methods` | Regular functions |
| `watch` | `watch()`, `watchEffect()` |
| `mounted()`, etc. | `onMounted()`, etc. |
| `props` | `defineProps()` |
| `emits` | `defineEmits()` |
| `expose` | `defineExpose()` |
| Component options | `defineOptions()` (3.3+) |

## Best Practices

1. **Always use `<script setup>`** for new components
2. **Prefer type-based props** when using TypeScript
3. **Use reactive props destructure** (3.5+) for cleaner code
4. **Explicit `defineExpose`** - Only expose what parent needs
5. **Named models** - Use `defineModel('name')` for multiple v-models
6. **PascalCase components** - Consistent naming in templates
7. **Avoid `withDefaults`** - Upgrade to 3.5+ for native defaults
