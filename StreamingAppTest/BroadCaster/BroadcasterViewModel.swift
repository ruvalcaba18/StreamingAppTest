
import Foundation
import AVFoundation

final class BroadcasterViewModel: ObservableObject {
    @Published var isStreaming = false
    
    private weak var coordinator: Coordinator?
    private let networkService: NetworkServiceProtocol
    private let cameraService: CameraServiceProtocol
    
    init(coordinator: Coordinator,
         networkService: NetworkServiceProtocol,
         cameraService: CameraServiceProtocol = CameraService()) {
        
        self.coordinator = coordinator
        self.networkService = networkService
        self.cameraService = cameraService
        
        self.cameraService.delegate = self
    }
    
    func toggleStreaming() {
        isStreaming ? stopStreaming() : startStreaming()
    }
    
    func startStreaming() {
        cameraService.startCapture()
        networkService.startBroadcasting()
        isStreaming = true
    }
    
    func stopStreaming() {
        cameraService.stopCapture()
        networkService.stopBroadcasting()
        isStreaming = false
    }
}

extension BroadcasterViewModel: CameraServiceDelegate {
    func didOutputVideoBuffer(_ sampleBuffer: CMSampleBuffer) {
        guard isStreaming else { return }
        networkService.sendVideoFrame(sampleBuffer: sampleBuffer)
    }
}
