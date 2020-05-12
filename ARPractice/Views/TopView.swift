import SwiftUI
import UIKit

struct TopView : View {
    var body: some View {
        ZStack {
            UIViewContainer(uiView: MainARView())
                .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()

                HStack {
                    Spacer()

                    Button(action: {
                        self.showImagePicker()
                    }) {
                        Text("+")
                            .font(.system(.largeTitle))
                            .frame(width: 77, height: 77)
                            .foregroundColor(.white)
                    }
                    .background(Color.green)
                    .cornerRadius(38.5)
                    .padding()
                }
            }
        }
    }

    func showImagePicker() {
        let imagePicker = UIImagePickerController()
        hostingController?.present(imagePicker, animated: true)
    }
}

#if DEBUG
struct TopView_Previews : PreviewProvider {
    static var previews: some View {
        TopView()
    }
}
#endif
