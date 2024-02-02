//
//  DescriptionForm.swift
//  ResumeDesigner
//
//  Created by Julien on 19/12/2021.
//

import SwiftUI

struct DescriptionForm: View {
    @Binding var item: ResumeItem
    
    var body: some View {
        Form {
            Section(header: LabelSectionHeader("Paragraph")) {
                TextEditor(text: $item.description).frame(height: 300)
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
}

struct DescriptionForm_Previews: PreviewProvider {
    static var previews: some View {
        DescriptionForm(item: .constant(RandomGenerator.randomHobby(withDescription: true)))
    }
}
