//
//  ContentView.swift
//  ResumeDesigner
//
//  Created by Julien on 13/03/2022.
//

import SwiftUI
import CoreData

struct ResumeList: View {
    @Environment(\.managedObjectContext) private var managedObjectContext
    @FetchRequest(
        sortDescriptors: [
            SortDescriptor(\.createdAt, order: .reverse)
        ]
    ) var resumes: FetchedResults<CDResume>
    @Environment(\.editMode) var editMode
    @State private var isPresented = false
    @State private var presentedResume = CDResume()
    @ObservedObject var appState = AppState.shared
    
    private var gridItemLayout = [GridItem(.adaptive(minimum: 250))]

    var body: some View {
        NavigationView(){
            ScrollView(.vertical) {
                GeometryReader { geometry in
                    ZStack {
                        ImageStore.shared.localImage(name: "resume.jpg")
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: self.getHeightForHeaderImage(geometry))
                        .clipped()
                        .offset(x: 0, y: self.getOffsetForHeaderImage(geometry))
                        .navigationBarTitle(self.getNavigationTitle(geometry))
                    }
                }.frame(height: 150)
                
                VStack(spacing: 15) {
                    VStack(alignment: .center, spacing: 5) {
                        Spacer()
                        Text("Resumes").font(.largeTitle)
                            .fontWeight(.semibold)
                            .shadow(color: Color.black, radius: 5, x: 0, y: 0)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .lineLimit(3)
                    }.frame(height: 100).padding(.top, -110)
                    
                    Button(action: addItem) {
                        HStack {
                            Image(systemName: "plus")
                            Text("New resume")
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.roundedRectangle)
                    .controlSize(.large)
                    .tint(.accentColor)
                    .disabled(editMode?.wrappedValue == .active)
                    
                    if resumes.count == 0 {
                        Text("Create your resume now.")
                            .foregroundColor(Color(UIColor.systemGray))
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding()
                    }
                    
                    LazyVGrid(columns: gridItemLayout, spacing: 20) {
                        ForEach(resumes, id:\.id) { resume in
                            ResumeListItem(cdResume: resume)
                                .environment(\.editMode, editMode)
                                .frame(minHeight: 140)
                        }
                    }.padding()
                    
                    Rectangle().opacity(0).frame(width: 80)
                }
                
                
            }
            .background(Rectangle().fill(Color(UIColor.systemGroupedBackground)))
            .fullScreenCover(isPresented: $isPresented) {
                ResumeEditor(cdResume: presentedResume)
            }
            
        }
        .sheet(isPresented: $appState.displayPurchasePage){
            PurchasePage()
                .interactiveDismissDisabled(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                EditButton()
            }
            ToolbarItemGroup(placement: .bottomBar) {
                if !appState.isPremium {
                    Button(action: {
                        self.appState.displayPurchasePage = true
                    }){
                        Text("PRO Version")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color("premium"))
                }
            }
        }
    }

    private func addItem() {
        let newItem = CDResume(context: managedObjectContext)
        newItem.id = UUID()
        newItem.createdAt = Date()
        newItem.lastUpdate = Date()
        newItem.name = NSLocalizedString("My resume", comment: "")
        newItem.createdAt = Date()
        newItem.content = Resume(newItem).toData
        
        presentedResume = newItem
        isPresented = true
    }
    
    private func getNavigationTitle(_ geometry: GeometryProxy) -> String {
        return getScrollOffset(geometry) < -50 ? NSLocalizedString("Resumes", comment: "") : ""
    }
    
    private func getScrollOffset(_ geometry: GeometryProxy) -> CGFloat {
        return geometry.frame(in: .global).minY
    }
    
    private func getOffsetForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = getScrollOffset(geometry)
        
        // Image was pulled down
        if offset > 0 {
            return -offset
        }
        return 0
    }
    
    private func getHeightForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = getScrollOffset(geometry)
        let imageHeight = geometry.size.height

        if offset > 0 {
            return imageHeight + offset
        }
        return imageHeight
    }
}


struct ResumeList_Previews: PreviewProvider {
    static var previews: some View {
        ResumeList().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
