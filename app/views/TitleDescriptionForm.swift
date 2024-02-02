//
//  TitleDescriptionForm.swift
//  ResumeDesigner
//
//  Created by Julien Vanheule on 11/08/2021.
//

import SwiftUI

struct TitleDescriptionForm: View {
    @Binding var item: ResumeItem
    
    var body: some View {
        Form {
            Section(header: LabelSectionHeader("Title")) {
                TextField("", text: $item.title)
            }
            
            Section(header: LabelSectionHeader("Description")) {
                TextEditor(text: $item.description).frame(height: 300)
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
}

struct TitleDescriptionForm_Previews: PreviewProvider {
    static var previews: some View {
        TitleDescriptionForm(item: .constant(RandomGenerator.randomHobby(withDescription: true)))
    }
}
