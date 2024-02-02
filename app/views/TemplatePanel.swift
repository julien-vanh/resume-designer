//
//  TemplatePanel.swift
//  ResumeDesigner
//
//  Created by Julien Vanheule on 03/09/2021.
//

import SwiftUI

struct TemplatePanel: View {
    @Binding var style: ResumeStyle
    
    var body: some View {
        List {
            
            VStack {
                TemplateCarousel(value: $style.titleTemplate,  templateGroup: TemplateStore.shared.titles)
            
                Picker(selection: $style.titleAlignment, label: EmptyView(), content: {
                    ForEach(TextAlignmentType.allCases) { v in
                        Image(systemName: TextAlignmentType.imageFor(v))
                            .tag(v)
                    }
                })
                .pickerStyle(SegmentedPickerStyle())
                .frame(maxWidth: 200)
            }.frame(maxWidth: .infinity)
            
            TemplateCarousel(value: $style.sectionTemplate, templateGroup: TemplateStore.shared.sections)
            
            TemplateCarousel(value: $style.contactTemplate, templateGroup: TemplateStore.shared.contacts)
            
            TemplateCarousel(value: $style.itemTemplate, templateGroup: TemplateStore.shared.items)
        }
        .listStyle(PlainListStyle())
    }
}

struct TemplatePanel_Previews: PreviewProvider {
    static var previews: some View {
        TemplatePanel(style: .constant(ResumeStyle()))
    }
}
