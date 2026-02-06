# SCRecordingOutput Reference

SCRecordingOutput enables direct recording to file (macOS 15.0+).

## Overview

SCRecordingOutput provides built-in functionality to record captured content directly to a file without manual sample buffer processing. This simplifies video recording workflows.

## SCRecordingOutputConfiguration

Configuration object for recording settings.

### Properties

#### outputURL

```swift
var outputURL: URL
```

File URL where recording will be saved.

**Example:**
```swift
let config = SCRecordingOutputConfiguration()
config.outputURL = FileManager.default.temporaryDirectory.appendingPathComponent("recording.mp4")
```

#### videoCodecType

```swift
var videoCodecType: AVVideoCodecType
```

Video codec for encoding.

**Values:**
- `.h264` - H.264/AVC (good compatibility)
- `.hevc` - H.265/HEVC (better compression)
- `.proRes422` - Apple ProRes 422 (professional)
- `.proRes4444` - Apple ProRes 4444 (professional with alpha)

**Example:**
```swift
config.videoCodecType = .hevc
```

#### outputFileType

```swift
var outputFileType: AVFileType
```

Container file format.

**Values:**
- `.mp4` - MPEG-4 (most compatible)
- `.mov` - QuickTime Movie
- `.m4v` - MPEG-4 Video

**Example:**
```swift
config.outputFileType = .mp4
```

#### availableVideoCodecTypes

```swift
class var availableVideoCodecTypes: [AVVideoCodecType] { get }
```

Query available video codecs on the system.

**Example:**
```swift
let codecs = SCRecordingOutputConfiguration.availableVideoCodecTypes
print("Available codecs: \(codecs)")
```

#### availableOutputFileTypes

```swift
class var availableOutputFileTypes: [AVFileType] { get }
```

Query available output file formats.

**Example:**
```swift
let formats = SCRecordingOutputConfiguration.availableOutputFileTypes
print("Available formats: \(formats)")
```

## SCRecordingOutput

The recording output object that handles file writing.

### Initialization

```swift
init(configuration: SCRecordingOutputConfiguration, delegate: SCRecordingOutputDelegate?)
```

**Parameters:**
- `configuration` - SCRecordingOutputConfiguration with recording settings
- `delegate` - Optional delegate for recording events

**Example:**
```swift
let recordingConfig = SCRecordingOutputConfiguration()
recordingConfig.outputURL = recordingURL
recordingConfig.videoCodecType = .hevc
recordingConfig.outputFileType = .mp4

let recordingOutput = SCRecordingOutput(
    configuration: recordingConfig,
    delegate: self
)
```

### Methods

#### init(configuration:delegate:)

Creates a recording output with specified configuration.

**Example:**
```swift
let config = SCRecordingOutputConfiguration()
config.outputURL = getRecordingURL()
config.videoCodecType = .h264
config.outputFileType = .mp4

let output = SCRecordingOutput(configuration: config, delegate: self)
```

## Protocol

### SCRecordingOutputDelegate

Receives recording lifecycle events.

```swift
protocol SCRecordingOutputDelegate {
    func recordingOutput(
        _ output: SCRecordingOutput,
        didStartRecordingToURL url: URL
    )
    
    func recordingOutput(
        _ output: SCRecordingOutput,
        didStopRecordingToURL url: URL,
        error: Error?
    )
}
```

#### recordingOutput(_:didStartRecordingToURL:)

Called when recording successfully starts.

```swift
func recordingOutput(
    _ output: SCRecordingOutput,
    didStartRecordingToURL url: URL
) {
    print("Recording started: \(url.path)")
    // Update UI to show recording is active
}
```

#### recordingOutput(_:didStopRecordingToURL:error:)

Called when recording stops (successfully or with error).

```swift
func recordingOutput(
    _ output: SCRecordingOutput,
    didStopRecordingToURL url: URL,
    error: Error?
) {
    if let error = error {
        print("Recording failed: \(error)")
        // Handle error
    } else {
        print("Recording saved: \(url.path)")
        // Process completed recording
    }
}
```

## SCStream Integration

Add recording output to an SCStream:

```swift
// Create stream configuration
let streamConfig = SCStreamConfiguration()
streamConfig.width = 1920
streamConfig.height = 1080
streamConfig.capturesAudio = true
streamConfig.captureMicrophone = false

// Create stream
let stream = SCStream(
    filter: contentFilter,
    configuration: streamConfig,
    delegate: streamDelegate
)

// Create recording output
let recordingConfig = SCRecordingOutputConfiguration()
recordingConfig.outputURL = getRecordingPath()
recordingConfig.videoCodecType = .hevc
recordingConfig.outputFileType = .mp4

let recordingOutput = SCRecordingOutput(
    configuration: recordingConfig,
    delegate: recordingDelegate
)

// Add to stream
try stream.addRecordingOutput(recordingOutput)

// Start capture - recording begins automatically
try await stream.startCapture()
```

