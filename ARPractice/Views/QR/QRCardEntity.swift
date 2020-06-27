import RealityKit
import UIKit
import Combine
import RealityUI

final class QRCardEntity: Entity, HasModel {
    let twitterCard = try! QRScene.loadTwitterCard()
    var color: UIColor? {
        didSet {
            let cardContainer = twitterCard.allChildren().first { $0.name == "CardContainer" }!.children[0] as! HasModel
            cardContainer.model?.materials = [SimpleMaterial.init(color: color!, isMetallic: false)]
        }
    }

    var cardTapped: (() -> Void)?

    required init() {
        super.init()

        twitterCard.actions.cardTapped.onAction = { [weak self] _ in
            self?.cardTapped?()
        }
        addChild(twitterCard)
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
