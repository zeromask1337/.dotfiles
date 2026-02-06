# SCContentFilter Reference

SCContentFilter determines what content to capture in a stream.

## Overview

Create filters to specify exactly which display, window, or application content to include or exclude from capture.

## Initializers

### Display Filter

```swift
init(display: SCDisplay, excludingWindows: [SCWindow])
```

Captures entire display excluding specific windows.

**Parameters:**
- `display` - The display to capture
- `excludingWindows` - Windows to exclude from capture

**Example:**
```swift
let filter = SCContentFilter(
    display: display,
    excludingWindows: [excludedWindow]
)
```

### Window Filter

```swift
init(window: SCWindow)
```

Captures a single specific window.

**Parameters:**
- `window` - The window to capture

**Example:**
```swift
let filter = SCContentFilter(window: targetWindow)
```

### Application Filter

```swift
init(display: SCDisplay, excludingApplications: [SCRunningApplication], exceptingWindows: [SCWindow])
```

Captures display excluding entire applications, with window-level exceptions.

**Parameters:**
- `display` - The display to capture
- `excludingApplications` - Applications to completely exclude
- `exceptingWindows` - Windows to include even if their app is excluded

**Example:**
```swift
let filter = SCContentFilter(
    display: display,
    excludingApplications: [safariApp],
    exceptingWindows: [importantSafariWindow]
)
```

## Properties

### style

```swift
var style: SCShareableContentStyle { get }
```

The type of content being captured.

**SCShareableContentStyle:**
- `.display` - Full display capture
- `.window` - Single window capture
- `.application` - Application-level capture

### display

```swift
var display: SCDisplay? { get }
```

The display being captured (if applicable).

### window

```swift
var window: SCWindow? { get }
```

The window being captured (if applicable).

### pointPixelScale

```swift
var pointPixelScale: Float { get }
```

Scaling factor from points to pixels for the filtered content.

## Usage Patterns

### Exclude Own Application

```swift
let content = try await SCShareableContent.current
let myApp = content.applications.first { $0.bundleIdentifier == Bundle.main.bundleIdentifier }

let filter = SCContentFilter(
    display: display,
    excludingApplications: myApp.map { [$0] } ?? [],
    exceptingWindows: []
)
```

### Capture All Except Menu Bar

```swift
let content = try await SCShareableContent.current

// Find menu bar windows (usually have y position at 0 and small height)
let menuBarWindows = content.windows.filter { window in
    window.frame.origin.y == 0 && window.frame.height < 30
}

let filter = SCContentFilter(
    display: display,
    excludingWindows: menuBarWindows
)
```

### Dynamic Filter Updates

```swift
// Update filter while stream is running
let newFilter = SCContentFilter(window: differentWindow)
try await stream.updateFilter(newFilter)
```
