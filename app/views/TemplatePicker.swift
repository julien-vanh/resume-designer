//
//  TemplatePicker.swift
//  ResumeDesigner
//
//  Created by Julien Vanheule on 13/09/2021.
//

import SwiftUI


struct TemplatePicker: View {
    @Binding var value: Int
    @Binding var isPresented: Bool
    var templateGroup: TemplateGroup
    
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: UIDevice.current.userInterfaceIdiom == .phone ? 1 : 2)
    
    var body: some View {
        NavigationView{
            ScrollView(){
                LazyVGrid(columns: columns) {
                    ForEach(templateGroup.templates) { template in
                        TemplateView(value: $value, isPresented: $isPresented, template: template, templateGroup: templateGroup)
                    }
                }.padding()
            }
            .navigationTitle(templateGroup.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                    .foregroundColor(.accentColor)
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
}

struct TemplatePicker_Previews: PreviewProvider {
    static var previews: some View {
        TemplatePicker(value: .constant(0), isPresented: .constant(true), templateGroup: TemplateStore.shared.titles)
    }
}

struct TemplateView: View {
    @Binding var value: Int
    @Binding var isPresented: Bool
    var template: Template
    var templateGroup: TemplateGroup
    @ObservedObject var appState = AppState.shared
    
    var body: some View {
        Button(action: {
            value = template.id
            isPresented = false
        }) {
            ZStack(alignment: .bottomTrailing) {
                ZStack {
                    Color.white
                    
                    Image("\(templateGroup.prefix)\(template.id)")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 80)
                        .clipped()
                }
                
                if !appState.isPremium && template.isPremium {
                    PremiumLabel()
                        .padding(5)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .overlay(
            Rectangle()
                .stroke(value == template.id ? Color.accentColor : Color.black, lineWidth: value == template.id ? 4 : 1)
        )
        
    }
}
