import RealityKit
import UIKit
import Combine
import RealityUI

final class QRCardEntity: Entity, HasModel {
    /// これがModelEntityではなくEntityになっている可能性が高い
    let twitterCard = try! QRScene.loadTwitterCard()
    var cardContainer: HasModel {
        twitterCard.allChildren().first { $0.name == "CardContainer" }!.children[0] as! HasModel
    }
    var color: UIColor? {
        didSet {
            cardContainer.model?.materials = [SimpleMaterial.init(color: color!, isMetallic: false)]
        }
    }

    var cardTapped: (() -> Void)?

    var position: SIMD3<Float> = .zero {
        didSet {
            twitterCard.position = position
        }
    }

    required init() {
        super.init()

        twitterCard.actions.cardTapped.onAction = { [weak self] _ in
            self?.cardTapped?()
        }
        addChild(twitterCard)
        twitterCard.position = -twitterCard.visualBounds(relativeTo: nil).center

        addChild(ModelEntity(mesh: .generateBox(size: 0.1), materials: [SimpleMaterial(color: color ?? .white, isMetallic: false)]))
    }

    func startMotion() {
        twitterCard.notifications.startMotion.post()
    }
}

private extension Entity {
    func allChildren() -> [Entity] {
        children.reduce([]) { $0 + [$1] + $1.allChildren() }
    }
}
