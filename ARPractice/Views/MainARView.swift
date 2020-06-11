import SwiftUI
import Foundation
import RealityKit
import CoreGraphics

final class _MainARView: ARView {
    let box = GreenBox()

    init() {
        super.init(frame: .zero)

        debugOptions = [.showStatistics, .showFeaturePoints]
        let anchor = AnchorEntity(plane: .horizontal, minimumBounds: [0.15, 0.15])
        scene.addAnchor(anchor)

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

struct MainARView: UIViewRepresentable {
    var imageURL: URL?

    func makeUIView(context: Context) -> _MainARView {
        _MainARView()
    }

    func updateUIView(_ arView: _MainARView, context: Context) {
        if let imageURL = imageURL {
            arView.box.imageURL = imageURL
        }
    }
}
