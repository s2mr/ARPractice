import RealityKit
import Combine
import RealityUI

final class QRCardEntity: ModelEntity, HasModel {
    var cardTapped: (() -> Void)?

    required init() {
        super.init()

        let twitterCard = try! QRScene.loadTwitterCard()
        twitterCard.actions.cardTapped.onAction = { [weak self] _ in
            self?.cardTapped?()
        }
        addChild(twitterCard)

        startSpin()
    }
}

private extension Entity {
    func startSpin() {
        let spun180 = matrix_multiply(
            transform.matrix,
            Transform(
                scale: .one,
                rotation: .init(),
                translation: [100, 0, 0]
            ).matrix
        )

        move(to: Transform(matrix: spun180), relativeTo: parent, duration: 5, timingFunction: .linear)

        var spinCancellable: Cancellable?
        spinCancellable = scene?.subscribe(to: AnimationEvents.PlaybackCompleted.self, on: self, { [weak self] _ in
            spinCancellable?.cancel()
            self?.startSpin()
        })
    }
}
