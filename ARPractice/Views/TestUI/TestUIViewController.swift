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

        let tumbler = ContainerCube()
        tumbler.color = .gray
        tumbler.position = [0, 0, -0.1]
        horizontalAnchor.addChild(tumbler)

        let switchUI = RUISwitch(
            switchness: SwitchComponent(isOn: false, onColor: .green, offColor: .gray, borderColor: .black, thumbColor: .white),
            RUI: RUIComponent(isEnabled: true, respondsToLighting: false)
        ) { switchUI in
            tumbler.color = switchUI.isOn ? .red : .blue
        }
        switchUI.transform = Transform(scale: .init(repeating: 0.03), rotation: .init())
        horizontalAnchor.addChild(switchUI)

        let rotateSwitch = RUISwitch() { switchUI in
            if switchUI.isOn {
                tumbler.startSpin()
            }
            else {
                tumbler.stopAllAnimations()
            }
        }
        rotateSwitch.transform = Transform(scale: .init(repeating: 0.03), rotation: .init())
        rotateSwitch.position = [-0.06, 0, 0]
        horizontalAnchor.addChild(rotateSwitch)

        let button = RUIButton()
        button.transform = Transform(
            scale: .init(repeating: 0.03),
            rotation: simd_quatf(angle: -.pi / 2, axis: [1, 0, 0])
        )
        button.touchUpCompleted = { _ in
            tumbler.spawnCube()
        }
        button.position = [0.05, 0, 0]
        horizontalAnchor.addChild(button)
    }
}
