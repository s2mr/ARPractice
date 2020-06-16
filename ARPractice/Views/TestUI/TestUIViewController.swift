import UIKit
import RealityUI
import RealityKit
import ARKit
import Combine

final class TestUIViewController: UIViewController {
    private let horizontalAnchor = AnchorEntity(plane: .horizontal, minimumBounds: [0.01, 0.01])

    @IBOutlet private weak var arView: ARView! {
        didSet {
            arView.automaticallyConfigureSession = false
            arView.cameraMode = .ar
            arView.renderOptions.insert(.disableGroundingShadows)
            arView.enableRealityUIGestures(.all)
            arView.scene.addAnchor(horizontalAnchor)

            let config = ARWorldTrackingConfiguration()
            config.planeDetection = [.horizontal]
            arView.session.run(config, options: [])
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSwitch()
    }

    private func setupSwitch() {
        RealityUI.registerComponents()

        let switchUI = RUISwitch(
            switchness: SwitchComponent(isOn: false, onColor: .black, offColor: .black, borderColor: .red, thumbColor: .blue),
            RUI: RUIComponent(isEnabled: true, respondsToLighting: true)
        ) { switchUI in
            print(switchUI.isOn)
        }
        switchUI.transform = Transform(scale: .init(repeating: 0.03), rotation: .init())
        horizontalAnchor.addChild(switchUI)

        let tumbler = ContainerCube()
        tumbler.position = [0, 0, -0.1]
        horizontalAnchor.addChild(tumbler)
    }
}
