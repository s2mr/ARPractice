import Foundation
import RealityKit

final class GreenBox: Entity, HasModel, HasCollision {
    var imageURL: URL? {
        didSet {
            guard let url = imageURL else { return }

            #warning("TODO: only change baseColor")
            model?.materials[0] = makeMaterial(for: url)
        }
    }

    required init() {
        super.init()

        components.set(ModelComponent(
            mesh: .generateBox(size: [0.05, 0.01, 0.15]),
            materials: [makeMaterial(for: nil)]
        ))
        generateCollisionShapes(recursive: true)
    }

    private func makeMaterial(for imageURL: URL?) -> SimpleMaterial {
        var material = SimpleMaterial(color: .green, isMetallic: false)
        if let resource = imageURL.map ({ try? TextureResource.load(contentsOf: $0) })
            ?? (try? TextureResource.load(named: "risu")) {
            material.baseColor = MaterialColorParameter.texture(resource)
        }

        return material
    }
}
