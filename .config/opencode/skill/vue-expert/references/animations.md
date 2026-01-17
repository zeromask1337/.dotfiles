# Animation Techniques

Vue provides the [`<Transition>`](/guide/built-ins/transition) and [`<TransitionGroup>`](/guide/built-ins/transition-group) components for handling enter / leave and list transitions. However, there are many other ways of using animations on the web, even in a Vue application. Here we will discuss a few additional techniques.

## Class-based Animations

For elements that are not entering / leaving the DOM, we can trigger animations by dynamically adding a CSS class:

**Composition API:**

```js
const disabled = ref(false)

function warnDisabled() {
  disabled.value = true
  setTimeout(() => {
    disabled.value = false
  }, 1500)
}
```

**Options API:**

```js
export default {
  data() {
    return {
      disabled: false
    }
  },
  methods: {
    warnDisabled() {
      this.disabled = true
      setTimeout(() => {
        this.disabled = false
      }, 1500)
    }
  }
}
```

```vue-html
<div :class="{ shake: disabled }">
  <button @click="warnDisabled">Click me</button>
  <span v-if="disabled">This feature is disabled!</span>
</div>
```

```css
.shake {
  animation: shake 0.82s cubic-bezier(0.36, 0.07, 0.19, 0.97) both;
  transform: translate3d(0, 0, 0);
}

@keyframes shake {
  10%,
  90% {
    transform: translate3d(-1px, 0, 0);
  }

  20%,
  80% {
    transform: translate3d(2px, 0, 0);
  }

  30%,
  50%,
  70% {
    transform: translate3d(-4px, 0, 0);
  }

  40%,
  60% {
    transform: translate3d(4px, 0, 0);
  }
}
```

## State-driven Animations

Some transition effects can be applied by interpolating values, for instance by binding a style to an element while an interaction occurs. Take this example for instance:

**Composition API:**

```js
const x = ref(0)

function onMousemove(e) {
  x.value = e.clientX
}
```

**Options API:**

```js
export default {
  data() {
    return {
      x: 0
    }
  },
  methods: {
    onMousemove(e) {
      this.x = e.clientX
    }
  }
}
```

```vue-html
<div
  @mousemove="onMousemove"
  :style="{ backgroundColor: `hsl(${x}, 80%, 50%)` }"
  class="movearea"
>
  <p>Move your mouse across this div...</p>
  <p>x: {{ x }}</p>
</div>
```

```css
.movearea {
  transition: 0.3s background-color ease;
}
```

In addition to color, you can also use style bindings to animate transform, width, or height. You can even animate SVG paths using spring physics - after all, they are all attribute data bindings.

## Animating with Watchers

With some creativity, we can use watchers to animate anything based on some numerical state. For example, we can animate the number itself:

**Composition API:**

```js
import { ref, reactive, watch } from 'vue'
import gsap from 'gsap'

const number = ref(0)
const tweened = reactive({
  number: 0
})

// Note: For inputs greater than Number.MAX_SAFE_INTEGER (9007199254740991),
// the result may be inaccurate due to limitations in JavaScript number precision.
watch(number, (n) => {
  gsap.to(tweened, { duration: 0.5, number: Number(n) || 0 })
})
```

```vue-html
Type a number: <input v-model.number="number" />
<p>{{ tweened.number.toFixed(0) }}</p>
```

**Options API:**

```js
import gsap from 'gsap'

export default {
  data() {
    return {
      number: 0,
      tweened: 0
    }
  },
  // Note: For inputs greater than Number.MAX_SAFE_INTEGER (9007199254740991),
  // the result may be inaccurate due to limitations in JavaScript number precision.
  watch: {
    number(n) {
      gsap.to(this, { duration: 0.5, tweened: Number(n) || 0 })
    }
  }
}
```

```vue-html
Type a number: <input v-model.number="number" />
<p>{{ tweened.toFixed(0) }}</p>
```

## `<Transition>` Component

Provides animated transition effects to a **single** element or component.

### Props

