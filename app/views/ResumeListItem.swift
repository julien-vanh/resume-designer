//
//  ResumeListItem.swift
//  ResumeDesigner
//
//  Created by Julien Vanheule on 23/09/2022.
//

import SwiftUI

struct ResumeListItem: View {
    @ObservedObject var cdResume: CDResume
    var resume: ResumeContent
    @Environment(\.editMode) var editMode
    @Environment(\.managedObjectContext) var managedObjectContext
    @State private var isPresented = false
    @State private var showingDeleteConfirmation = false

    init(cdResume: CDResume) {
        self.resume = Resume(cdResume).content
        self.cdResume = cdResume
    }
    
    var body: some View {
        HStack(spacing: 15) {
            VStack(alignment: .leading, spacing: 5) {
                if self.editMode?.wrappedValue == .active {
                    HStack(alignment: .center) {
                        Image(systemName: "pencil")
                            
                        TextField("My resume", text: $cdResume.name.toUnwrapped(defaultValue: ""), onEditingChanged: save)
                            .foregroundColor(.accentColor)
                    }
                    .font(.title2)
                } else {
                    Text("\(((cdResume.name ?? "").isEmpty ? NSLocalizedString("My resume", comment: "") : cdResume.name) ?? "")")
                        .bold()
                        .font(.title2)
                }
                
                Group {
                    Text(resume.contact.name)
                    Text(resume.contact.designation.uppercased())
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                .opacity(self.editMode?.wrappedValue == .active ? 0.6 : 1)
                
                Spacer()
                
                HStack {
                    if self.editMode?.wrappedValue == .active {
                        Button(action: {
                            copy(cdResume)
                        }) {
                            Text("Copy")
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.accentColor)
                        
                        Button(role: .destructive, action: {
                            showingDeleteConfirmation = true
                        }) {
                            Text("Delete")
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.red)
                        .alert(isPresented:$showingDeleteConfirmation) {
                            Alert(
                                title: Text("Deletion"),
                                message: Text("The resume will be delete."),
                                primaryButton: .destructive(Text("Confirm")) {
                                    delete(cdResume)
                                },
                                secondaryButton: .cancel()
                            )
                        }
                    } else {
                        Button(action: {
                            if (self.editMode?.wrappedValue == .inactive) {
                                isPresented.toggle()
                            }
                        }) {
                            HStack {
                                Text("Edit")
                                Image(systemName: "chevron.compact.right")
                            }
                        }
                    }
                    
                    Spacer()
                }
            }
        }
        .padding()
        
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(UIColor.systemBackground))
                .shadow(color: Color(UIColor.lightGray), radius: 2, x: 0, y: 0)
        )
        .fullScreenCover(isPresented: $isPresented) {
            ResumeEditor(cdResume: cdResume)
        }
    }
    
    private func delete(_ item: CDResume) {
        withAnimation {
            managedObjectContext.delete(item)
            save()
        }
    }
    
    private func copy(_ item: CDResume) {
        withAnimation {
            let newItem = CDResume(context: managedObjectContext)
            newItem.id = UUID()
            newItem.createdAt = Date()
            newItem.lastUpdate = Date()
            newItem.name = "\(item.name ?? "Resume") \(NSLocalizedString("(copy)", comment: ""))"
            newItem.createdAt = Date()
            newItem.content = Resume(cdResume).toData
            save()
        }
    }
    
    private func save(value: Bool = false){
        if value == false {
            PersistenceController.shared.save()
        }
    }
}

struct ResumeListItem_Previews: PreviewProvider {
    static var previews: some View {
        ResumeListItem(cdResume: CDResume(context: PersistenceController.preview.container.viewContext))
            .previewLayout(.fixed(width: 150, height: 212))
    }
}
