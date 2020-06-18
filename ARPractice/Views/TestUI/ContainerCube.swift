import RealityKit
import UIKit

public final class ContainerCube: Entity, HasPhysicsBody, HasModel {
    private static var boxPositions: [SIMD3<Float>] = [
        [-0.05, 0, 0],
        [0.05, 0, 0],
        [0, -0.05, 0],
        [0, 0.05, 0],
        [0, 0, -0.05],
        [0, 0, 0.05]
    ]

    var color: UIColor? {
        didSet {
            model = ModelComponent(mesh: .generateBox(size: 0.05), materials: [
                SimpleMaterial(color: (color ?? .clear).withAlphaComponent(0.7), isMetallic: false)
            ])
        }
    }

    required init() {
        super.init()

        collision = CollisionComponent(
            shapes: ContainerCube.boxPositions.map {
                ShapeResource.generateBox(size: [0.05, 0.05, 0.05]).offsetBy(translation: $0)
            },
            mode: .default,
            filter: .init(group: .init(rawValue: 1 << 31), mask: .init(rawValue: 1 << 31))
        )

        physicsBody = PhysicsBodyComponent(
            shapes: [ShapeResource.generateBox(size: [0.05, 0.05, 0.05])],
            mass: 0.05,
            mode: .static
        )
    }

    func spawnCube() {
        addChild(Cube())
    }
}

extension ContainerCube {
    final class Cube: Entity, HasModel, HasPhysics {
        public required init() {
            super.init()

            let mesh = MeshResource.generateBox(size: 0.01)
            model = ModelComponent(mesh: mesh, materials: [
                SimpleMaterial(color: .green, isMetallic: false)
            ])
            generateCollisionShapes(recursive: false)
            collision?.filter = CollisionFilter(group: .all, mask: .all)
            physicsBody = PhysicsBodyComponent(
                shapes: [.generateConvex(from: mesh)],
                mass: 1,
                material: .generate(friction: 0.8, restitution: 0.3),
                mode: .dynamic
            )
            orientation = .init(angle: .pi / 1.5, axis: [1, 0, 0])
            scale = [0.5, 0.5, 0.5]
        }
    }
}
