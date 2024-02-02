//
//  EducationForm.swift
//  ResumeDesigner
//
//  Created by Julien Vanheule on 01/08/2021.
//

import SwiftUI

struct SectionForm: View {
    @Binding var section: ResumeSection
    @Environment(\.editMode) var editMode
    @State private var displayItemForm = false
    @State var selectedItem = ResumeItem()
    @State var popoverTitle: String = ""
    @State var isShowingAlert = false
    
    var body: some View {
        List {
            ForEach(section.items) { item in
                Button(action: {
                    selectedItem = item
                    popoverTitle = NSLocalizedString("Editing", comment: "")
                    displayItemForm = true
                }) {
                    HStack {
                        SectionLine(section: section, item: item).id(item.title)
                            
                        Spacer()
                        Image(systemName: "chevron.forward")
                            .foregroundColor(.gray)
                    }.padding(.vertical, 3)
                }
            }
            .onMove(perform: move)
            .onDelete(perform: deleteItem)
            
            if self.editMode?.wrappedValue == .inactive {
                Button(action: {
                    selectedItem = ResumeItem()
                    popoverTitle = NSLocalizedString("New item", comment: "")
                    displayItemForm = true
                }, label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add an item")
                        Spacer()
                    }
                    .foregroundColor(.accentColor)
                })
                
            }
        }
        .listStyle(PlainListStyle())
        .sheet(isPresented: $displayItemForm, onDismiss: didDismiss) {
            ItemFormPopover(item: $selectedItem, section: section, title: popoverTitle)
        }
        .textFieldAlert(isPresented: $isShowingAlert, content: {
            TextFieldAlert(title: "Section name", placeholder: nil, text: $section.title)
        })
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    Text(section.title).font(.headline)
                    Button(action: {
                        isShowingAlert = true
                    }) {
                        Image(systemName: "pencil")
                            .foregroundColor(.accentColor)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
                    .foregroundColor(.accentColor)
                    .buttonStyle(PlainButtonStyle())
            }
        }
    }
    
    func didDismiss() {
        if let index = section.items.firstIndex(where: { $0.id == selectedItem.id }) {
            //update item
            section.items[index] = selectedItem
        } else {
            //New item
            if !selectedItem.title.isEmpty || !selectedItem.description.isEmpty {
                section.items.append(selectedItem)
            }
        }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        section.items.move(fromOffsets: source, toOffset: destination)
    }
    
    func deleteItem(at offsets: IndexSet) {
        section.items.remove(atOffsets: offsets)
    }
    
    func deleteSection(at offsets: IndexSet) {
        section.items.remove(atOffsets: offsets)
    }
    
    func form(_ item: ResumeItem) -> AnyView {
        let index = section.items.firstIndex(of: item)
        
        let itemBinding = Binding<ResumeItem>(
            get: {
                if let foundIndex = index {
                    return section.items[foundIndex]
                } else {
                    return ResumeItem()
                }
            },
            set: {
                if let foundIndex = index {
                    section.items[foundIndex] = $0
                }
            }
        )
        
        return ResumeFormBuilder.formFor(section: section, item: itemBinding)
    }
}

struct SectionForm_Previews: PreviewProvider {
    
    static var previews: some View {
        SectionForm(section: .constant(RandomGenerator.randomResumeContent().sections[0]))
    }
}
