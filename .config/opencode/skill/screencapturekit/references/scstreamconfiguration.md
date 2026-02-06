# SCStreamConfiguration Reference

SCStreamConfiguration defines how content is captured and formatted.

## Overview

Configure dimensions, pixel format, frame rate, audio capture, and other stream parameters.

## Properties

### Dimensions

```swift
var width: Int
var height: Int
```

Output dimensions in pixels. If not set, uses source dimensions.

**Example:**
```swift
config.width = 1920
config.height = 1080
```

### Frame Rate

```swift
var minimumFrameInterval: CMTime
```

Controls the capture frame rate. Use `CMTime(value: 1, timescale: FPS)`.

**Example:**
```swift
// 30 FPS
config.minimumFrameInterval = CMTime(value: 1, timescale: 30)

// 60 FPS
config.minimumFrameInterval = CMTime(value: 1, timescale: 60)
```

### Pixel Format

```swift
var pixelFormat: OSType
```

The pixel format for captured frames.

**Common Formats:**
- `kCVPixelFormatType_32BGRA` - 32-bit BGRA (most common)
- `kCVPixelFormatType_32ARGB` - 32-bit ARGB
- `kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange` - Bi-planar YCbCr
- `kCVPixelFormatType_420YpCbCr8BiPlanarFullRange` - Full range YCbCr

**Example:**
```swift
config.pixelFormat = kCVPixelFormatType_32BGRA
```

### Cursor

```swift
var showsCursor: Bool
```

Whether to include the cursor in the capture. Default is `false`.

**Example:**
```swift
config.showsCursor = true
```

### Audio Capture

```swift
var capturesAudio: Bool
var captureMicrophone: Bool
```

Enable application audio and/or microphone capture.

**Example:**
```swift
config.capturesAudio = true       // Capture app audio
config.captureMicrophone = true   // Capture microphone
```

### Scaling

```swift
var scalesToFit: Bool
```

Whether to scale content to fit configured dimensions. Default is `true`.

**Example:**
```swift
config.scalesToFit = true  // Scale to fit
config.scalesToFit = false // Crop instead
```

### Source Rectangle

```swift
var sourceRect: CGRect
```

Region of source content to capture. Useful for partial capture.

**Example:**
```swift
// Capture only top-left 500x500 area
config.sourceRect = CGRect(x: 0, y: 0, width: 500, height: 500)
```

### Queue Depth

```swift
var queueDepth: Int
```

Number of sample buffers to queue. Higher values reduce dropped frames but increase latency.

**Example:**
```swift
config.queueDepth = 3  // Balance latency and reliability
```

### Color Space (macOS 15+)

```swift
var colorSpaceName: SCColorSpaceName
```

Color space for captured content.

**Values:**
- `.sRGB`
- `.displayP3`
- `.HDR10`
- `.HLG`

### Dynamic Range (macOS 15+)

```swift
var captureDynamicRange: SCCaptureDynamicRange
```

HDR capture configuration.

**Values:**
- `.SDR`
- `.HDRCanonicalDisplay`

## Configuration Presets (macOS 15+)

```swift
init(preset: SCStreamConfigurationPreset)
```

Create configuration with suggested values for common use cases.

**Presets:**
- `.captureHDRLocalDisplay` - HDR screenshot configuration

**Example:**
```swift
let config = SCStreamConfiguration(preset: .captureHDRLocalDisplay)
```

## Usage Patterns

### High-Quality Recording

```swift
let config = SCStreamConfiguration()
config.width = 1920
config.height = 1080
config.minimumFrameInterval = CMTime(value: 1, timescale: 60)  // 60 FPS
config.pixelFormat = kCVPixelFormatType_32BGRA
config.showsCursor = true
config.capturesAudio = true
config.queueDepth = 5
```

### Low-Latency Capture

```swift
let config = SCStreamConfiguration()
config.width = 640
config.height = 480
config.minimumFrameInterval = CMTime(value: 1, timescale: 30)
config.pixelFormat = kCVPixelFormatType_32BGRA
config.queueDepth = 1  // Minimal latency
```

### Screenshot Configuration

```swift
let config = SCStreamConfiguration()
config.pixelFormat = kCVPixelFormatType_32BGRA
config.showsCursor = false
// Don't set frame interval for single capture
```

### HDR Configuration (macOS 15+)

```swift
let config = SCStreamConfiguration(preset: .captureHDRLocalDisplay)
// Preset configures captureDynamicRange, pixelFormat, colorSpace automatically
```
