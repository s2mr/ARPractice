import Foundation
import RealityKit

final class GreenBox: Entity, HasModel, HasCollision {
    var imageURL: URL? {
        didSet {
            guard let url = imageURL else { return }

//            if let resource = try? TextureResource.load(contentsOf: url) {
//                (model?.materials.first as! SimpleMaterial).baseColor = MaterialColorParameter.texture(resource)
//            }

            var material = SimpleMaterial(color: .green, isMetallic: false)
            if let resource = try? TextureResource.load(contentsOf: url) {
                material.baseColor = MaterialColorParameter.texture(resource)
            }
            components.set(ModelComponent(
                mesh: .generateBox(size: [0.05, 0.01, 0.15]),
                materials: [material]
            ))
        }
    }

    required init() {
        super.init()

        var material = SimpleMaterial(color: .green, isMetallic: false)
        if let resource = try? TextureResource.load(named: "risu") {
            material.baseColor = MaterialColorParameter.texture(resource)
        }
        components.set(ModelComponent(
            mesh: .generateBox(size: [0.05, 0.01, 0.15]),
            materials: [material]
        ))

        generateCollisionShapes(recursive: true)
    }
}
