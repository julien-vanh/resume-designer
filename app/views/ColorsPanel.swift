//
//  ColorsPanel.swift
//  ResumeDesigner
//
//  Created by Julien Vanheule on 28/10/2021.
//

import SwiftUI

struct ColorsPanel: View {
    @Binding var style: ResumeStyle
    @State private var showingColorSetPicker = false
    @ObservedObject var appState = AppState.shared
    
    var body: some View {
        List {
            DocumentPanelGroup("Predefined colors") {
                Button(action: {
                    showingColorSetPicker = true
                }){
                    ColorSetView(set: ColorSet(backgroundColor: style.backgroundColor, primaryColor: style.primaryColor, secondaryColor: style.secondaryColor, textColor: style.sectionColor, skillColor: style.skillColor))
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            ZStack(alignment: .topTrailing) {
                DocumentPanelGroup("Document colors") {
                    DocumentPanelLine("Theme") {
                        HexColorPicker(value: $style.primaryColor)
                    }
                    DocumentPanelLine("Secondary") {
                        HexColorPicker(value: $style.secondaryColor)
                    }
                    DocumentPanelLine("Background") {
                        HexColorPicker(value: $style.backgroundColor)
                    }
                }
                .disabled(!appState.isPremium)
                .opacity(!appState.isPremium ? 0.5 : 1)
                
                if !appState.isPremium {
                    Button(action: {
                        appState.displayPurchasePage = true
                    }) {
                        PremiumLabel()
                    }
                    .buttonStyle(.plain)
                }
            }
            
            ZStack(alignment: .topTrailing) {
                DocumentPanelGroup("Text colors") {
                    DocumentPanelLine("Headline") {
                        HexColorPicker(value: $style.titleColor)
                    }
                    DocumentPanelLine("Contact color") {
                        HexColorPicker(value: $style.contactColor)
                    }
                    DocumentPanelLine("Sections") {
                        HexColorPicker(value: $style.sectionColor)
                    }
                    DocumentPanelLine("Items") {
                        HexColorPicker(value: $style.itemColor)
                    }
                    DocumentPanelLine("Skills") {
                        HexColorPicker(value: $style.skillColor)
                    }
                }
                .disabled(!appState.isPremium)
                .opacity(!appState.isPremium ? 0.5 : 1)
                
                if !appState.isPremium {
                    Button(action: {
                        appState.displayPurchasePage = true
                    }) {
                        PremiumLabel()
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .listStyle(PlainListStyle())
        .sheet(isPresented: $showingColorSetPicker) {
            ColorSetPopover(style: $style)
        }
    }
}


struct ColorsPanel_Previews: PreviewProvider {
    static var previews: some View {
        ColorsPanel(style: .constant(ResumeStyle()))
    }
}
