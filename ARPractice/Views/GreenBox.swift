import RealityKit

final class GreenBox: Entity, HasModel, HasCollision {
    required init() {
        super.init()

        var material = SimpleMaterial(color: .green, isMetallic: false)
        if let resource = try? TextureResource.load(named: "risu") {
            print(resource)
            material.baseColor = MaterialColorParameter.texture(resource)
        }
        components.set(ModelComponent(
            mesh: .generateBox(size: [0.05, 0.01, 0.15]),
            materials: [material]
        ))

        generateCollisionShapes(recursive: true)
    }
}