```ts
interface TransitionProps {
  /**
   * Used to automatically generate transition CSS class names.
   * e.g. `name: 'fade'` will auto expand to `.fade-enter`,
   * `.fade-enter-active`, etc.
   */
  name?: string
  /**
   * Whether to apply CSS transition classes.
   * Default: true
   */
  css?: boolean
  /**
   * Specifies the type of transition events to wait for to
   * determine transition end timing.
   * Default behavior is auto detecting the type that has
   * longer duration.
   */
  type?: 'transition' | 'animation'
  /**
   * Specifies explicit durations of the transition.
   * Default behavior is wait for the first `transitionend`
   * or `animationend` event on the root transition element.
   */
  duration?: number | { enter: number; leave: number }
  /**
   * Controls the timing sequence of leaving/entering transitions.
   * Default behavior is simultaneous.
   */
  mode?: 'in-out' | 'out-in' | 'default'
  /**
   * Whether to apply transition on initial render.
   * Default: false
   */
  appear?: boolean

  /**
   * Props for customizing transition classes.
   * Use kebab-case in templates, e.g. enter-from-class="xxx"
   */
  enterFromClass?: string
  enterActiveClass?: string
  enterToClass?: string
  appearFromClass?: string
  appearActiveClass?: string
  appearToClass?: string
  leaveFromClass?: string
  leaveActiveClass?: string
  leaveToClass?: string
}
```

### Events

- `@before-enter`
- `@before-leave`
- `@enter`
- `@leave`
- `@appear`
- `@after-enter`
- `@after-leave`
- `@after-appear`
- `@enter-cancelled`
- `@leave-cancelled` (`v-show` only)
- `@appear-cancelled`

### Examples

Simple element:

```vue-html
<Transition>
  <div v-if="ok">toggled content</div>
</Transition>
```

Forcing a transition by changing the `key` attribute:

```vue-html
<Transition>
  <div :key="text">{{ text }}</div>
</Transition>
```

Dynamic component, with transition mode + animate on appear:

```vue-html
<Transition name="fade" mode="out-in" appear>
  <component :is="view"></component>
</Transition>
```

Listening to transition events:

```vue-html
<Transition @after-enter="onTransitionComplete">
  <div v-show="ok">toggled content</div>
</Transition>
```

## `<TransitionGroup>` Component

Provides transition effects for **multiple** elements or components in a list.

### Props

`<TransitionGroup>` accepts the same props as `<Transition>` except `mode`, plus two additional props:

```ts
interface TransitionGroupProps extends Omit<TransitionProps, 'mode'> {
  /**
   * If not defined, renders as a fragment.
   */
  tag?: string
  /**
   * For customizing the CSS class applied during move transitions.
   * Use kebab-case in templates, e.g. move-class="xxx"
   */
  moveClass?: string
}
```

### Events

`<TransitionGroup>` emits the same events as `<Transition>`.

### Details

By default, `<TransitionGroup>` doesn't render a wrapper DOM element, but one can be defined via the `tag` prop.

Note that every child in a `<transition-group>` must be [**uniquely keyed**](/guide/essentials/list#maintaining-state-with-key) for the animations to work properly.

`<TransitionGroup>` supports moving transitions via CSS transform. When a child's position on screen has changed after an update, it will get applied a moving CSS class (auto generated from the `name` attribute or configured with the `move-class` prop). If the CSS `transform` property is "transition-able" when the moving class is applied, the element will be smoothly animated to its destination using the [FLIP technique](https://aerotwist.com/blog/flip-your-animations/).

### Example

```vue-html
<TransitionGroup tag="ul" name="slide">
  <li v-for="item in items" :key="item.id">
    {{ item.text }}
  </li>
</TransitionGroup>
```

## `<KeepAlive>` with Transitions

`<KeepAlive>` can be used together with `<Transition>`:

```vue-html
<Transition>
  <KeepAlive>
    <component :is="view"></component>
  </KeepAlive>
</Transition>
```

## Additional Resources

- [Guide - Transition](/guide/built-ins/transition)
- [Guide - TransitionGroup](/guide/built-ins/transition-group)
