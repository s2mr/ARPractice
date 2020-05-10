import UIKit
import ARKit
import RealityKit

final class MeasureViewController: UIViewController {
    @IBOutlet private weak var resultLabel: UILabel!
    @IBOutlet private weak var measureButton: UIButton! {
        didSet {
            measureButton.addTarget(self, action: #selector(measureButtonTapped), for: .touchUpInside)
        }
    }

    @IBOutlet private var arView: ARView! {
        didSet {
            arView.session.delegate = self
            arView.debugOptions = [.showSceneUnderstanding]
        }
    }

    private var anchor: AnchorEntity? {
        didSet {
            oldValue?.removeFromParent()
            guard let anchor = anchor else { return }
            arView.scene.addAnchor(anchor)
        }
    }

    var startEntity: ModelEntity? {
        didSet {
            oldValue?.removeFromParent()

            guard let entity = startEntity else { return }
            anchor = AnchorEntity(world: entity.position)
            anchor?.addChild(entity, preservingWorldTransform: true)
        }
    }

    var endEntity: ModelEntity? {
        didSet {
            oldValue?.removeFromParent()

            guard let entity = endEntity else { return }
            anchor?.addChild(entity, preservingWorldTransform: true)
        }
    }

    var lineEntity: ModelEntity? {
        didSet {
            oldValue?.removeFromParent()

            guard let entity = lineEntity else { return }
            startEntity?.addChild(entity)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension MeasureViewController: ARSessionDelegate {
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        guard let startEntity = startEntity, endEntity == nil else { return }
        guard let column = arView.hitTest(arView.center, types: .featurePoint).first?.worldTransform.columns.3 else { return }

        let startPosition = startEntity.position
        let endPosition = SIMD3(column.x, column.y, column.z)
        let position = SIMD3(endPosition.x - startPosition.x, endPosition.y - startPosition.y, endPosition.z - startPosition.z)
        let distance = sqrt(position.x*position.x + position.y*position.y + position.z*position.z)
        resultLabel.text = String(format: "%.2fm", distance)

        if let lineEntity = lineEntity {
        }
        else {
            lineEntity = createLineNode(from: startEntity.position, to: position)
        }
    }
}

private extension MeasureViewController {
    @objc private func measureButtonTapped() {
        guard let column = arView.hitTest(arView.center, types: .featurePoint).first?.worldTransform.columns.3 else { return }

        if startEntity == nil
            || startEntity != nil && endEntity != nil {
            // begin measure
            startEntity = createBallNode(at: column)
            endEntity = nil
        }
        else {
            // end measure
            endEntity = createBallNode(at: column)
        }
    }

    func createBallNode(at position: SIMD4<Float>)-> ModelEntity {
        let entity = ModelEntity(mesh: MeshResource.generateSphere(radius: 0.01))
        entity.position = SIMD3(position.x, position.y, position.z)
        return entity
    }

    func createLineNode(from: SIMD3<Float>, to: SIMD3<Float>) -> ModelEntity {
        let box = MeshResource.generateBox(width: abs((to-from).x), height: 0.01, depth: 0.01)
        let entity = ModelEntity(mesh: box)
        entity.position = SIMD3(from.x, from.y, from.z)
        return entity
    }
}
