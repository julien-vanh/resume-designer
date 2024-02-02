//
//  SectionListRow.swift
//  ResumeDesigner
//
//  Created by Julien Vanheule on 20/10/2021.
//

import SwiftUI

struct SectionListRow: View {
    var section: ResumeSection
    
    var body: some View {
        HStack {
            Image(systemName: SectionType.systemImageFor(section.style))
                .foregroundColor(section.items.count > 0 ? .green : .red)
            Text(section.title)
            Spacer()
            Text("\(section.items.count)").foregroundColor(.gray)
        }
    }
    
    
}

struct SectionListRow_Previews: PreviewProvider {
    static var previews: some View {
        SectionListRow(section: ResumeSection(title: "Section", style: .detailled))
    }
}
