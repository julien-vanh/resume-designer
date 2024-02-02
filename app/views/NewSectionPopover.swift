//
//  NewSectionModal.swift
//  ResumeDesigner
//
//  Created by Julien Vanheule on 29/08/2021.
//

import SwiftUI

struct NewSectionPopover: View {
    @Environment(\.dismiss) private var dismiss
    var onSave: ((_ section: ResumeSection) -> Void)
    @State var newSection: ResumeSection = ResumeSection(title: "", style: .detailled)
    @State var attempts: Int = 0
    
    var body: some View {
        NavigationView {
            List {
                Section(header: LabelSectionHeader("Section title"),
                        footer: Text((attempts > 0 && newSection.title.isEmpty) ? "The title is mandatory." : "")
                        .font(.caption)
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                ) {
                    VStack {
                        TextField("ex: Certifications", text: $newSection.title)
                    }.modifier(Shake(animatableData: CGFloat(attempts)))
                }
                
                Section(header: LabelSectionHeader("Style"),
                        footer: HeroButton(label: "Add", action: createSection).padding()
                ) {
                    ForEach(SectionType.allCases, id: \.self) { style in
                        Button(action: {
                            newSection.style = style
                        }) {
                            HStack(alignment: .center) {
                                Image(systemName: SectionType.systemImageFor(style))
                                
                                VStack(alignment: .leading) {
                                    Text(SectionType.labelFor(style))
                                        .foregroundColor(newSection.style == style ? .accentColor: .primary)
                                    Text(SectionType.descriptionFor(style))
                                        .font(.caption)
                                        .foregroundColor(newSection.style == style ? .accentColor:.gray)
                                }
                                Spacer()
                                if newSection.style == style {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.accentColor)
                                        .layoutPriority(1)
                                        .frame(width: 30)
                                } else {
                                    Rectangle()
                                        .opacity(0)
                                        .frame(width: 30)
                                        
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("New section")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .keyboardShortcut(.cancelAction)
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func createSection() {
        if !newSection.title.isEmpty {
            onSave(newSection)
            dismiss()
        } else {
            withAnimation(.default) {
                self.attempts += 1
            }
        }
    }
}

struct NewSectionPopover_Previews: PreviewProvider {
    static var previews: some View {
        NewSectionPopover { _ in }
        .previewLayout(.fixed(width: /*@START_MENU_TOKEN@*/500.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/500.0/*@END_MENU_TOKEN@*/))
    }
}
