//
//  DocumentPicker.swift
//  File Picker
//
//  Created by Andreas Prang on 10.07.20.
//

import SwiftUI


final class MacImagePicker: NSObject, UIViewControllerRepresentable {
    typealias UIViewControllerType = UIDocumentPickerViewController
    var didPickedImage: ((_ image: UIImage) -> Void)?

    lazy var viewController:UIDocumentPickerViewController = {
        let vc = UIDocumentPickerViewController(forOpeningContentTypes: [.image])
        vc.allowsMultipleSelection = false
        vc.delegate = self
        return vc
    }()

    func makeUIViewController(context: UIViewControllerRepresentableContext<MacImagePicker>) -> UIDocumentPickerViewController {
        viewController.delegate = self
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: UIViewControllerRepresentableContext<MacImagePicker>) {
    }
}

extension MacImagePicker: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if urls.count == 1 {
            if let image = UIImage(contentsOfFile: urls[0].path) {
                didPickedImage?(image)
            }
        }
    }
}
