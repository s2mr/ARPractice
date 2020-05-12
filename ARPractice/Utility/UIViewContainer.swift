import SwiftUI

struct UIViewContainer: UIViewRepresentable {
    let uiView: UIView

    func makeUIView(context: Context) -> UIView {
        uiView
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
