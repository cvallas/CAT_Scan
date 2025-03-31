import SwiftUI
import UIKit

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    var isCamera: Bool
    @Environment(\.presentationMode) private var presentationMode  // Dismiss picker manually

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator

        // Check if the camera is available before setting the source type
        if isCamera {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                picker.sourceType = .camera
            } else {
                // Show an alert or fallback to photo library
                DispatchQueue.main.async {
                    context.coordinator.showCameraUnavailableAlert()
                }
                picker.sourceType = .photoLibrary
            }
        } else {
            picker.sourceType = .photoLibrary
        }

        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self, presentationMode: presentationMode)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        @Binding var presentationMode: PresentationMode  // Allows manual dismissal

        init(_ parent: ImagePicker, presentationMode: Binding<PresentationMode>) {
            self.parent = parent
            self._presentationMode = presentationMode
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.selectedImage = uiImage
            }
            presentationMode.dismiss()  // Close picker
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            presentationMode.dismiss()  // Close picker
        }

        func showCameraUnavailableAlert() {
            let alert = UIAlertController(
                title: "Camera Unavailable",
                message: "Your device does not support a camera.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))

            if let topVC = UIApplication.shared.windows.first?.rootViewController {
                topVC.present(alert, animated: true)
            }
        }
    }
}
