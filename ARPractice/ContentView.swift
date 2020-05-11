import SwiftUI
import RealityKit

struct ContentView : View {
    var body: some View {
        return ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

final class GreenBox: Entity, HasModel, HasCollision {
    required init() {
        super.init()

        components.set(ModelComponent(
            mesh: .generateBox(size: [0.05, 0.01, 0.15]),
            materials: [
                SimpleMaterial(color: .green, isMetallic: false)
            ]
        ))

        generateCollisionShapes(recursive: true)
    }
}

struct ARViewContainer: UIViewRepresentable {
    let arView: ARView = {
        let view = ARView(frame: .zero)
        view.debugOptions = [.showStatistics, .showFeaturePoints]
        let anchor = AnchorEntity(plane: .horizontal, minimumBounds: [0.15, 0.15])
        view.scene.addAnchor(anchor)
        let box = GreenBox()
        anchor.addChild(box)
        view.installGestures(for: box)
        return view
    }()

    func makeUIView(context: Context) -> ARView {
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
