import SwiftUI

struct TopView : View {
    var body: some View {
        UIViewContainer(uiView: MainARView())
            .edgesIgnoringSafeArea(.all)
    }
}

#if DEBUG
struct TopView_Previews : PreviewProvider {
    static var previews: some View {
        TopView()
    }
}
#endif
