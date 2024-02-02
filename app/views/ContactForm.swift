//
//  ContactForm.swift
//  ResumeDesigner
//
//  Created by Julien Vanheule on 30/07/2021.
//

import SwiftUI

struct ContactForm: View {
    @Binding var contact: ResumeContact
    @Binding var contactTitle: String
    @State var isShowingAlert = false
    
    var body: some View {
        Form {
            Section(header: LabelSectionHeader("Contact information")) {
                IconTextField(label: "Phone", imageName: "phone", text: $contact.phone)
                IconTextField(label: "Email", imageName: "envelope", text: $contact.email, autocapitalization: .never)
            }
            
            Section(header: LabelSectionHeader("Address")) {
                TextField("Street", text: $contact.street)
                TextField("Postal code", text: $contact.postalCode)
                TextField("City", text: $contact.city)
                TextField("State/Region", text: $contact.state)
                TextField("Country", text: $contact.country)
            }
            
            Section(header: LabelSectionHeader("Additional information")) {
                ForEach(contact.lines) { line in
                    HStack {
                        ContactLineListItem(line: binding(for:line))
                        Button(action: {
                            contact.lines.removeAll { $0.id == line.id }
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }.id(line.id)
                }
                Button(action: {
                    contact.lines.append(ResumeContactLine())
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add an item")
                        Spacer()
                    }
                    .foregroundColor(.accentColor)
                }
                .buttonStyle(.plain)
            }
        }
        .textFieldAlert(isPresented: $isShowingAlert, content: {
            TextFieldAlert(title: "Section name", placeholder: "Contact", text: $contact.sectionName)
        })
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    Text(contactTitle).font(.headline)
                    Button(action: {
                        isShowingAlert = true
                    }) {
                        Image(systemName: "pencil")
                            .foregroundColor(.accentColor)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
        
    
    
    func binding(for line: ResumeContactLine) -> Binding<ResumeContactLine> {
        let index = contact.lines.firstIndex(of: line)
        
        return Binding<ResumeContactLine>(
            get: {
                if let foundIndex = index {
                    return contact.lines[foundIndex]
                } else {
                    return ResumeContactLine()
                }
            },
            set: {
                if let foundIndex = index {
                    contact.lines[foundIndex] = $0
                } else {
                    //section.items.append(item)
                }
            }
        )
    }
}


struct ContactForm_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContactForm(contact: .constant(ResumeContact()), contactTitle: .constant("Contact"))
        }
    }
}




