import UIKit
import SwiftUI

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = TestUIViewController()
        self.window = window
        window.makeKeyAndVisible()
        return true
    }
}

extension AppDelegate {
    static let shared = UIApplication.shared.delegate as! AppDelegate
}
