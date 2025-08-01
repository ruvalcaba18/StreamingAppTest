import Foundation

class RoleSelectionViewModel: ObservableObject {
    private weak var coordinator: Coordinator?
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
    
    func selectBroadcaster() {
        coordinator?.showBroadcaster()
    }
    
    func selectViewer() {
        coordinator?.showViewer()
    }
}
