# SCShareableContent Reference

SCShareableContent is the entry point for discovering available screen content.

## Overview

Provides access to displays, windows, and applications that can be captured.

## Methods

### current

```swift
class var current: SCShareableContent { get async throws }
```

Returns all currently shareable content (displays, windows, applications).

**Throws:**
- `SCStreamError.noCaptureSource` - No capture source available
- `SCStreamError.userStopped` - User denied permission

**Example:**
```swift
do {
    let content = try await SCShareableContent.current
    print("Found \(content.displays.count) displays")
    print("Found \(content.windows.count) windows")
    print("Found \(content.applications.count) applications")
} catch {
    print("Failed to get shareable content: \(error)")
}
```

### getExcludingDesktopWindows(_:onScreenWindowsOnly:)

```swift
class func getExcludingDesktopWindows(
    _ excludeDesktopWindows: Bool,
    onScreenWindowsOnly: Bool
) async throws -> SCShareableContent
```

Returns shareable content with filtering options.

**Parameters:**
- `excludeDesktopWindows` - If true, excludes desktop background windows
- `onScreenWindowsOnly` - If true, only includes windows currently on screen

**Example:**
```swift
let content = try await SCShareableContent.getExcludingDesktopWindows(
    false,
    onScreenWindowsOnly: true
)
```

## Properties

### displays

```swift
var displays: [SCDisplay] { get }
```

Array of available displays. Each display represents a physical monitor.

**SCDisplay Properties:**
- `displayID: CGDirectDisplayID` - Unique display identifier
- `width: Int` - Display width in pixels
- `height: Int` - Display height in pixels
- `frame: CGRect` - Display frame in global coordinates

### windows

```swift
var windows: [SCWindow] { get }
```

Array of shareable windows across all applications.

**SCWindow Properties:**
- `windowID: CGWindowID` - Unique window identifier
- `frame: CGRect` - Window frame in global coordinates
- `title: String?` - Window title (if available)
- `owningApplication: SCRunningApplication` - Parent application
- `onScreen: Bool` - Whether window is currently visible

### applications

```swift
var applications: [SCRunningApplication] { get }
```

Array of running applications that have shareable content.

**SCRunningApplication Properties:**
- `processID: pid_t` - Process identifier
- `bundleIdentifier: String?` - App bundle ID
- `applicationName: String` - Display name

## Usage Patterns

### Filter by Application

```swift
let content = try await SCShareableContent.current
let safariWindows = content.windows.filter { window in
    window.owningApplication.bundleIdentifier == "com.apple.Safari"
}
```

### Find Main Display

```swift
let content = try await SCShareableContent.current
let mainDisplay = content.displays.first { $0.displayID == CGMainDisplayID() }
```

### Exclude System Windows

```swift
let content = try await SCShareableContent.current
let userWindows = content.windows.filter { window in
    !window.owningApplication.bundleIdentifier?.hasPrefix("com.apple.") ?? false
}
```
