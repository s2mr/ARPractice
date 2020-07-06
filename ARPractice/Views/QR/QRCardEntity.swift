import RealityKit
import UIKit
import Combine
import RealityUI

final class QRCardEntity: Entity, HasModel {
    /// これはModelEntityではなくEntity: HasAnchoring...であるため、addChildすると常にposition0の初期位置になる。
    /// twitterCard.cardObjectはModelEntityなのでそちらを使用する。
    let twitterCard = try! QRScene.loadTwitterCard()

    let cardContainer: HasModel

    var color: UIColor? {
        didSet {
            guard let color = color else { return }
            cardContainer.model?.materials = [SimpleMaterial.init(color: color, isMetallic: false)]
        }
    }

/// twitterCardをaddChildしないので、sceneが存在せず、actions, notificationsを使用することはできない
//    var cardTapped: (() -> Void)?

    var position: SIMD3<Float> = .zero {
        didSet {
            twitterCard.position = position
        }
    }

    required init() {
        cardContainer = twitterCard.allChildren().first { $0.name == "CardContainer" }?.children[0] as! HasModel

        super.init()

//        twitterCard.actions.cardTapped.onAction = { [weak self] _ in
//            self?.cardTapped?()
//        }

        addChild(twitterCard.cardObject!)
        twitterCard.cardObject?.addChild(twitterCard)
    }

//    func startMotion() {
//        twitterCard.notifications.startMotion.post()
//    }

    func startBounce() {
        move(
            to: Transform(scale: .init(repeating: 1.2), rotation: .init(), translation: .zero),
            relativeTo: parent,
            duration: 0.2,
            timingFunction: .easeIn
        )

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.move(to: .identity, relativeTo: self.parent, duration: 0.2, timingFunction: .easeOut)
        }
    }
}

private extension Entity {
    func allChildren() -> [Entity] {
        children.reduce([]) { $0 + [$1] + $1.allChildren() }
    }
}
