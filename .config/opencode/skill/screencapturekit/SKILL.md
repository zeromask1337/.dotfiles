---
name: screencapturekit
description: Expert guidance for Apple's ScreenCaptureKit framework for macOS screen recording, screenshots, and content sharing. Use when implementing screen capture, video streaming, or screenshot functionality in macOS apps.
metadata:
  author: opencode
  version: "1.0"
  source: https://developer.apple.com/documentation/screencapturekit
  updated: 2026-02-06
  platform: macOS 12.3+
---

# ScreenCaptureKit Expert Skill

Comprehensive guidance for Apple's ScreenCaptureKit framework. ScreenCaptureKit provides high-performance screen capture capabilities for macOS applications, including video streaming, audio capture, screenshots, and system integration.

## Core Concepts

ScreenCaptureKit enables three main use cases:

1. **Screen/Window Recording** - Capture video and audio from displays or windows
2. **Screenshots** - Take still images using `SCScreenshotManager`
3. **Content Sharing** - Presenter Overlay and system picker integration

## Key Classes

### SCShareableContent

Entry point for discovering shareable content:

```swift
// Get all available displays and windows
let content = try await SCShareableContent.current

// Get content excluding specific applications
let content = try await SCShareableContent.getExcluding(
    desktopWindows: false,
    onScreenWindowsOnly: true
)
```

**Properties:**
- `displays: [SCDisplay]` - Available displays
- `windows: [SCWindow]` - Shareable windows
- `applications: [SCRunningApplication]` - Running applications

### SCContentFilter

Determines what content to capture:

```swift
// Filter for a specific display
let filter = SCContentFilter(display: display, excludingWindows: [])

// Filter for a specific window
let filter = SCContentFilter(window: window)

// Filter excluding applications
let filter = SCContentFilter(
    display: display,
    excludingApplications: excludedApps,
    exceptingWindows: []
)
```

### SCStreamConfiguration

Configures capture parameters:

```swift
let config = SCStreamConfiguration()
config.width = 1920
config.height = 1080
config.pixelFormat = kCVPixelFormatType_32BGRA
config.minimumFrameInterval = CMTime(value: 1, timescale: 30) // 30 FPS
config.showsCursor = true
config.capturesAudio = true
config.captureMicrophone = true
```

**Key Configuration Options:**

| Property | Description | Default |
|----------|-------------|---------|
| `width` / `height` | Output dimensions | Source dimensions |
| `pixelFormat` | Pixel format (e.g., `kCVPixelFormatType_32BGRA`) | Source format |
| `minimumFrameInterval` | Frame rate control | Source rate |
| `showsCursor` | Include cursor in capture | `false` |
| `capturesAudio` | Capture application audio | `false` |
| `captureMicrophone` | Capture microphone audio | `false` |
| `sourceRect` | Crop region ( CGRect ) | Full content |
| `queueDepth` | Sample buffer queue depth | Varies |
| `scalesToFit` | Scale output to fit dimensions | `true` |

### SCStream

The main capture stream:

```swift
import ScreenCaptureKit
import CoreMedia

class CaptureManager: NSObject, SCStreamOutput, SCStreamDelegate {
    private var stream: SCStream?
    
    func startCapture(filter: SCContentFilter, config: SCStreamConfiguration) async throws {
        stream = SCStream(filter: filter, configuration: config, delegate: self)
        
        // Add video output
        try stream?.addStreamOutput(
            self,
            type: .screen,
            sampleHandlerQueue: DispatchQueue(label: "video")
        )
        
        // Add audio output
        try stream?.addStreamOutput(
            self,
            type: .audio,
            sampleHandlerQueue: DispatchQueue(label: "audio")
        )
        
        // Start capture
        try await stream?.startCapture()
    }
    
    func stopCapture() async throws {
        try await stream?.stopCapture()
    }
    
    // MARK: - SCStreamOutput
    
    func stream(_ stream: SCStream, didOutputSampleBuffer sampleBuffer: CMSampleBuffer, of type: SCStreamOutputType) {
        switch type {
        case .screen:
            // Handle video frame
            processVideoFrame(sampleBuffer)
        case .audio:
            // Handle audio sample
            processAudioSample(sampleBuffer)
        case .microphone:
            // Handle microphone audio
            processMicrophoneSample(sampleBuffer)
        @unknown default:
            break
        }
    }
    
    // MARK: - SCStreamDelegate
    
    func stream(_ stream: SCStream, didStopWithError error: Error) {
        print("Stream stopped with error: \(error)")
    }
    
    func stream(_ stream: SCStream, outputEffectDidStart didStart: Bool) {
        // Presenter Overlay effect started/stopped
        if didStart {
            print("Presenter Overlay enabled")
        }
    }
}
```

## Screenshots with SCScreenshotManager

ScreenCaptureKit replaces the deprecated `CGWindowListCreateImage`:

```swift
import ScreenCaptureKit

func takeScreenshot(display: SCDisplay) async throws -> CGImage {
    let filter = SCContentFilter(display: display, excludingWindows: [])
    let config = SCStreamConfiguration()
    config.width = 1920
    config.height = 1080
    
    // Capture as CGImage
    let image = try await SCScreenshotManager.captureImage(
        contentFilter: filter,
        configuration: config
    )
    
    return image
}

// Alternative: Capture as CMSampleBuffer for more pixel format options
func takeScreenshotAsSampleBuffer(display: SCDisplay) async throws -> CMSampleBuffer {
    let filter = SCContentFilter(display: display, excludingWindows: [])
    let config = SCStreamConfiguration()
    
    let sampleBuffer = try await SCScreenshotManager.captureSampleBuffer(
        contentFilter: filter,
        configuration: config
    )
    
    return sampleBuffer
}
```

