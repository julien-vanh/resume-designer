//
//  ImagePicker.swift
//  ResumeDesigner (iOS)
//
//  Created by Julien Vanheule on 12/08/2021.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.dismiss) private var dismiss
    @Binding var image: UIImage?
    @Binding var sourceType: UIImagePickerController.SourceType

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {

    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage.resizeImage()
            }

            parent.dismiss()
        }
        
        
    }
}


extension UIImage {
    func resizeImage() -> UIImage {
        var actualHeight: Float = Float(self.size.height)
        var actualWidth: Float = Float(self.size.width)
        let maxHeight: Float = 250.0
        let maxWidth: Float = 250.0
        var imgRatio: Float = actualWidth / actualHeight
        let maxRatio: Float = maxWidth / maxHeight
        let compressionQuality: CGFloat = 0.9

        if actualHeight > maxHeight || actualWidth > maxWidth {
            if imgRatio < maxRatio {
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            }
            else if imgRatio > maxRatio {
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            }
            else {
                actualHeight = maxHeight
                actualWidth = maxWidth
            }
        }
        let rect = CGRect(x: 0, y: 0, width: CGFloat(actualWidth), height: CGFloat(actualHeight))
        UIGraphicsBeginImageContext(rect.size)
            self.draw(in: rect)
            let img = UIGraphicsGetImageFromCurrentImageContext()
            let imageData = img!.jpegData(compressionQuality: compressionQuality)
        UIGraphicsEndImageContext()
        
        return UIImage(data: imageData!)!
    }
}
