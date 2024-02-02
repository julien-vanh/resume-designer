//
//  StyleHeadline.swift
//  ResumeDesigner
//
//  Created by Julien Vanheule on 24/09/2021.
//

import SwiftUI

struct DocumentPanelGroup<Content: View>: View {
    var title: String
    let content: () -> Content
    
    init(_ title: String, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.content = content
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(NSLocalizedString(title, comment:"").uppercased())
                .font(.subheadline)
                .bold()
                .foregroundColor(.gray)
            content()
        }
    }
}


struct DocumentPanelLine<Content: View>: View {
    var title: String
    let content: () -> Content
        
    init(_ title: String, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.content = content
    }
        
    var body: some View {
        HStack() {
            Text(NSLocalizedString(title, comment: ""))
                .frame(minWidth: 100, alignment: .leading)
            Spacer()
            content()
        }
        .frame(height: 30)
        .padding(.leading, 8)
        #if !targetEnvironment(macCatalyst)
        .padding(.vertical, 3)
        #endif
    }
}
