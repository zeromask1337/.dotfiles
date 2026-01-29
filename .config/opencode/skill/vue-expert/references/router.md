# Vue Router (Ecosystem)

Vue Router is the official router for Vue SPAs.

## When to use

- Any SPA with multiple views / URLs
- Nested routes, layouts, guards
- History mode / hash mode routing

## Basics

- `<RouterView>` renders the matched route component.
- `useRoute()` gives current route state.
- `useRouter()` performs navigation.

```vue
<script setup>
import { useRoute, useRouter } from 'vue-router'

const route = useRoute()
const router = useRouter()

function goHome() {
  router.push('/')
}
</script>

<template>
  <div>Path: {{ route.path }}</div>
  <button @click="goHome">Home</button>
</template>
```

## Lazy loading routes

Prefer lazy-loading route components for large apps.

```ts
const routes = [
  {
    path: '/settings',
    component: () => import('./views/SettingsView.vue')
  }
]
```

Note: router-level lazy loading is distinct from `defineAsyncComponent()`.

## Accessibility note

On route changes, manage focus (e.g. focus a skip-link target at top of page) to help keyboard/screen-reader users.
