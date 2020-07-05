import Foundation
import UIKit

struct AnchorColorPayload: Codable {
    var senderSessionIdentifier: UUID?
    var colors: [UUID: ColorPayload] = [:]
}

struct ColorPayload: Codable {
    var colorHex: Int
}

extension UIColor {
    convenience init(hex: Int) {
        let red = (hex & 0xff0000) >> 16
        let green = (hex & 0x00ff00) >> 8
        let blue = hex & 0x0000ff

        self.init(
            red: CGFloat(red) / 255,
            green: CGFloat(green) / 255,
            blue: CGFloat(blue) / 255,
            alpha: 1
        )
    }

    var hex: Int {
        var red = CGFloat(0)
        var green = CGFloat(0)
        var blue = CGFloat(0)
        getRed(&red, green: &green, blue: &blue, alpha: nil)

        return Int(red * 255) << 16
            + Int(green * 255) << 8
            + Int(blue * 255)
    }
}
