import UIKit
import RealityKit
import RealityUI
import ARKit
import Combine
import MultipeerConnectivity

final class TestQRViewController: UIViewController {
    @IBOutlet private weak var arView: ARView! {
        didSet {
            arView.automaticallyConfigureSession = false
            arView.cameraMode = .ar
            arView.renderOptions.insert(.disableGroundingShadows)
            arView.enableRealityUIGestures(.all)
            arView.scene.addAnchor(horizontalAnchor)
            arView.session.delegate = self
        }
    }

    @IBOutlet private weak var mappingStatusLabel: UILabel!
    @IBOutlet private weak var sessionInfoLabel: UILabel!
    @IBOutlet private weak var sendButton: UIButton!
    
    private let horizontalAnchor = AnchorEntity(plane: .horizontal, minimumBounds: [0.01, 0.01])
    var multipeerSession: MultipeerSession!

    override func viewDidLoad() {
        super.viewDidLoad()

        multipeerSession = MultipeerSession(
            receivedDataHandler: receivedData(_:from:),
            connectedHandler: {}
        )
        let config = ARWorldTrackingConfiguration()
        config.isCollaborationEnabled = true
        config.planeDetection = [.horizontal]
        arView.session.run(config, options: [])

        arView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:))))
    }

    @objc func handleTap(recognizer: UITapGestureRecognizer) {
        let location = recognizer.location(in: arView)

        // Attempt to find a 3D location on a horizontal surface underneath the user's touch location.
        let results = arView.raycast(from: location, allowing: .estimatedPlane, alignment: .horizontal)
        if let firstResult = results.first {
            // Add an ARAnchor at the touch location with a special name you check later in `session(_:didAdd:)`.
            let anchor = ARAnchor(name: "QRCardAnchor", transform: firstResult.worldTransform)
            arView.session.add(anchor: anchor)

        } else {
            print("Warning: Object placement failed.")
        }
    }

    private func updateSessionInfoLabel(for frame: ARFrame, trackingState: ARCamera.TrackingState) {
        // Update the UI to provide feedback on the state of the AR experience.
        let message: String

        switch trackingState {
        case .normal where frame.anchors.isEmpty && multipeerSession.connectedPeers.isEmpty:
            // No planes detected; provide instructions for this app's AR interactions.
            message = "Move around to map the environment, or wait to join a shared session."

        case .normal where !multipeerSession.connectedPeers.isEmpty:
            let peerNames = multipeerSession.connectedPeers.map({ $0.displayName }).joined(separator: ", ")
            message = "Connected with \(peerNames)."

        case .notAvailable:
            message = "Tracking unavailable."

        case .limited(.excessiveMotion):
            message = "Tracking limited - Move the device more slowly."

        case .limited(.insufficientFeatures):
            message = "Tracking limited - Point the device at an area with visible surface detail, or improve lighting conditions."

        case .limited(.relocalizing):
            message = "Resuming session — move to where you were when the session was interrupted."

        case .limited(.initializing):
            message = "Initializing AR session."

        default:
            // No feedback needed when tracking is normal and planes are visible.
            // (Nor when in unreachable limited-tracking states.)
            message = ""
        }

        sessionInfoLabel.text = message
    }
}

extension TestQRViewController: ARSessionDelegate {
    /// - Tag: CheckMappingStatus
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        switch frame.worldMappingStatus {
        case .notAvailable, .limited:
            sendButton.isEnabled = false
        case .extending:
            sendButton.isEnabled = !multipeerSession.connectedPeers.isEmpty
        case .mapped:
            sendButton.isEnabled = !multipeerSession.connectedPeers.isEmpty
        @unknown default:
            sendButton.isEnabled = false
        }
        mappingStatusLabel.text = frame.worldMappingStatus.description
        updateSessionInfoLabel(for: frame, trackingState: frame.camera.trackingState)
    }

    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        updateSessionInfoLabel(for: session.currentFrame!, trackingState: camera.trackingState)
    }

    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        for anchor in anchors {
            if anchor.name == "QRCardAnchor" {
                let qrCard = QRCardEntity()
                qrCard.cardTapped = {
                    print("Tapped")
                }
                qrCard.color = UIColor(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1)
                horizontalAnchor.addChild(qrCard)
                qrCard.startMotion()

                // Attach the cube to the ARAnchor via an AnchorEntity.
                //   World origin -> ARAnchor -> AnchorEntity -> ModelEntity
                let anchorEntity = AnchorEntity(anchor: anchor)
                anchorEntity.addChild(qrCard)
                arView.scene.addAnchor(anchorEntity)
            }
        }
    }

    func session(_ session: ARSession, didOutputCollaborationData data: ARSession.CollaborationData) {
        guard let multipeerSession = multipeerSession else { return }
        if !multipeerSession.connectedPeers.isEmpty {
            guard let encodedData = try? NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: true)
                else { fatalError("Unexpectedly failed to encode collaboration data.") }
            // Use reliable mode if the data is critical, and unreliable mode if the data is optional.
            let dataIsCritical = data.priority == .critical
            multipeerSession.sendToAllPeers(encodedData, reliably: dataIsCritical)
        } else {
            print("Deferred sending collaboration to later because there are no peers.")
        }
    }

    func receivedData(_ data: Data, from peer: MCPeerID) {
        if let collaborationData = try? NSKeyedUnarchiver.unarchivedObject(ofClass: ARSession.CollaborationData.self, from: data) {
            return arView.session.update(with: collaborationData)
        }
    }
}

private extension ARFrame.WorldMappingStatus {
    var description: String {
        switch self {
        case .notAvailable:
            return "Not Available"
        case .limited:
            return "Limited"
        case .extending:
            return "Extending"
        case .mapped:
            return "Mapped"
        @unknown default:
            return "Unknown"
        }
    }
}
