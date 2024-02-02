//
//  IconTextField.swift
//  ResumeDesigner
//
//  Created by Julien Vanheule on 12/08/2021.
//

import SwiftUI

struct IconField<Content: View>: View {
    var imageName: String
    let content: () -> Content
    
    init(imageName: String, @ViewBuilder content: @escaping () -> Content) {
        self.imageName = imageName
        self.content = content
    }
    
    var body: some View {
        HStack {
            Image(systemName: imageName)
                .foregroundColor(.gray)
                .frame(width: 30, height: 30)
                .layoutPriority(1)
                .padding(.leading, -10)
            content()
        }
    }
}

struct IconTextField: View {
    var label: String
    var imageName: String
    @Binding var text: String
    var autocapitalization: TextInputAutocapitalization = .sentences
    
    var body: some View {
        IconField(imageName: imageName) {
            TextField(NSLocalizedString(label, comment:""), text: $text)
                .textInputAutocapitalization(autocapitalization)
        }
    }
}

struct IconTextField_Previews: PreviewProvider {
    static var previews: some View {
        IconTextField(label: "Name", imageName: "person", text: .constant("Valeur"))
            .previewLayout(.sizeThatFits).frame(maxWidth: .infinity)
    }
}

