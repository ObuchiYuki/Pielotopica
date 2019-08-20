import UIKit
import AVFoundation
import CoreVideo

// =============================================================== //
// MARK: - CRVideoCapture -

public class CRVideoCapture: NSObject {
    // =============================================================== //
    // MARK: - Properties -
    public var objectDetectingFPS = 30

    // =============================================================== //
    // MARK: - Private Properties -

    private var detector: RKObjectDetector!
    private var lastTimestamp = CMTime()
    private let captureSession = AVCaptureSession()
    private let queue = DispatchQueue(label: "com.pielotopica.camera-queue")
    
    // =============================================================== //
    // MARK: - Methods -

    public func setDetector(_ detector: RKObjectDetector) {
        self.detector = detector
    }
    
    public func setUp(sessionPreset: AVCaptureSession.Preset = .medium, completion: @escaping (Bool) -> Void) {
        queue.async {
            let success = self.setUpCamera(sessionPreset: sessionPreset)
            DispatchQueue.main.async {
                completion(success)
            }
        }
    }
    
    public func start() {
        if !captureSession.isRunning {
            captureSession.startRunning()
        }
    }
    
    public func stop() {
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }
    
    public func createPreviewLayer() -> CALayer {
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspect
        previewLayer.connection?.videoOrientation = .portrait
        
        return previewLayer
    }
    
    // =============================================================== //
    // MARK: - Private Methods -
    private func setUpCamera(sessionPreset: AVCaptureSession.Preset) -> Bool {
        captureSession.beginConfiguration()
        captureSession.sessionPreset = sessionPreset
        
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            print("Error: no video devices available")
            return false
        }
        
        guard let videoInput = try? AVCaptureDeviceInput(device: captureDevice) else {
            print("Error: could not create AVCaptureDeviceInput")
            return false
        }
        
        captureSession.addInput(videoInput)
        
        
        guard let videoOutput = createOutput(for: captureSession) else {
            debugPrint("Error: could not create AVCaptureOutput")
            return false
        }
        
        captureSession.addOutput(videoOutput)
        
        /// This must call after addOutput(_:)
        videoOutput.connection(with: AVMediaType.video)?.videoOrientation = .portrait
        
        captureSession.commitConfiguration()
        
        return true
    }
    
    private func createOutput(for session:AVCaptureSession) -> AVCaptureOutput? {
        let settings: [String : Any] = [
            kCVPixelBufferPixelFormatTypeKey as String: NSNumber(value: kCVPixelFormatType_32BGRA),
        ]
        
        let videoOutput = AVCaptureVideoDataOutput()
        
        videoOutput.videoSettings = settings
        videoOutput.alwaysDiscardsLateVideoFrames = true
        videoOutput.setSampleBufferDelegate(self, queue: queue)
        
        if !captureSession.canAddOutput(videoOutput) {
            return nil
        }
        
        return videoOutput
    }
    
}

extension CRVideoCapture: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        assert(detector != nil, "Error: You must set CRObjectDetector before starting camera.")
        print("useful")
        
        let timestamp = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)
        let deltaTime = timestamp - lastTimestamp
        
        if deltaTime >= CMTimeMake(value: 1, timescale: Int32(self.objectDetectingFPS)) {
            
            lastTimestamp = timestamp
            guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {return}
            
            detector.predictObjects(from: imageBuffer)
        }
    }
}

