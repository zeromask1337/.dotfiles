# Web Accessibility in Vue.js

Complete guide to building accessible Vue.js applications following WCAG guidelines.

## Core Accessibility Principles (WCAG POUR)

1. **Perceivable** - Users must be able to perceive the information being presented
2. **Operable** - Interface forms, controls, and navigation are operable
3. **Understandable** - Information and the operation of user interface must be understandable
4. **Robust** - Users must be able to access content as technologies advance

## Skip Link Pattern

Add skip link at top of App.vue for keyboard navigation:

```vue
<script setup>
import { ref, watch } from 'vue'
import { useRoute } from 'vue-router'

const route = useRoute()
const backToTop = ref()
const skipLink = ref()

watch(() => route.path, () => {
  backToTop.value.focus()
})
</script>

<template>
  <span ref="backToTop" tabindex="-1" />
  <ul class="skip-links">
    <li>
      <a href="#main" ref="skipLink" class="skip-link">Skip to main content</a>
    </li>
  </ul>
</template>

<style>
.skip-links {
  list-style: none;
}
.skip-link {
  white-space: nowrap;
  margin: 1em auto;
  top: 0;
  position: fixed;
  left: 50%;
  margin-left: -72px;
  opacity: 0;
}
.skip-link:focus {
  opacity: 1;
  background-color: white;
  padding: 0.5em;
  border: 1px solid black;
}
</style>
```

## Semantic HTML Landmarks

Use semantic HTML elements with appropriate ARIA roles:

| HTML Element | ARIA Role | Purpose |
|---|---|---|
| `<header>` | `role="banner"` | Prime heading: title of the page |
| `<nav>` | `role="navigation"` | Collection of navigation links |
| `<main>` | `role="main"` | Main content of the document |
| `<footer>` | `role="contentinfo"` | Footer information |
| `<aside>` | `role="complementary"` | Supporting content |
| `<section>` | `role="region"` | Content region (requires label) |
| `<form>` | `role="form"` | Form elements |

```vue
<template>
  <main role="main" aria-labelledby="main-title">
    <h1 id="main-title">Main Title</h1>
    <section aria-labelledby="section-title-1">
      <h2 id="section-title-1">Section Title</h2>
      <!-- Content -->
    </section>
  </main>
</template>
```

## Form Accessibility

### Semantic Form Elements

Always use proper labels and associate them with inputs:

```vue
<script setup>
import { reactive } from 'vue'

const formItems = reactive([
  { id: 'name', label: 'Name', type: 'text', value: '' },
  { id: 'email', label: 'Email', type: 'email', value: '' }
])
</script>

<template>
  <form action="/dataCollectionLocation" method="post" autocomplete="on">
    <div v-for="item in formItems" :key="item.id" class="form-item">
      <label :for="item.id">{{ item.label }}: </label>
      <input
        :type="item.type"
        :id="item.id"
        :name="item.id"
        v-model="item.value"
      />
    </div>
    <button type="submit">Submit</button>
  </form>
</template>
```

### ARIA Attributes

**aria-label** - Provides accessible name:
```vue
<template>
  <input
    type="text"
    name="search"
    id="search"
    :aria-label="searchLabel"
  />
</template>
```

**aria-labelledby** - Links to visible label(s):
```vue
<template>
  <form action="/submit" method="post" autocomplete="on">
    <h1 id="billing">Billing</h1>
    <div class="form-item">
      <label for="name">Name: </label>
      <input
        type="text"
        id="name"
        v-model="name"
        aria-labelledby="billing name"
      />
    </div>
  </form>
</template>
```

**aria-describedby** - Provides additional description:
```vue
<template>
  <div>
    <label for="dob">Date of Birth: </label>
    <input
      type="date"
      id="dob"
      aria-describedby="dob-instructions"
    />
    <p id="dob-instructions">MM/DD/YYYY</p>
  </div>
</template>
```

### Placeholder Best Practices

**Avoid placeholders** - they often fail color contrast and confuse users.

If you must use placeholders:
- Ensure they meet color contrast ratio (4.5:1 for normal text)
- Don't rely on them as the only label
- Consider using helper text instead

```vue
<template>
  <div>
    <label for="email">Email: </label>
    <input
      type="email"
      id="email"
      v-model="email"
      aria-describedby="email-help"
    />
    <p id="email-help">Enter your email address</p>
  </div>
</template>
```

## Button Accessibility

Always specify button type in forms:

```vue
<template>
  <form @submit="handleSubmit">
    <button type="button" @click="cancel">Cancel</button>
    <button type="submit">Submit</button>
    
    <!-- Input buttons -->
    <input type="button" value="Cancel" @click="cancel" />
    <input type="submit" value="Submit" />
  </form>
</template>
```

## Hiding Content Accessibly

### Visual-Only Hiding

Hide visually but keep for screen readers:

