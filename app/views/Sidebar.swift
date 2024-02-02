//
//  Sidebar.swift
//  ResumeDesigner (iOS)
//
//  Created by Julien Vanheule on 21/09/2021.
//

import SwiftUI

struct Sidebar: View {
    @ObservedObject var resume: Resume
    
    @State private var showingStyle = (UIDevice.current.userInterfaceIdiom != .phone)
    @State private var displayNewSectionForm = false
    @State private var isEditingSection = false
    @State private var showingRandomContentConfirmation = false
    @ObservedObject var appState = AppState.shared
    
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                Completion(resume: resume)
                    .padding()
                    .opacity(isEditingSection ? 0.1 : 1)
                NavigationLink(
                    destination: StyleEditor(resume: resume),
                    isActive: $showingStyle){
                    HStack {
                        Image(systemName: "paintbrush.fill")
                        Text("Style / Export")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(showingStyle ? .white : Color("main"))
                    .padding(.vertical, 8)
                    .contentShape(Rectangle())
                    .background(showingStyle ? Color("main") : Color.clear)
                    .cornerRadius(16)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal)
                .padding(.bottom, 4)
                .disabled(isEditingSection)
            }
        
            ZStack(alignment: .bottom) {
                List {
                    Section(header: LabelSectionHeader("Information")) {
                        NavigationLink(destination: ProfileForm(contact: $resume.content.contact)){
                            HStack {
                                Image(systemName: "person")
                                    .font(.title2)
                                    .foregroundColor((!resume.content.contact.designation.isEmpty && !resume.content.contact.name.isEmpty) ? .green : .red)
                                Text("Professional profile")
                            }
                        }.disabled(isEditingSection)
                        
                        NavigationLink(destination: ContactForm(contact: $resume.content.contact, contactTitle: $resume.content.contact.sectionName)){
                            HStack {
                                Image(systemName: "text.bubble")
                                    .font(.title2)
                                    .foregroundColor(!resume.content.contact.phone.isEmpty ? .green : .red)
                                Text(!resume.content.contact.sectionName.isEmpty ? resume.content.contact.sectionName : "Contact")
                            }
                        }.disabled(isEditingSection)
                    }
                    
                    Section(header: SectionHeader {
                        EditSectionsHeader(isEditing: $isEditingSection)
                    }) {
                        ForEach(resume.content.sections.indices, id:\.self) { index in
                            NavigationLink(destination: SectionForm(section: binding(for:index))){
                                SectionListRow(section: resume.content.sections[index])
                            }
                        }
                        .onMove(perform: move)
                        .onDelete(perform: delete)
                        
                        Button(action: {
                            displayNewSectionForm.toggle()
                        }, label: {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("Add a section")
                                Spacer()
                            }.foregroundColor(.accentColor)
                        }).disabled(isEditingSection)
                    }
                    
                    Section(header: VStack {
                        Button(action: {
                            showingRandomContentConfirmation = true
                        }, label: {
                            HStack {
                                Image(systemName: "shuffle").foregroundColor(.accentColor)
                                Text("Random content")
                                Spacer()
                            }
                        })
                        .buttonStyle(PlainButtonStyle())
                        .disabled(isEditingSection)
                        .opacity(isEditingSection ? 0.1 : 1)
                        .alert(isPresented:$showingRandomContentConfirmation) {
                            Alert(
                                title: Text("Use random content"),
                                message: Text("The current content will be COMPLETELY DELETED and will be replaced."),
                                primaryButton: .destructive(Text("Confirm")) {
                                    RandomGenerator.randomizeContent(&resume.content)
                                },
                                secondaryButton: .cancel()
                            )
                        }
                    }, footer: Rectangle().opacity(0).frame(height: 150)) {
                        
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .environment(\.editMode, .constant(self.isEditingSection ? EditMode.active : EditMode.inactive))
            
                if resume.containsPremiumAsset && !appState.isPremium {
                    SidebarPremiumBanner(resume: resume)
                        .transition(.move(edge: .bottom))
                }
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .sheet(isPresented: $displayNewSectionForm, content: {
            NewSectionPopover() { newSection in
                resume.content.sections.append(newSection)
            }
        })
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func binding(for index: Int) -> Binding<ResumeSection> {
        Binding<ResumeSection>(
            get: {
                if index > resume.content.sections.count - 1{
                    return ResumeSection(title: "New section", style: .detailled)
                }
                return resume.content.sections[index]
            },
            set: {
                if index > resume.content.sections.count - 1 {
                    // do nothing
                } else {
                    resume.content.sections[index] = $0
                }
            }
        )
    }
    
    func move(from source: IndexSet, to destination: Int) {
        resume.content.sections.move(fromOffsets: source, toOffset: destination)
    }
    
    func delete(at offsets: IndexSet) {
        resume.content.sections.remove(atOffsets: offsets)
    }
}

struct Sidebar_Previews: PreviewProvider {
    static var previews: some View {
        Sidebar(resume: RandomGenerator.randomResume())
            .preferredColorScheme(.dark)
            .previewLayout(.fixed(width: /*@START_MENU_TOKEN@*/300.0/*@END_MENU_TOKEN@*/, height: 600))
            
    }
}

struct EditSectionsHeader: View {
    @Binding var isEditing: Bool
                        
    var body: some View {
        HStack {
            Text("Sections")
            Spacer()
            Button(action: {self.isEditing.toggle()}){
                Text(isEditing ? "Done" : "Edit")
                    .padding(4)
                    .padding(.horizontal, 8)
            }
            .buttonStyle(PlainButtonStyle())
            .foregroundColor(isEditing ? .white : .accentColor)
            .background(Color.accentColor.opacity(isEditing ? 1 : 0))
            .cornerRadius(50)
        }
    }
}
