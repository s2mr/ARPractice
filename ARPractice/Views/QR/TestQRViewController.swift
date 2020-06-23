import UIKit
import RealityKit
import RealityUI
import ARKit
import Combine

final class TestQRViewController: UIViewController {
    private let horizontalAnchor = AnchorEntity(plane: .horizontal, minimumBounds: [0.01, 0.01])

    @IBOutlet private weak var arView: ARView! {
        didSet {
            arView.automaticallyConfigureSession = false
            arView.cameraMode = .ar
            arView.renderOptions.insert(.disableGroundingShadows)
            arView.enableRealityUIGestures(.all)
            arView.scene.addAnchor(horizontalAnchor)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal]
        arView.session.run(config, options: [])

        let qrCard = QRCardEntity()
        qrCard.cardTapped = {
            print("Tapped")
        }
        horizontalAnchor.addChild(qrCard)
    }
}
