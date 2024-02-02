//
//  SidebarDebugView.swift
//  ResumeDesigner
//
//  Created by Julien Vanheule on 23/10/2021.
//

import SwiftUI


struct SidebarDebugView: View {
    @Binding var resume: Resume
    
    var body: some View {
        VStack(alignment: .center, spacing: 15) {
            Button(action: {
                RandomGenerator.randomizeContent(&resume.content)
            }, label: {
                Text("Random Content")
            })
            .buttonStyle(PlainButtonStyle())
            
            Button(action: {
                RandomGenerator.randomizeStyle(&resume.content.style)
            }, label: {
                Text("Random Style")
            })
            .buttonStyle(PlainButtonStyle())
        }
    }
}
