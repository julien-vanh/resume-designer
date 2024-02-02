//
//  StylePanel.swift
//  ResumeDesigner
//
//  Created by Julien Vanheule on 13/08/2021.
//

import SwiftUI

struct StylePanel: View {
    @State private var styleTab: Int = 0
    @Binding var style: ResumeStyle
    @ObservedObject var appState = AppState.shared
    
    var body: some View {
        
        VStack(spacing: 0) {
            Picker(selection: $styleTab, label: EmptyView(), content: {
                Text("Layout").tag(0)
                Text("Template").tag(1)
                Text("Colors").tag(2)
                Text("Misc").tag(3)
            })
            .pickerStyle(SegmentedPickerStyle())
            .padding(.vertical, 8)
            .padding(.horizontal)
            
            if styleTab == 0 {
                LayoutPanel(style: $style)
            } else if styleTab == 1 {
                TemplatePanel(style: $style)
            } else if styleTab == 2 {
                ColorsPanel(style: $style)
            } else {
                DocumentPanel(style: $style)
            }
        }
    }
}

struct StylePanel_Previews: PreviewProvider {
    static var previews: some View {
        StylePanel(style: .constant(RandomGenerator.randomResumeContent().style))
    }
}
