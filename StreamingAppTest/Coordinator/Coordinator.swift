//  Coordinator.swift
//  StreamingAppTest
//  Created by jael ruvalcaba on 30/07/25.


import Foundation
import SwiftUI

@MainActor
final class Coordinator: ObservableObject {
    
    @Published var currentView: AnyView?
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
         self.networkService = networkService
         showRoleSelection()
     }
    
    func showRoleSelection() {
        let viewModel = RoleSelectionViewModel(coordinator: self)
        currentView = AnyView(RoleSelectionView(viewModel: viewModel))
    }
    
    func showBroadcaster() {
        let viewModel = BroadcasterViewModel(coordinator: self, networkService: networkService)
        currentView = AnyView(BroadcasterView(viewModel: viewModel))
    }
    
    func showViewer() {
        let viewModel = ViewerViewModel(coordinator: self, networkService: networkService)
        currentView = AnyView(ViewerView(viewModel: viewModel))
    }
}