## Complete Recording Example

```swift
import ScreenCaptureKit
import AVFoundation

class ScreenRecorder: NSObject, SCStreamDelegate, SCRecordingOutputDelegate, SCStreamOutput {
    private var stream: SCStream?
    private var recordingOutput: SCRecordingOutput?
    
    private var isRecording = false
    private var recordingURL: URL?
    
    func startRecording(
        filter: SCContentFilter,
        to url: URL,
        codec: AVVideoCodecType = .hevc
    ) async throws {
        recordingURL = url
        
        // Configure stream
        let streamConfig = SCStreamConfiguration()
        streamConfig.width = 1920
        streamConfig.height = 1080
        streamConfig.minimumFrameInterval = CMTime(value: 1, timescale: 30)
        streamConfig.pixelFormat = kCVPixelFormatType_32BGRA
        streamConfig.showsCursor = true
        streamConfig.capturesAudio = true
        
        // Create stream
        stream = SCStream(
            filter: filter,
            configuration: streamConfig,
            delegate: self
        )
        
        // Add video output for preview
        try stream?.addStreamOutput(
            self,
            type: .screen,
            sampleHandlerQueue: DispatchQueue(label: "preview")
        )
        
        // Configure recording
        let recordingConfig = SCRecordingOutputConfiguration()
        recordingConfig.outputURL = url
        recordingConfig.videoCodecType = codec
        recordingConfig.outputFileType = .mp4
        
        recordingOutput = SCRecordingOutput(
            configuration: recordingConfig,
            delegate: self
        )
        
        // Add recording output
        try stream?.addRecordingOutput(recordingOutput!)
        
        // Start capture
        try await stream?.startCapture()
        isRecording = true
    }
    
    func stopRecording() async throws {
        try await stream?.stopCapture()
        isRecording = false
        stream = nil
        recordingOutput = nil
    }
    
    // MARK: - SCStreamOutput
    
    func stream(_ stream: SCStream, didOutputSampleBuffer sampleBuffer: CMSampleBuffer, of type: SCStreamOutputType) {
        // Handle preview frames
        if type == .screen {
            // Update preview UI
        }
    }
    
    // MARK: - SCStreamDelegate
    
    func stream(_ stream: SCStream, didStopWithError error: Error) {
        print("Stream stopped: \(error)")
        isRecording = false
    }
    
    func stream(_ stream: SCStream, outputEffectDidStart didStart: Bool) {
        // Handle Presenter Overlay
    }
    
    // MARK: - SCRecordingOutputDelegate
    
    func recordingOutput(
        _ output: SCRecordingOutput,
        didStartRecordingToURL url: URL
    ) {
        print("Recording started: \(url.path)")
    }
    
    func recordingOutput(
        _ output: SCRecordingOutput,
        didStopRecordingToURL url: URL,
        error: Error?
    ) {
        if let error = error {
            print("Recording error: \(error)")
        } else {
            print("Recording saved: \(url.path)")
            // Process file...
        }
        isRecording = false
    }
}

// Usage
let recorder = ScreenRecorder()

Task {
    let content = try await SCShareableContent.current
    let display = content.displays.first!
    let filter = SCContentFilter(display: display, excludingWindows: [])
    
    let url = FileManager.default.temporaryDirectory
        .appendingPathComponent("recording-\(Date().timeIntervalSince1970).mp4")
    
    try await recorder.startRecording(filter: filter, to: url, codec: .hevc)
    
    // Record for 10 seconds
    try await Task.sleep(for: .seconds(10))
    
    try await recorder.stopRecording()
}
```

## Recording Quality Considerations

| Codec | Quality | File Size | CPU Usage | Compatibility |
|-------|---------|-----------|-----------|---------------|
| H.264 | Good | Medium | Medium | Excellent |
| HEVC | Better | Smaller | Higher | Good |
| ProRes 422 | Best | Large | High | Professional |
| ProRes 4444 | Best+Alpha | Very Large | Very High | Professional |

## Error Handling

Common recording errors:

```swift
func recordingOutput(
    _ output: SCRecordingOutput,
    didStopRecordingToURL url: URL,
    error: Error?
) {
    if let error = error as? SCStreamError {
        switch error {
        case .insufficientResources:
            print("Not enough system resources")
        case .screenCaptureDisabled:
            print("Screen capture is disabled")
        default:
            print("Recording error: \(error)")
        }
    }
}
```
