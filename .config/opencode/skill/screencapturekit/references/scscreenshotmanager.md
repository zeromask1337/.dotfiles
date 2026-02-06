# SCScreenshotManager Reference

SCScreenshotManager provides methods for capturing still images from the screen.

## Overview

Replaces the deprecated `CGWindowListCreateImage` function with a modern ScreenCaptureKit-based API. Available in macOS 14.0+.

## Methods

### captureImage

```swift
class func captureImage(
    contentFilter: SCContentFilter,
    configuration: SCStreamConfiguration
) async throws -> CGImage
```

Captures a screenshot as a `CGImage`.

**Parameters:**
- `contentFilter` - SCContentFilter defining what to capture
- `configuration` - SCStreamConfiguration with capture settings

**Returns:**
- `CGImage` - The captured screenshot

**Throws:**
- `SCStreamError` errors for capture failures

**Example:**
```swift
import ScreenCaptureKit
import CoreGraphics

func captureScreenshot(of display: SCDisplay) async throws -> CGImage {
    let filter = SCContentFilter(display: display, excludingWindows: [])
    
    let config = SCStreamConfiguration()
    config.width = display.width
    config.height = display.height
    config.pixelFormat = kCVPixelFormatType_32BGRA
    config.showsCursor = false
    
    let image = try await SCScreenshotManager.captureImage(
        contentFilter: filter,
        configuration: config
    )
    
    return image
}
```

### captureSampleBuffer

```swift
class func captureSampleBuffer(
    contentFilter: SCContentFilter,
    configuration: SCStreamConfiguration
) async throws -> CMSampleBuffer
```

Captures a screenshot as a `CMSampleBuffer` for advanced pixel format access.

**Parameters:**
- `contentFilter` - SCContentFilter defining what to capture
- `configuration` - SCStreamConfiguration with capture settings

**Returns:**
- `CMSampleBuffer` - Sample buffer containing image data

**Benefits:**
- Access to raw pixel data via `CVImageBuffer`
- More pixel format options
- Can extract timing information

**Example:**
```swift
func captureScreenshotAsSampleBuffer(display: SCDisplay) async throws -> CMSampleBuffer {
    let filter = SCContentFilter(display: display, excludingWindows: [])
    let config = SCStreamConfiguration()
    config.pixelFormat = kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange
    
    let sampleBuffer = try await SCScreenshotManager.captureSampleBuffer(
        contentFilter: filter,
        configuration: config
    )
    
    return sampleBuffer
}

// Process sample buffer
func processSampleBuffer(_ sampleBuffer: CMSampleBuffer) {
    guard let imageBuffer = sampleBuffer.imageBuffer else { return }
    
    // Get format description
    let formatDescription = CMSampleBufferGetFormatDescription(sampleBuffer)
    let mediaType = CMFormatDescriptionGetMediaType(formatDescription!)
    
    // Lock and access pixels
    CVPixelBufferLockBaseAddress(imageBuffer, .readOnly)
    defer { CVPixelBufferUnlockBaseAddress(imageBuffer, .readOnly) }
    
    // Access pixel data...
}
```

## Usage Patterns

### Full Display Screenshot

```swift
func captureFullDisplay() async throws -> CGImage {
    let content = try await SCShareableContent.current
    guard let display = content.displays.first else {
        throw CaptureError.noDisplays
    }
    
    let filter = SCContentFilter(display: display, excludingWindows: [])
    let config = SCStreamConfiguration()
    config.pixelFormat = kCVPixelFormatType_32BGRA
    
    return try await SCScreenshotManager.captureImage(
        contentFilter: filter,
        configuration: config
    )
}
```

### Window Screenshot

```swift
func captureWindow(_ window: SCWindow) async throws -> CGImage {
    let filter = SCContentFilter(window: window)
    let config = SCStreamConfiguration()
    config.pixelFormat = kCVPixelFormatType_32BGRA
    
    return try await SCScreenshotManager.captureImage(
        contentFilter: filter,
        configuration: config
    )
}
```

### Cropped Screenshot

```swift
func captureCroppedRegion(display: SCDisplay, rect: CGRect) async throws -> CGImage {
    let filter = SCContentFilter(display: display, excludingWindows: [])
    
    let config = SCStreamConfiguration()
    config.sourceRect = rect
    config.width = Int(rect.width)
    config.height = Int(rect.height)
    config.pixelFormat = kCVPixelFormatType_32BGRA
    
    return try await SCScreenshotManager.captureImage(
        contentFilter: filter,
        configuration: config
    )
}
```

### Save Screenshot to File

```swift
import CoreGraphics

func saveScreenshotToFile(display: SCDisplay, url: URL) async throws {
    let image = try await captureScreenshot(of: display)
    
    guard let destination = CGImageDestinationCreateWithURL(
        url as CFURL,
        UTType.png.identifier as CFString,
        1,
        nil
    ) else {
        throw CaptureError.fileCreationFailed
    }
    
    CGImageDestinationAddImage(destination, image, nil)
    CGImageDestinationFinalize(destination)
}
```

### With System Picker

```swift
class ScreenshotManager: NSObject, SCContentSharingPickerObserver {
    private var continuation: CheckedContinuation<CGImage, Error>?
    
    func captureWithPicker() async throws -> CGImage {
        let picker = SCContentSharingPicker.shared
        picker.add(self)
        
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            picker.present()
        }
    }
    
    func contentSharingPicker(
        _ picker: SCContentSharingPicker,
        didUpdateWith filter: SCContentFilter,
        for stream: SCStream?
    ) {
        Task {
            do {
                let config = SCStreamConfiguration()
                config.pixelFormat = kCVPixelFormatType_32BGRA
                
                let image = try await SCScreenshotManager.captureImage(
                    contentFilter: filter,
                    configuration: config
                )
                
                continuation?.resume(returning: image)
            } catch {
                continuation?.resume(throwing: error)
            }
            
            picker.remove(self)
        }
    }
}
```

## Comparison with CGWindowListCreateImage

| Feature | CGWindowListCreateImage | SCScreenshotManager |
|---------|------------------------|---------------------|
| Availability | macOS 10.5+ | macOS 14.0+ |
| Status | Deprecated | Current |
| Window filtering | Window ID based | SCContentFilter |
| Pixel formats | Limited | Extensive |
| Async support | No | Yes (async/await) |
| Audio capture | No | Via stream |
| Performance | Synchronous | Optimized |

## Migration from CGWindowListCreateImage

**Old API:**
```swift
// Deprecated
let image = CGWindowListCreateImage(
    .null,
    .optionAll,
    kCGNullWindowID,
    .bestResolution
)
```

**New API:**
```swift
// Modern replacement
let content = try await SCShareableContent.current
let display = content.displays.first!
let filter = SCContentFilter(display: display, excludingWindows: [])
let config = SCStreamConfiguration()

let image = try await SCScreenshotManager.captureImage(
    contentFilter: filter,
    configuration: config
)
```
