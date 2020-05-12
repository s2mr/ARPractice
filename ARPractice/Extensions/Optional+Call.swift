import UIKit

extension Optional where Wrapped == UIViewController {
    func call(_ handler: (Wrapped) -> Void) {
        if let unwrapped = self {
            handler(unwrapped)
        }
    }
}
