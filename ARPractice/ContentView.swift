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

final class MainARView: ARView {
    init() {
        super.init(frame: .zero)

        debugOptions = [.showStatistics, .showFeaturePoints]
        let anchor = AnchorEntity(plane: .horizontal, minimumBounds: [0.15, 0.15])
        scene.addAnchor(anchor)
        let box = GreenBox()
        anchor.addChild(box)
        installGestures(for: box)
    }

    @objc required dynamic init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc required dynamic init(frame frameRect: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }
}

struct ARViewContainer: UIViewRepresentable {
    let arView = MainARView()

    func makeUIView(context: Context) -> ARView {
        arView
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
