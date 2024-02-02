//
//  TitleOnlyForm.swift
//  ResumeDesigner
//
//  Created by Julien Vanheule on 13/10/2021.
//

import SwiftUI

struct TitleOnlyForm: View {
    @Binding var item: ResumeItem
    
    var body: some View {
        Form {
            Section(header: LabelSectionHeader("Title")) {
                TextField("", text: $item.title)
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
}

struct TitleOnlyForm_Previews: PreviewProvider {
    static var previews: some View {
        TitleOnlyForm(item: .constant(RandomGenerator.randomHobby(withDescription: false)))
    }
}

