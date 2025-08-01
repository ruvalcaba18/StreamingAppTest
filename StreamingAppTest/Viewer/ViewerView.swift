import SwiftUI

struct ViewerView: View {
    @ObservedObject var viewModel: ViewerViewModel
      
      var body: some View {
          VStack {
              Text("Viewer")
                  .font(.title)
              
              if let image = viewModel.currentFrame {
                  Image(uiImage: image)
                      .resizable()
                      .scaledToFit()
                      .frame(width: 300, height: 300)
              } else {
                  Text("Esperando transmisión...")
              }
          }
          .onAppear {
              viewModel.startListening()
          }
          .onDisappear {
              viewModel.stopListening()
          }
      }}

#Preview {
    ViewerView()
}
