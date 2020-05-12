import SwiftUI

extension View {
    var hostingController: UIViewController? {
        AppDelegate.shared.window?.rootViewController
    }
}
