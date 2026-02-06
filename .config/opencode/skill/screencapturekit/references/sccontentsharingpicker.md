# SCContentSharingPicker Reference

SCContentSharingPicker provides a system-level UI for selecting windows and displays to share.

## Overview

Available in macOS 14.0+, the sharing picker provides a native macOS interface for content selection, eliminating the need for custom picker UI. When used, apps don't need to request explicit screen recording permissions.

## Shared Instance

```swift
class var shared: SCContentSharingPicker { get }
```

Access the singleton picker instance:

```swift
let picker = SCContentSharingPicker.shared
```

## Configuration

### SCContentSharingPickerConfiguration

```swift
var configuration: SCContentSharingPickerConfiguration
```

Configure picker behavior and appearance.

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `allowsReplacingContent` | `Bool` | Allow user to switch captured content |
| `allowsChangingSelectedContent` | `Bool` | Allow modifying current selection |
| `showsHighlight` | `Bool` | Show highlighted border around selected content |

**Example:**
```swift
let config = SCContentSharingPickerConfiguration()
config.allowsReplacingContent = true
config.allowsChangingSelectedContent = true
config.showsHighlight = true

picker.configuration = config
```

## Methods

### present()

```swift
func present()
```

Shows the sharing picker UI.

**Example:**
```swift
picker.present()
```

### add(_:)

```swift
func add(_ observer: SCContentSharingPickerObserver)
```

Registers an observer for picker events.

**Example:**
```swift
picker.add(self)
```

### remove(_:)

```swift
func remove(_ observer: SCContentSharingPickerObserver)
```

Removes a previously added observer.

**Example:**
```swift
picker.remove(self)
```

### isActive(for:)

```swift
func isActive(for stream: SCStream?) -> Bool
```

Checks if picker is currently active for a stream.

## Protocol

### SCContentSharingPickerObserver

```swift
protocol SCContentSharingPickerObserver: NSObjectProtocol {
    func contentSharingPicker(
        _ picker: SCContentSharingPicker,
        didUpdateWith filter: SCContentFilter,
        for stream: SCStream?
    )
    
    func contentSharingPicker(
        _ picker: SCContentSharingPicker,
        didCancelFor stream: SCStream?
    )
    
    func contentSharingPickerStartDidFailWithError(_ error: Error)
}
```

### Required Methods

**contentSharingPicker(_:didUpdateWith:for:)**

Called when user selects content through the picker.

```swift
func contentSharingPicker(
    _ picker: SCContentSharingPicker,
    didUpdateWith filter: SCContentFilter,
    for stream: SCStream?
) {
    // User selected content
    // Create or update stream with this filter
    
    Task {
        if let existingStream = stream {
            // Update existing stream
            existingStream.updateFilter(filter) { error in
                if let error = error {
                    print("Failed to update filter: \(error)")
                }
            }
        } else {
            // Create new stream
            let config = SCStreamConfiguration()
            let newStream = SCStream(filter: filter, configuration: config, delegate: self)
            try? newStream.addStreamOutput(self, type: .screen, sampleHandlerQueue: .main)
            try? await newStream.startCapture()
        }
    }
}
```

**contentSharingPicker(_:didCancelFor:)**

Called when user cancels the picker.

```swift
func contentSharingPicker(
    _ picker: SCContentSharingPicker,
    didCancelFor stream: SCStream?
) {
    print("User cancelled picker")
    
    // Clean up if needed
    if let stream = stream {
        Task {
            try? await stream.stopCapture()
        }
    }
}
```

**contentSharingPickerStartDidFailWithError(_:)**

Called when picker fails to start.

```swift
func contentSharingPickerStartDidFailWithError(_ error: Error) {
    print("Picker failed to start: \(error)")
    // Show error to user
}
```

## Presenter Overlay Integration

When using SCContentSharingPicker with an active AVCaptureSession, the system automatically enables Presenter Overlay support:

