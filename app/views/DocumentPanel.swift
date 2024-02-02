//
//  DocumentPanel.swift
//  ResumeDesigner
//
//  Created by Julien Vanheule on 03/09/2021.
//

import SwiftUI

struct DocumentPanel: View {
    @Binding var style: ResumeStyle
    @State private var showingFontSheet = false
    
    var body: some View {
        List {
            DocumentPanelGroup("Font") {
                DocumentPanelLine("Family") {
                    Button(action: {
                        showingFontSheet.toggle()
                    }){
                        Text("\(style.font)")
                            .bold()
                            .foregroundColor(.accentColor)
                            .padding(.vertical, 8)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                DocumentPanelLine("Size") {
                    Stepper("", value: $style.fontSize, in: 4...20, step: 1)
                }
            }
            
            DocumentPanelGroup("Document") {
                DocumentPanelLine("Inset") {
                    Stepper("", value: $style.inset, in: 0...80, step: 2)
                }
            }
            
            DocumentPanelGroup("Photo") {
                DocumentPanelLine("Frame") {
                    Picker("", selection: $style.photoStyle.frame) {
                        ForEach(PhotoFrame.allCases) { v in
                            Text(PhotoFrame.labelFor(v))
                                .bold()
                                .foregroundColor(.accentColor)
                                .padding(.vertical, 8)
                                .tag(v.rawValue)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                if style.photoStyle.shouldDisplayColor1 {
                    DocumentPanelLine("Color 1") {
                        HexColorPicker(value: $style.photoStyle.color1)
                    }
                }
                
                if style.photoStyle.shouldDisplayColor2 {
                    DocumentPanelLine("Color 2") {
                        HexColorPicker(value: $style.photoStyle.color2)
                    }
                }
                
                DocumentPanelLine("Shape") {
                    Picker(selection: $style.photoStyle.shape, label: EmptyView(), content: {
                        ForEach(PhotoShape.allCases) { v in
                            Image(systemName: PhotoShape.imageFor(v))
                                .tag(v.rawValue)
                        }
                    })
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(maxWidth: 200)
                }
            }
            
            DocumentPanelGroup("Photo Size") {
                DocumentPanelLine("Width") {
                    Stepper("", value: $style.photoStyle.width, in: 0...200, step: 10)
                }
                
                if style.photoStyle.shouldDisplayHeight {
                    DocumentPanelLine("Height") {
                        Stepper("", value: $style.photoStyle.height, in: 0...200, step: 10)
                    }
                }
                
                
            }
            
            DocumentPanelGroup("Skills") {
                DocumentPanelLine("Style") {
                    Picker("", selection: $style.skillStyle) {
                        ForEach(ResumeSKillStyle.allCases, id: \.self) { style in
                            Text(ResumeSKillStyle.labelFor(style))
                                .bold()
                                .foregroundColor(.accentColor)
                                .padding(.vertical, 8)
                                .tag(style.rawValue)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
            }
        }
        .listStyle(PlainListStyle())
        .sheet(isPresented: $showingFontSheet) {
            FontPopover(value: $style.font, isPresented: $showingFontSheet)
        }
    }
}

struct DocumentPanel_Previews: PreviewProvider {
    static var previews: some View {
        DocumentPanel(style: .constant(ResumeStyle()))
    }
}