## System Picker (macOS 14+)

The built-in picker UI for window/screen selection:

```swift
import ScreenCaptureKit

class SharingPickerManager: NSObject, SCContentSharingPickerObserver {
    private let picker = SCContentSharingPicker.shared
    
    func setupPicker() {
        picker.add(self)
        
        // Configure picker appearance
        let configuration = SCContentSharingPickerConfiguration()
        configuration.allowsReplacingContent = true
        configuration.allowsChangingSelectedContent = true
        picker.configuration = configuration
    }
    
    func showPicker() {
        picker.present()
    }
    
    // MARK: - SCContentSharingPickerObserver
    
    func contentSharingPicker(_ picker: SCContentSharingPicker, didUpdateWith filter: SCContentFilter, for stream: SCStream?) {
        // User selected new content
        updateStream(with: filter)
    }
    
    func contentSharingPicker(_ picker: SCContentSharingPicker, didCancelFor stream: SCStream?) {
        // User cancelled
        print("Picker cancelled")
    }
    
    func contentSharingPickerStartDidFailWithError(_ error: Error) {
        // Failed to start
        print("Picker failed: \(error)")
    }
}
```

**Benefits of using SCContentSharingPicker:**
- No need to build custom window selection UI
- Automatic Presenter Overlay support (when combined with AVCaptureSession)
- No explicit screen recording permission required (handled by system)

## Recording Output (macOS 15+)

Built-in recording to file:

```swift
import ScreenCaptureKit
import AVFoundation

func setupRecording(filter: SCContentFilter, config: SCStreamConfiguration) async throws {
    let stream = SCStream(filter: filter, configuration: config, delegate: self)
    
    // Configure recording
    let recordingConfig = SCRecordingOutputConfiguration()
    recordingConfig.outputURL = getRecordingURL()
    recordingConfig.videoCodecType = .hevc
    recordingConfig.outputFileType = .mp4
    
    let recordingOutput = SCRecordingOutput(configuration: recordingConfig, delegate: self)
    try stream.addRecordingOutput(recordingOutput)
    
    try await stream.startCapture()
}

// MARK: - SCRecordingOutputDelegate

func recordingOutput(_ output: SCRecordingOutput, didStartRecordingToURL url: URL) {
    print("Recording started: \(url)")
}

func recordingOutput(_ output: SCRecordingOutput, didStopRecordingToURL url: URL, error: Error?) {
    if let error = error {
        print("Recording failed: \(error)")
    } else {
        print("Recording saved: \(url)")
    }
}
```

## Best Practices

### Performance Optimization

1. **Use appropriate frame rates**: Don't capture at 60 FPS if 30 FPS is sufficient
2. **Set queueDepth appropriately**: Balance between memory and latency
3. **Use sourceRect for partial capture**: Capture only the region you need
4. **Reuse stream configurations**: Update with `updateConfiguration()` instead of recreating

### Error Handling

```swift
do {
    try await stream.startCapture()
} catch let error as SCStreamError {
    switch error {
    case .userStopped:
        print("User stopped the stream")
    case .noCaptureSource:
        print("No capture source available")
    case .failedToStartAudioCapture:
        print("Audio capture failed")
    default:
        print("Stream error: \(error)")
    }
}
```

### Permissions

ScreenCaptureKit requires the `com.apple.security.screen-recording` entitlement. Users must grant permission in:

System Settings → Privacy & Security → Screen Recording

**Note:** When using `SCContentSharingPicker`, explicit permission is not required.

## Common Patterns

### Capturing a Specific Window

```swift
let content = try await SCShareableContent.current
if let window = content.windows.first(where: { $0.windowID == targetWindowID }) {
    let filter = SCContentFilter(window: window)
    let config = SCStreamConfiguration()
    config.pixelFormat = kCVPixelFormatType_32BGRA
    
    let stream = SCStream(filter: filter, configuration: config, delegate: self)
    try await stream.startCapture()
}
```

### Dynamic Configuration Updates

```swift
// Update stream configuration while running
let newConfig = SCStreamConfiguration()
newConfig.width = 1280
newConfig.height = 720
try await stream.updateConfiguration(newConfig)
```

### Multi-Display Capture

```swift
let content = try await SCShareableContent.current

for display in content.displays {
    let filter = SCContentFilter(display: display, excludingWindows: [])
    let config = SCStreamConfiguration()
    
    let stream = SCStream(filter: filter, configuration: config, delegate: self)
    try await stream.startCapture()
    
    // Store stream reference
    streams.append(stream)
}
```

## Version Requirements

| Feature | Minimum Version |
|---------|-----------------|
| Basic streaming | macOS 12.3 |
| Audio capture | macOS 13.0 |
| Presenter Overlay | macOS 14.0 |
| SCContentSharingPicker | macOS 14.0 |
| SCScreenshotManager | macOS 14.0 |
| SCRecordingOutput | macOS 15.0 |

## References

For detailed API information:
- [references/scshareablecontent.md](references/scshareablecontent.md) - Content discovery
- [references/sccontentfilter.md](references/sccontentfilter.md) - Content filtering
- [references/scstreamconfiguration.md](references/scstreamconfiguration.md) - Stream configuration
- [references/scstream.md](references/scstream.md) - Stream management
- [references/scscreenshotmanager.md](references/scscreenshotmanager.md) - Screenshot API
- [references/sccontentsharingpicker.md](references/sccontentsharingpicker.md) - System picker
- [references/screcordingoutput.md](references/screcordingoutput.md) - File recording
