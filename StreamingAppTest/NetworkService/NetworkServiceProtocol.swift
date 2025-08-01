import Foundation
import UIKit
import CoreMedia

protocol NetworkServiceProtocol {
    var onFrameReceived: ((UIImage) -> Void)? { get set }
    
    func startBroadcasting()
    func stopBroadcasting()
    func sendVideoFrame(sampleBuffer: CMSampleBuffer)
    
    func startListening()
    func stopListening()
}
