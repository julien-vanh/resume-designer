//
//  LanguageForm.swift
//  ResumeDesigner
//
//  Created by Julien Vanheule on 11/08/2021.
//

import SwiftUI

struct LanguageForm: View {
    @Binding var item: ResumeItem
    var levels: [LanguageLevel] = [.a1, .a2, .b1, .b2, .c1, .c2, .native]
    
    var body: some View {
        Form {
            Section(header: LabelSectionHeader("Language")) {
                TextField("ex: French", text: $item.title)
            }
            
            Section(header: LabelSectionHeader("Level")) {
                Picker("Choose a level", selection: $item.rate) {
                    ForEach(levels, id: \.self) {
                        Text(LanguageLevel.labelFor($0)).tag($0.rawValue)
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
}

struct LanguageForm_Previews: PreviewProvider {
    static var previews: some View {
        LanguageForm(item: .constant(ResumeItem()))
    }
}
