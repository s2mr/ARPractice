import RealityKit
import UIKit
import Combine
import RealityUI

final class QRCardEntity: Entity, HasModel {
    /// これがModelEntityではなくEntityになっている可能性が高い
    let twitterCard = try! QRScene.loadTwitterCard()

    let cardContainer: HasModel

    var color: UIColor? {
        didSet {
            guard let color = color else { return }
            cardContainer.model?.materials = [SimpleMaterial.init(color: color, isMetallic: false)]
        }
    }

    var cardTapped: (() -> Void)?

    var position: SIMD3<Float> = .zero {
        didSet {
            twitterCard.position = position
        }
    }

    required init() {
        cardContainer = twitterCard.allChildren().first { $0.name == "CardContainer" }?.children[0] as! HasModel

        super.init()

        twitterCard.actions.cardTapped.onAction = { [weak self] _ in
            self?.cardTapped?()
        }

        addChild(twitterCard.cardObject!)
        twitterCard.cardObject?.addChild(twitterCard)
    }

    func startMotion() {
//        twitterCard.notifications.startMotion.post()
    }
}

private extension Entity {
    func allChildren() -> [Entity] {
        children.reduce([]) { $0 + [$1] + $1.allChildren() }
    }
}
