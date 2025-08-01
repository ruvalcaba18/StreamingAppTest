
import Foundation
import UIKit

final class ViewerViewModel: ObservableObject {
    @Published var currentFrame: UIImage?
    
    private weak var coordinator: Coordinator?
    private let networkService: NetworkServiceProtocol
    
    init(coordinator: Coordinator,
         networkService: NetworkServiceProtocol) {
        self.coordinator = coordinator
        self.networkService = networkService
        
        self.networkService.onFrameReceived = { [weak self] image in
            DispatchQueue.main.async {
                self?.currentFrame = image
            }
        }
    }
    
    func startListening() {
        networkService.startListening()
    }
    
    func stopListening() {
        networkService.stopListening()
    }
}
