import Foundation
import AVFoundation

final class CameraService: NSObject, CameraServiceProtocol {
    weak var delegate: CameraServiceDelegate?
    private let session = AVCaptureSession()
    private let queue = DispatchQueue(label: "camera.service.queue")
    
    func startCapture() {
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let input = try? AVCaptureDeviceInput(device: device) else { return }
        
        session.beginConfiguration()
        if session.canAddInput(input) {
            session.addInput(input)
        }
        
        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(self, queue: queue)
        if session.canAddOutput(output) {
            session.addOutput(output)
        }
        
        session.commitConfiguration()
        session.startRunning()
    }
    
    func stopCapture() {
        session.stopRunning()
    }
}

extension CameraService: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput,
                      didOutput sampleBuffer: CMSampleBuffer,
                      from connection: AVCaptureConnection) {
        delegate?.didOutputVideoBuffer(sampleBuffer)
    }
}
