import RealityKit

final class ContainerCube: Entity, HasPhysicsBody, HasModel {
    private static var boxPositions: [SIMD3<Float>] = [
        [-1, 0, 0],
        [1, 0, 0],
        [0, -1, 0],
        [0, 1, 0],
        [0, 0, -1],
        [0, 0, 1]
    ]

    required init() {
        super.init()

        let cubeModel = ModelEntity(mesh: .generateBox(size: 0.05), materials: [
            SimpleMaterial(color: Material.Color.lightGray.withAlphaComponent(0.5), isMetallic: false)
        ])
        addChild(cubeModel)

        physicsBody = PhysicsBodyComponent(
            shapes: ContainerCube.boxPositions.map {
                ShapeResource.generateBox(size: .one).offsetBy(translation: $0)
            },
            mass: 1,
            mode: .static
        )
    }
}