```vue
<template>
  <label for="search" class="hidden-visually">Search: </label>
  <input type="text" id="search" v-model="search" />
  <button type="submit">
    <i class="fas fa-search" aria-hidden="true"></i>
    <span class="hidden-visually">Search</span>
  </button>
</template>

<style>
.hidden-visually {
  position: absolute;
  overflow: hidden;
  white-space: nowrap;
  margin: 0;
  padding: 0;
  height: 1px;
  width: 1px;
  clip: rect(0 0 0 0);
  clip-path: inset(100%);
}
</style>
```

### aria-hidden="true"

Hide from screen readers (for decorative elements):

```vue
<template>
  <button>
    <i class="icon-save" aria-hidden="true"></i>
    Save Document
  </button>
</template>
```

**Never use on focusable elements!**

## Functional Images

For images that perform actions:

```vue
<template>
  <form role="search">
    <label for="search" class="hidden-visually">Search: </label>
    <input type="text" id="search" v-model="search" />
    <input
      type="image"
      class="btnImg"
      src="/search-icon.svg"
      alt="Search"
    />
  </form>
</template>
```

## Headings Structure

- Use proper heading hierarchy: h1 → h2 → h3 (don't skip levels)
- One h1 per page
- Headings should be descriptive

```vue
<template>
  <main>
    <h1>Page Title</h1>
    <section>
      <h2>Section Title</h2>
      <h3>Subsection</h3>
    </section>
    <section>
      <h2>Another Section</h2>
    </section>
  </main>
</template>
```

## Keyboard Navigation

Ensure all interactive elements are keyboard accessible:

```vue
<script setup>
import { ref } from 'vue'

const selected = ref(0)

function handleKeydown(event) {
  if (event.key === 'ArrowDown') {
    selected.value = Math.min(selected.value + 1, items.length - 1)
  } else if (event.key === 'ArrowUp') {
    selected.value = Math.max(selected.value - 1, 0)
  }
}
</script>

<template>
  <div
    role="listbox"
    tabindex="0"
    @keydown="handleKeydown"
    aria-label="Select an item"
  >
    <div
      v-for="(item, i) in items"
      :key="item.id"
      role="option"
      :aria-selected="selected === i"
    >
      {{ item.name }}
    </div>
  </div>
</template>
```

## Focus Management

Manage focus for dynamic content:

```vue
<script setup>
import { ref, nextTick } from 'vue'

const showModal = ref(false)
const modalButton = ref()

async function openModal() {
  showModal.value = true
  await nextTick()
  modalButton.value.focus()
}
</script>

<template>
  <button @click="openModal">Open Modal</button>
  <div v-if="showModal" role="dialog" aria-modal="true">
    <button ref="modalButton" @click="showModal = false">Close</button>
  </div>
</template>
```

## Color Contrast

Ensure sufficient contrast ratios:
- **Normal text**: Minimum 4.5:1
- **Large text** (18pt+ or 14pt+ bold): Minimum 3:1
- **UI components**: Minimum 3:1

Test with:
- [WebAIM Color Contrast Checker](https://webaim.org/resources/contrastchecker/)
- Chrome DevTools Accessibility panel

## Testing Tools

- **Screen Readers**: NVDA (Windows), VoiceOver (Mac), JAWS
- **Browser Extensions**: 
  - Lighthouse
  - WAVE Evaluation Tool
  - ARC Toolkit
- **Keyboard Testing**: Tab through entire page
- **Color Tools**: Color Oracle, NerdeFocus

## Common Patterns

### Accessible Modal

```vue
<script setup>
import { ref, watch } from 'vue'

const isOpen = ref(false)
const closeButton = ref()

watch(isOpen, async (newVal) => {
  if (newVal) {
    await nextTick()
    closeButton.value?.focus()
  }
})
</script>

<template>
  <div
    v-if="isOpen"
    role="dialog"
    aria-modal="true"
    aria-labelledby="modal-title"
  >
    <h2 id="modal-title">Modal Title</h2>
    <button ref="closeButton" @click="isOpen = false">Close</button>
  </div>
</template>
```

### Accessible Dropdown

```vue
<script setup>
import { ref } from 'vue'

const expanded = ref(false)
const selected = ref('')
</script>

<template>
  <div class="dropdown">
    <button
      @click="expanded = !expanded"
      aria-haspopup="listbox"
      :aria-expanded="expanded"
    >
      {{ selected || 'Select an option' }}
    </button>
    <ul v-show="expanded" role="listbox">
      <li
        v-for="option in options"
        :key="option"
        role="option"
        @click="selected = option; expanded = false"
      >
        {{ option }}
      </li>
    </ul>
  </div>
</template>
```

## Resources

- [WCAG 2.1 Guidelines](https://www.w3.org/TR/WCAG21/)
- [WAI-ARIA 1.2](https://www.w3.org/TR/wai-aria-1.2/)
- [WAI-ARIA Authoring Practices](https://www.w3.org/TR/wai-aria-practices-1.2/)
- [WebAIM](https://webaim.org/)
