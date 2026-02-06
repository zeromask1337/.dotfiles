# SCStream Reference

SCStream is the main class for capturing screen content.

## Overview

Manages the lifecycle of screen capture, outputs sample buffers, and handles stream events.

## Initialization

```swift
init(filter: SCContentFilter, configuration: SCStreamConfiguration, delegate: SCStreamDelegate?)
```

**Parameters:**
- `filter` - SCContentFilter defining what to capture
- `configuration` - SCStreamConfiguration for capture parameters
- `delegate` - Optional delegate for stream events

**Example:**
```swift
let stream = SCStream(
    filter: contentFilter,
    configuration: streamConfig,
    delegate: self
)
```

## Methods

### startCapture()

```swift
func startCapture() async throws
```

Starts capturing content. Stream must be configured with outputs before calling.

**Throws:**
- `SCStreamError.failedToStart` - Stream failed to start
- `SCStreamError.noCaptureSource` - No valid capture source
- `SCStreamError.userStopped` - User denied permission

**Example:**
```swift
do {
    try await stream.startCapture()
    print("Capture started")
} catch {
    print("Failed to start: \(error)")
}
```

### stopCapture()

```swift
func stopCapture() async throws
```

Stops the capture stream.

**Example:**
```swift
do {
    try await stream.stopCapture()
    print("Capture stopped")
} catch {
    print("Failed to stop: \(error)")
}
```

### addStreamOutput(_:type:sampleHandlerQueue:)

```swift
func addStreamOutput(_ output: SCStreamOutput, type: SCStreamOutputType, sampleHandlerQueue: DispatchQueue?) throws
```

Adds an output handler for a specific stream type.

**Parameters:**
- `output` - Object conforming to SCStreamOutput protocol
- `type` - Type of output (.screen, .audio, .microphone)
- `sampleHandlerQueue` - Dispatch queue for sample buffer callbacks

**Output Types:**
- `.screen` - Video frames
- `.audio` - Application audio
- `.microphone` - Microphone audio

**Example:**
```swift
// Add video output
try stream.addStreamOutput(
    self,
    type: .screen,
    sampleHandlerQueue: DispatchQueue(label: "video", qos: .userInteractive)
)

// Add audio output
try stream.addStreamOutput(
    self,
    type: .audio,
    sampleHandlerQueue: DispatchQueue(label: "audio")
)
```

### updateConfiguration(_:)

```swift
func updateConfiguration(_ configuration: SCStreamConfiguration, completionHandler: ((Error?) -> Void)? = nil)
```

Updates stream configuration while streaming.

**Example:**
```swift
let newConfig = SCStreamConfiguration()
newConfig.width = 1280
newConfig.height = 720

stream.updateConfiguration(newConfig) { error in
    if let error = error {
        print("Update failed: \(error)")
    } else {
        print("Configuration updated")
    }
}
```

### updateFilter(_:completionHandler:)

```swift
func updateFilter(_ filter: SCContentFilter, completionHandler: ((Error?) -> Void)? = nil)
```

Updates content filter while streaming.

**Example:**
```swift
let newFilter = SCContentFilter(window: differentWindow)
stream.updateFilter(newFilter) { error in
    if let error = nil {
        print("Filter updated")
    }
}
```

### addRecordingOutput(_:)

```swift
func addRecordingOutput(_ recordingOutput: SCRecordingOutput) throws
```

Adds recording output (macOS 15+).

**Example:**
```swift
let recordingConfig = SCRecordingOutputConfiguration()
recordingConfig.outputURL = recordingURL
let recordingOutput = SCRecordingOutput(configuration: recordingConfig, delegate: self)

try stream.addRecordingOutput(recordingOutput)
```

## Protocols

### SCStreamOutput

Receives captured sample buffers.

```swift
protocol SCStreamOutput {
    func stream(_ stream: SCStream, didOutputSampleBuffer sampleBuffer: CMSampleBuffer, of type: SCStreamOutputType)
}
```