```swift
import ScreenCaptureKit
import AVFoundation

class PresenterOverlayManager: NSObject, SCContentSharingPickerObserver {
    private let picker = SCContentSharingPicker.shared
    private var captureSession: AVCaptureSession?
    private var stream: SCStream?
    
    func setupWithCamera() {
        // Set up camera capture
        captureSession = AVCaptureSession()
        
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: camera)
            captureSession?.addInput(input)
            
            let output = AVCaptureVideoDataOutput()
            captureSession?.addOutput(output)
        } catch {
            print("Camera setup failed: \(error)")
            return
        }
        
        // Configure picker
        picker.add(self)
        picker.configuration.allowsReplacingContent = true
    }
    
    func startSharing() {
        // Start camera first (required for Presenter Overlay)
        captureSession?.startRunning()
        
        // Then present picker
        // When picker shows, it will have Presenter Overlay option
        picker.present()
    }
    
    func contentSharingPicker(
        _ picker: SCContentSharingPicker,
        didUpdateWith filter: SCContentFilter,
        for stream: SCStream?
    ) {
        Task {
            let config = SCStreamConfiguration()
            let newStream = SCStream(filter: filter, configuration: config, delegate: self)
            
            try? newStream.addStreamOutput(self, type: .screen, sampleHandlerQueue: .main)
            try? await newStream.startCapture()
            
            self.stream = newStream
        }
    }
}

extension PresenterOverlayManager: SCStreamDelegate {
    func stream(_ stream: SCStream, outputEffectDidStart didStart: Bool) {
        if didStart {
            print("Presenter Overlay is active - user sees camera overlay on screen share")
        } else {
            print("Presenter Overlay disabled")
        }
    }
    
    func stream(_ stream: SCStream, didStopWithError error: Error) {
        print("Stream stopped: \(error)")
    }
}
```

## Complete Implementation Example

```swift
import ScreenCaptureKit

class ContentSharingManager: NSObject, SCContentSharingPickerObserver, SCStreamOutput, SCStreamDelegate {
    static let shared = ContentSharingManager()
    
    private let picker = SCContentSharingPicker.shared
    private var activeStream: SCStream?
    private var onFrameCaptured: ((CMSampleBuffer) -> Void)?
    
    private override init() {
        super.init()
    }
    
    func setup() {
        picker.add(self)
        
        let config = SCContentSharingPickerConfiguration()
        config.allowsReplacingContent = true
        config.allowsChangingSelectedContent = true
        picker.configuration = config
    }
    
    func showPicker(onFrame: @escaping (CMSampleBuffer) -> Void) {
        onFrameCaptured = onFrame
        picker.present()
    }
    
    func stop() {
        Task {
            try? await activeStream?.stopCapture()
            activeStream = nil
        }
        picker.remove(self)
    }
    
    // MARK: - SCContentSharingPickerObserver
    
    func contentSharingPicker(
        _ picker: SCContentSharingPicker,
        didUpdateWith filter: SCContentFilter,
        for stream: SCStream?
    ) {
        Task {
            // Stop existing stream if any
            if let existing = stream ?? activeStream {
                try? await existing.stopCapture()
            }
            
            // Create new configuration
            let config = SCStreamConfiguration()
            config.width = 1920
            config.height = 1080
            config.minimumFrameInterval = CMTime(value: 1, timescale: 30)
            config.pixelFormat = kCVPixelFormatType_32BGRA
            
            // Create and start stream
            let newStream = SCStream(filter: filter, configuration: config, delegate: self)
            
            try newStream.addStreamOutput(
                self,
                type: .screen,
                sampleHandlerQueue: DispatchQueue(label: "capture", qos: .userInteractive)
            )
            
            try await newStream.startCapture()
            activeStream = newStream
        }
    }
    
    func contentSharingPicker(
        _ picker: SCContentSharingPicker,
        didCancelFor stream: SCStream?
    ) {
        print("User cancelled")
        Task {
            try? await activeStream?.stopCapture()
            activeStream = nil
        }
    }
    
    func contentSharingPickerStartDidFailWithError(_ error: Error) {
        print("Picker error: \(error)")
    }
    
    // MARK: - SCStreamOutput
    
    func stream(_ stream: SCStream, didOutputSampleBuffer sampleBuffer: CMSampleBuffer, of type: SCStreamOutputType) {
        guard type == .screen else { return }
        onFrameCaptured?(sampleBuffer)
    }
    
    // MARK: - SCStreamDelegate
    
    func stream(_ stream: SCStream, didStopWithError error: Error) {
        print("Stream stopped: \(error)")
        activeStream = nil
    }
}

// Usage
ContentSharingManager.shared.setup()
ContentSharingManager.shared.showPicker { sampleBuffer in
    // Process captured frame
    print("Got frame: \(sampleBuffer)")
}
```

## Benefits Over Custom Picker

1. **No Permission Required** - System handles authorization
2. **Native Look & Feel** - Matches macOS design
3. **Presenter Overlay** - Automatic support when camera active
4. **Consistent UX** - Same picker as FaceTime, Safari
5. **Less Code** - No custom window enumeration UI needed
