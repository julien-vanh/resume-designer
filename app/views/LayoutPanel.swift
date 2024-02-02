//
//  LayoutPicker.swift
//  ResumeDesigner (iOS)
//
//  Created by Julien Vanheule on 17/08/2021.
//

import SwiftUI

struct LayoutPanel: View {
    @Binding var style: ResumeStyle
    
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
    var body: some View {
        ScrollView(){
            LazyVGrid(columns: columns) {
                ForEach(TemplateStore.shared.layouts) { layout in
                    LayoutView(value: $style.layout, layout: layout)
                }
            }
            .padding(8)
        }
    }
}

struct LayoutPicker_Previews: PreviewProvider {
    static var previews: some View {
        LayoutPanel(style: .constant(ResumeStyle()))
    }
}

struct LayoutView: View {
    @Binding var value: Int
    var layout: Layout
    @ObservedObject var appState = AppState.shared
    let width: CGFloat = 90
    let ratio: CGFloat = 297/210
    
    var body: some View {
        Button(action: {
            value = layout.id
        }) {
            ZStack(alignment: .bottomTrailing) {
                Image("layout-\(layout.id)")
                    .resizable()
                    .scaledToFit()
                    .frame(width: width, height: width*ratio)
                    .clipped()
                
                if !appState.isPremium && layout.isPremium {
                    PremiumLabel()
                        .padding(5)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .overlay(
            Rectangle()
                .stroke(value == layout.id ? Color.accentColor : Color.black,
                        lineWidth: value == layout.id ? 4 : 1)
        )
        .padding(8)
    }
}
