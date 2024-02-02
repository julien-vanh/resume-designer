//
//  SectionHeader.swift
//  ResumeDesigner
//
//  Created by Julien on 19/12/2021.
//

import SwiftUI

struct LabelSectionHeader: View {
    let label: String
    
    init(_ label: String){
        self.label = NSLocalizedString(label, comment: "")
    }
    
    var body: some View {
        SectionHeader {
            Text(label).font(.subheadline)
        }
    }
}

struct SectionHeader<Content: View>: View {
    let content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        content()
    }
}

struct SectionHeader_Previews: PreviewProvider {
    static var previews: some View {
        SectionHeader {
            Text("Header")
        }
    }
}
