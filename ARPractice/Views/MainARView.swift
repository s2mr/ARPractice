import Foundation
import RealityKit
import CoreGraphics

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
