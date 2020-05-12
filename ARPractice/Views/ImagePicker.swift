import UIKit

final class ImagePicker: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate, ObservableObject {
    @Published var imageURL: URL?

    func present(on viewController: UIViewController) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        viewController.present(imagePicker, animated: true)
    }

    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        imageURL = info[.imageURL] as? URL
        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
