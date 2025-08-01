import Foundation
import CoreMedia

protocol CameraServiceDelegate: AnyObject {
    func didOutputVideoBuffer(_ sampleBuffer: CMSampleBuffer)
}

protocol CameraServiceProtocol {
    var delegate: CameraServiceDelegate? { get set }
    func startCapture()
    func stopCapture()
}
