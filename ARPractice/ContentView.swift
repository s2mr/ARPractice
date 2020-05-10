import SwiftUI
import RealityKit

struct ContentView : View {
    var body: some View {
        return ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    let arView = ARView(frame: .zero)

    func makeUIView(context: Context) -> ARView {
        if let box = try? Experience.loadBox() {
            arView.scene.anchors.append(box)
        }
        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {}
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
