import Foundation
import SwiftUI

struct BroadcasterView: View {
    @ObservedObject var viewModel: BroadcasterViewModel
    
    var body: some View {
        VStack {
            Text("Broadcaster")
                .font(.title)
            
            Button(action: {
                viewModel.toggleStreaming()
            }) {
                Text(viewModel.isStreaming ? "Detener Transmisión" : "Iniciar Transmisión")
                    .padding()
                    .background(viewModel.isStreaming ? Color.red : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .onDisappear {
            viewModel.stopStreaming()
        }
    }
}

#Preview {

    BroadcasterView(viewModel: <#T##BroadcasterViewModel#>)
}
