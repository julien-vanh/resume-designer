//
//  PortraitPicker.swift
//  ResumeDesigner
//
//  Created by Julien Vanheule on 12/10/2021.
//

import SwiftUI

struct PhotoPicker: View {
    @Binding var photo: String
    @State private var showingImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State private var inputImage: UIImage?
    @State private var image: Image?
    var imageSize: CGFloat = 150
    let picker = MacImagePicker()
    
    var body: some View {
        VStack(alignment: .center) {
            if image != nil {
                image?
                    .resizable()
                    .scaledToFill()
                    .frame(width: imageSize, height: imageSize)
                    .cornerRadius(100)
                    .clipped()
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.gray)
                    .frame(width: imageSize, height: imageSize)
                    .clipped()
            }
            
            Button(action: takePhoto) {
                Text("Take photo").frame(width: 220)
            }
            .buttonStyle(.bordered)
            .tint(.accentColor)
            
            
            Button(action: pickFromLibrary) {
                #if targetEnvironment(macCatalyst)
                Text("Choose a file...")
                    .frame(width: 220)
                #else
                Text("Pick from library")
                    .frame(width: 220)
                #endif
            }
            .buttonStyle(.bordered)
            .tint(.accentColor)
            
            if image != nil {
                Button(action: removePhoto) {
                    Text("Remove photo")
                        .frame(width: 220)
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
            }
            
        }
        .frame(maxWidth: .infinity)
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: self.$inputImage, sourceType: $sourceType)
        }.onAppear {
            if let imageData = Data.init(base64Encoded: photo, options: .init(rawValue: 0)),
               let uiImage = UIImage(data: imageData) {
                self.image = Image(uiImage: uiImage)
            }
        }.onChange(of: inputImage) { newValue in
            guard let inputImage = inputImage else { return }
            image = Image(uiImage: inputImage)
            photo = inputImage.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
        }
    }
    
    func takePhoto() {
        self.sourceType = .camera
        self.showingImagePicker = true
    }
    
    func pickFromLibrary() {
        #if targetEnvironment(macCatalyst)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let source = windowScene.windows.last?.rootViewController {
                picker.didPickedImage =  {image in
                    inputImage = image
                    self.loadImage()
                }
                source.present(picker.viewController, animated: true)
            }
        #else
            self.sourceType = .photoLibrary
            self.showingImagePicker = true
        #endif
    }
    
    func removePhoto(){
        image = nil
        photo = ""
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
        photo = inputImage.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
    }

}


struct PhotoPicker_Previews: PreviewProvider {
    static var previews: some View {
        PhotoPicker(photo: .constant(RandomGenerator.randomResumeContent().contact.photo))
    }
}
