import SwiftUI
import UIKit

struct TopView: View {
    @ObservedObject var imagePicker = ImagePicker()

    var body: some View {
        ZStack {
            MainARView(imageURL: imagePicker.imageURL)
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
        hostingController.call(imagePicker.present(on:))
    }
}

#if DEBUG
struct TopView_Previews : PreviewProvider {
    static var previews: some View {
        TopView()
    }
}
#endif
