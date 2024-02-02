//
//  NewItemPopover.swift
//  ResumeDesigner
//
//  Created by Julien Vanheule on 17/08/2021.
//

import SwiftUI

class ResumeFormBuilder {
    static func formFor(section: ResumeSection, item: Binding<ResumeItem>) -> AnyView {
        let view: AnyView
        switch section.style {
        case .language:
            view = AnyView(LanguageForm(item: item))
        case .titleRate:
            view = AnyView(TitleRateForm(item: item))
        case .titleDescription:
            view = AnyView(TitleDescriptionForm(item: item))
        case .descriptionOnly:
            view = AnyView(DescriptionForm(item: item))
        case .titleOnly:
            view = AnyView(TitleOnlyForm(item: item))
        default:
            view = AnyView(DetailledForm(item: item, isEducationsection: section.title == NSLocalizedString("Education", comment: "")))
        }
        return view
    }
}

struct ItemFormPopover: View {
    @Binding var item: ResumeItem
    var section: ResumeSection
    var title: String
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ResumeFormBuilder.formFor(section: section, item: $item)
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Save") {
                            dismiss()
                        }
                        .keyboardShortcut(.cancelAction)
                    }
                }
        }
    }
}

struct NewItemPopover_Previews: PreviewProvider {
    static var previews: some View {
        ItemFormPopover(item: .constant(ResumeItem()), section: ResumeSection(title: "Experiences", style: .detailled), title: "Titre")
    }
}
