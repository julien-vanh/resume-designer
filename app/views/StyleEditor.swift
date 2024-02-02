//
//  StyleEditor.swift
//  ResumeDesigner
//
//  Created by Julien Vanheule on 13/08/2021.
//

import SwiftUI
import LoremSwiftum



struct StyleEditor: View {
    @ObservedObject var resume: Resume
    @ObservedObject var appState = AppState.shared
    @State var showingShare = false
    @State private var showingProAlert = false
    @State private var showingStyle = true
    @StateObject private var sharingObject = SharingObject()
    
    var body: some View {
        GeometryReader { geometry in
            if geometry.size.width > 600 {
                HStack(spacing: 0) {
                    if showingStyle {
                        StylePanel(style: $resume.content.style)
                            .frame(width: 300)
                            .transition(.move(edge: .leading))
                    }
                    PDFPreview(resume: resume)
                }
            } else {
                VStack(spacing: 0) {
                    PDFPreview(resume: resume)
                    if showingStyle {
                        StylePanel(style: $resume.content.style)
                            .frame(height: 300)
                            .transition(.move(edge: .bottom))
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .sheet(isPresented: self.$sharingObject.displayPopup, content: {
            ActivityViewController(activityItems: self.sharingObject.sharedItems, excludedActivityTypes: self.sharingObject.excludedActivityTypes)
        })
        .alert("You are using PRO feature, looks amazing!", isPresented: $showingProAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Back to free", role: .destructive) { resume.backToFree() }
            Button("Unlock PRO") { appState.displayPurchasePage = true }
        }
        .navigationTitle("Style").navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: UIDevice.current.userInterfaceIdiom == .phone ? .navigationBarTrailing : .navigationBarLeading) {
                Button(action: {
                    withAnimation(.easeIn(duration: 0.25)) {
                        self.showingStyle.toggle()
                    }
                }){
                    Image(systemName: showingStyle ? "arrow.up.left.and.arrow.down.right" : "paintbrush")
                        .foregroundColor(.accentColor)
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                
                #if targetEnvironment(macCatalyst)
                Menu("Save as...") {
                    Button(appState.isPremium ? "HTML" : "HTML (PRO)", action: saveHTMLFile)
                    Button("PDF", action: savePDFFile)
                }
                .menuStyle(BorderlessButtonMenuStyle())
                #endif
                
                Button (action: {
                    if !appState.isPremium && resume.containsPremiumAsset {
                        showingProAlert = true
                        return
                    }
                    
                    let excludedActivities: [UIActivity.ActivityType] = [.assignToContact, .openInIBooks]
                    PDFBuilder.shared.exportPDF(html: resume.html, style: resume.content.style) { result in
                        switch result {
                        case let .success(pdf):
                            let url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("\(resume.filename).pdf")
                            pdf.write(to: url)
                            let sharedItems = [url]
                            if UIDevice.current.userInterfaceIdiom == .phone {
                                //For iPhone present a modal sheet
                                sharingObject.sharedItems = sharedItems
                                sharingObject.excludedActivityTypes = excludedActivities
                                sharingObject.displayPopup = true
                            } else {
                                //For iPad and Mac, present a popover
                                share(items: sharedItems, excludedActivityTypes: excludedActivities)
                            }
                        case let .failure(error):
                            print("generateSharedItems error", error)
                        }
                    }
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.accentColor)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
    
    @discardableResult
    func share(items: [Any], excludedActivityTypes: [UIActivity.ActivityType]? = nil) -> Bool {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let source = windowScene.windows.last?.rootViewController else {
            return false
        }
        let vc = UIActivityViewController(activityItems: items, applicationActivities: nil)
        vc.excludedActivityTypes = excludedActivityTypes
        vc.popoverPresentationController?.sourceView = source.view
        vc.popoverPresentationController?.sourceRect = CGRect(x: source.view.frame.origin.x + source.view.frame.size.width, y: source.view.frame.origin.y + 80, width: 0, height: 0)
        vc.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up

        source.present(vc, animated: true)
        return true
    }
    
    func savePDFFile() {
        if !appState.isPremium && resume.containsPremiumAsset {
            showingProAlert = true
            return
        }
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let source = windowScene.windows.last?.rootViewController else {
            return
        }
        
        PDFBuilder.shared.exportPDF(html: resume.html, style: resume.content.style) { result in
            switch result {
            case let .success(pdf):
                let url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("\(resume.filename).pdf")
                pdf.write(to: url)
                
                let vc = UIDocumentPickerViewController(forExporting: [url])
                vc.shouldShowFileExtensions = true
                vc.allowsMultipleSelection = false
                source.present(vc, animated: true)
            case let .failure(error):
                print("generateSharedItems error", error)
            }
        }
    }
    
    func saveHTMLFile() {
        if !appState.isPremium {
            appState.displayPurchasePage = true
            return
        }
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let source = windowScene.windows.last?.rootViewController else {
            return
        }
        let url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("\(resume.filename).html")
        do {
            try resume.html.write(to: url, atomically: true, encoding: String.Encoding.utf16)
            
            let vc = UIDocumentPickerViewController(forExporting: [url])
            vc.shouldShowFileExtensions = true
            vc.allowsMultipleSelection = false
            source.present(vc, animated: true)
        } catch {
            print("write HTML error", error)
        }
    }

}

struct StyleEditor_Previews: PreviewProvider {
    static var previews: some View {
        StyleEditor(resume: RandomGenerator.randomResume())
    }
}
