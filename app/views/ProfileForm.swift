//
//  ProfileForm.swift
//  ResumeDesigner
//
//  Created by Julien Vanheule on 01/08/2021.
//

import SwiftUI

struct ProfileForm: View {
    @Binding var contact: ResumeContact
    
    var body: some View {
        Form {
            Section(header: LabelSectionHeader("Presentation")) {
                IconTextField(label: "Full name", imageName: "person", text: $contact.name)
                IconTextField(label: "Headline (ex: Architecte)", imageName: "briefcase", text: $contact.designation)
                PhotoPicker(photo: $contact.photo)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitle("Professional profile")
    }
}

struct ProfileForm_Previews: PreviewProvider {
    static var previews: some View {
        ProfileForm(contact: .constant(ResumeContact()))
    }
}
