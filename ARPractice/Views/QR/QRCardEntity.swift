import RealityKit
import Combine
import RealityUI

final class QRCardEntity: Entity, HasModel {
    let twitterCard = try! QRScene.loadTwitterCard()
    var cardTapped: (() -> Void)?

    required init() {
        super.init()

        print("init")

        twitterCard.actions.cardTapped.onAction = { [weak self] _ in
            self?.cardTapped?()
        }
        addChild(twitterCard)
    }

    func startMotion() {
        twitterCard.notifications.startMotion.post()
    }
}
