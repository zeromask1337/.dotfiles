# TypeScript

Vue 3 is TypeScript-first internally and supports TS well via SFC tooling.

## Recommended setup

- Use `<script setup lang="ts">` in SFCs.
- Use the official VS Code extension **Vue - Official** for template type checking.
- Use `vue-tsc` for CI / CLI type checking and for generating `d.ts` from SFCs.

## Props

Type-based props (no runtime object):

```vue
<script setup lang="ts">
const props = defineProps<{
  msg: string
  count?: number
}>()
</script>
```

Default values:
- Vue 3.5+: use destructuring defaults
- Vue <= 3.4: use `withDefaults()`

## Emits

```vue
<script setup lang="ts">
const emit = defineEmits<{
  save: [id: string]
  cancel: []
}>()
</script>
```

## Slots

Prefer `defineSlots()` (Vue 3.3+):

```vue
<script setup lang="ts">
const slots = defineSlots<{
  default(props: { msg: string }): any
  header(): any
}>()
</script>
```

## Template refs typing

TypeScript + tooling can infer template ref element/component types based on usage.

```vue
<script setup lang="ts">
import { ref, onMounted } from 'vue'

const inputEl = ref<HTMLInputElement | null>(null)

onMounted(() => {
  inputEl.value?.focus()
})
</script>

<template>
  <input ref="inputEl" />
</template>
```

## Provide / inject typing

Use `InjectionKey<T>` (symbol) to sync types.

```ts
import { InjectionKey, provide, inject } from 'vue'

type Theme = 'light' | 'dark'

const ThemeKey: InjectionKey<Theme> = Symbol('theme')

provide(ThemeKey, 'dark')

const theme = inject(ThemeKey)
```

## TSX / JSX notes

- Vue supports TSX/JSX.
- For TSX, TypeScript config typically needs `"jsx": "preserve"`.
- Vue 3.4+ does not implicitly register global `JSX` namespace; projects should follow Vue JSX typing guidance.

## Versioning note

Vue may ship incompatible changes to TypeScript definitions between **minor** versions (due to TS compatibility and new TS features). Pin Vue with a semver range that locks the current minor and upgrade intentionally.
