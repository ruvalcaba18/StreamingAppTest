
import SwiftUI

struct RoleSelectionView: View {
    @ObservedObject var viewModel: RoleSelectionViewModel
    
    var body: some View {
        VStack {
            Button("Transmitir") {
                viewModel.selectBroadcaster()
            }
            .padding()
            
            Button("Ver Transmisión") {
                viewModel.selectViewer()
            }
            .padding()
        }
    }
}
