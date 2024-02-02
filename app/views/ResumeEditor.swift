//
//  ResumeEditor.swift
//  ResumeDesigner (iOS)
//
//  Created by Julien Vanheule on 18/07/2021.
//

import SwiftUI

struct ResumeEditor: View {
    @ObservedObject var cdResume: CDResume
    @StateObject var resume: Resume
    @ObservedObject var appState: AppState = .shared
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var managedObjectContext
    
    init(cdResume: CDResume) {
        self.cdResume = cdResume
        self._resume = StateObject(wrappedValue: Resume(cdResume))
    }
    
    var body: some View {
        NavigationView {
            Sidebar(resume: resume)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            resume.subject.send(completion: .finished)
                            self.cdResume.content = resume.toData
                            PersistenceController.shared.save()
                            dismiss()
                        }){
                            Image(systemName: "folder")
                                .foregroundColor(.accentColor)
                        }
                    }
                }
            NothingView()
        }
        .onChange(of: resume.content) { _ in
            resume.subject.send(Date())
        }
        .navigationViewStyle(DoubleColumnNavigationViewStyle())
        .sheet(isPresented: $appState.displayPurchasePage){
            PurchasePage()
                .interactiveDismissDisabled(true)
        }
        .navigationBarHidden(true)
    }
}