**Example:**
```swift
class CaptureHandler: NSObject, SCStreamOutput {
    func stream(_ stream: SCStream, didOutputSampleBuffer sampleBuffer: CMSampleBuffer, of type: SCStreamOutputType) {
        switch type {
        case .screen:
            if let imageBuffer = sampleBuffer.imageBuffer {
                // Process CVImageBuffer
            }
        case .audio, .microphone:
            if let audioBuffer = sampleBuffer.audioBufferList {
                // Process audio
            }
        @unknown default:
            break
        }
    }
}
```

### SCStreamDelegate

Handles stream lifecycle events.

```swift
protocol SCStreamDelegate {
    func stream(_ stream: SCStream, didStopWithError error: Error)
    func stream(_ stream: SCStream, outputEffectDidStart didStart: Bool)
}
```

**Methods:**

- `stream(_:didStopWithError:)` - Called when stream stops unexpectedly
- `stream(_:outputEffectDidStart:)` - Presenter Overlay effect state changed (macOS 14+)

**Example:**
```swift
extension CaptureManager: SCStreamDelegate {
    func stream(_ stream: SCStream, didStopWithError error: Error) {
        print("Stream stopped: \(error)")
        // Handle error, possibly restart
    }
    
    func stream(_ stream: SCStream, outputEffectDidStart didStart: Bool) {
        if didStart {
            print("Presenter Overlay enabled")
        } else {
            print("Presenter Overlay disabled")
        }
    }
}
```

## Error Types

### SCStreamError

```swift
enum SCStreamError: Int {
    case failedToStart = -3801
    case userStopped = -3817
    case noCaptureSource = -3804
    case failedToStartAudioCapture = -3806
    case streamAlreadyRunning = -3802
    case streamNotRunning = -3803
    case insufficientResources = -3808
    case screenCaptureDisabled = -3809
    case deniedByUser = -3810
    case contentIsProtected = -3812
    case case failedToStartScreenCapture = -3815
}
```

## Usage Patterns

### Complete Stream Setup

```swift
class ScreenRecorder: NSObject, SCStreamOutput, SCStreamDelegate {
    private var stream: SCStream?
    
    func startRecording(display: SCDisplay) async throws {
        // Create filter
        let filter = SCContentFilter(display: display, excludingWindows: [])
        
        // Configure stream
        let config = SCStreamConfiguration()
        config.width = 1920
        config.height = 1080
        config.minimumFrameInterval = CMTime(value: 1, timescale: 30)
        config.pixelFormat = kCVPixelFormatType_32BGRA
        config.showsCursor = true
        config.capturesAudio = true
        
        // Create stream
        stream = SCStream(filter: filter, configuration: config, delegate: self)
        
        // Add outputs
        try stream?.addStreamOutput(
            self,
            type: .screen,
            sampleHandlerQueue: DispatchQueue(label: "video")
        )
        
        try stream?.addStreamOutput(
            self,
            type: .audio,
            sampleHandlerQueue: DispatchQueue(label: "audio")
        )
        
        // Start
        try await stream?.startCapture()
    }
    
    func stopRecording() async throws {
        try await stream?.stopCapture()
        stream = nil
    }
    
    // MARK: - SCStreamOutput
    
    func stream(_ stream: SCStream, didOutputSampleBuffer sampleBuffer: CMSampleBuffer, of type: SCStreamOutputType) {
        // Process samples
    }
    
    // MARK: - SCStreamDelegate
    
    func stream(_ stream: SCStream, didStopWithError error: Error) {
        print("Stream error: \(error)")
    }
}
```

### Handling Sample Buffers

```swift
func processVideoSample(_ sampleBuffer: CMSampleBuffer) {
    guard let imageBuffer = sampleBuffer.imageBuffer else { return }
    
    // Lock base address
    CVPixelBufferLockBaseAddress(imageBuffer, .readOnly)
    defer { CVPixelBufferUnlockBaseAddress(imageBuffer, .readOnly) }
    
    // Get pixel data
    let width = CVPixelBufferGetWidth(imageBuffer)
    let height = CVPixelBufferGetHeight(imageBuffer)
    let baseAddress = CVPixelBufferGetBaseAddress(imageBuffer)
    
    // Process frame...
}
```
