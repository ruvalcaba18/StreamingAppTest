import Foundation
import Network
import AVFoundation
import UIKit

final class NetworkService: NetworkServiceProtocol {
    
    var onFrameReceived: ((UIImage) -> Void)?
    
    private var connection: NWConnection?
    private var listener: NWListener?
    private let queue = DispatchQueue(label: "network.service.queue")
    
    
    func startBroadcasting() {
        let host = NWEndpoint.Host("192.168.1.255")
        let port = NWEndpoint.Port(rawValue: 12345)!
        
        connection = NWConnection(host: host, port: port, using: .udp)
        connection?.stateUpdateHandler = { state in
            switch state {
            case .ready: print("Broadcasting ready")
            case .failed(let error): print("Broadcast error: \(error)")
            default: break
            }
        }
        connection?.start(queue: queue)
    }
    
    func sendVideoFrame(sampleBuffer: CMSampleBuffer) {
        guard let connection = connection,
              let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer),
              let jpegData = imageBufferToJPEG(imageBuffer: imageBuffer) else { return }
        
        connection.send(content: jpegData, completion: .idempotent)
    }
    
    func stopBroadcasting() {
        connection?.cancel()
        connection = nil
    }
    
    func startListening() {
        do {
            listener = try NWListener(using: .udp, on: 12345)
            
            listener?.stateUpdateHandler = { state in
                switch state {
                case .ready: print("Listener ready on port 12345")
                case .failed(let error): print("Listener failed: \(error)")
                default: break
                }
            }
            
            listener?.newConnectionHandler = { [weak self] newConnection in
                self?.setupIncomingConnection(newConnection)
            }
            
            listener?.start(queue: queue)
        } catch {
            print("Failed to create listener: \(error)")
        }
    }
    
    func stopListening() {
        listener?.cancel()
        listener = nil
    }
    
    private func setupIncomingConnection(_ connection: NWConnection) {
        connection.stateUpdateHandler = { [weak self] state in
            switch state {
            case .ready:
                self?.receive(on: connection)
            case .failed(let error):
                print("Connection error: \(error)")
                connection.cancel()
            default:
                break
            }
        }
        connection.start(queue: queue)
    }
    
    private func receive(on connection: NWConnection) {
        connection.receiveMessage { [weak self] (data, _, isComplete, error) in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.onFrameReceived?(image)
                }
            }
            
            if error == nil && !isComplete {
                self?.receive(on: connection) // Continue listening
            }
        }
    }
    
    // MARK: - Image Conversion
    
    private func imageBufferToJPEG(imageBuffer: CVImageBuffer, compressionQuality: CGFloat = 0.7) -> Data? {
        let ciImage = CIImage(cvImageBuffer: imageBuffer)
        let context = CIContext(options: nil)
        
        // Optional: Adjust orientation if needed
        let orientedImage = ciImage.oriented(forExifOrientation: 6) // 6 = right top
        
        // Convert to JPEG
        guard let colorSpace = ciImage.colorSpace ?? CGColorSpace(name: CGColorSpace.sRGB),
              let jpegData = context.jpegRepresentation(
                of: orientedImage,
                colorSpace: colorSpace,
                options: [kCGImageDestinationLossyCompressionQuality as CIImageRepresentationOption: compressionQuality]
              ) else {
            return nil
        }
        
        return jpegData
    }
}
