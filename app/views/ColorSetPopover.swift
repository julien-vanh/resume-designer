//
//  ColorsSetPopover.swift
//  ResumeDesigner
//
//  Created by Julien Vanheule on 30/10/2021.
//

import SwiftUI

struct ColorSetPopover: View {
    @Binding var style: ResumeStyle
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                ForEach(ColorStore.shared.sets, id:\.self) { colorSet in
                    Button(action: {
                        style.backgroundColor = colorSet.backgroundColor
                        style.primaryColor = colorSet.primaryColor
                        style.secondaryColor = colorSet.secondaryColor
                        style.titleColor = colorSet.textColor
                        style.contactColor = colorSet.textColor
                        style.sectionColor = colorSet.textColor
                        style.itemColor = colorSet.textColor
                        style.skillColor = colorSet.skillColor
                        dismiss()
                    }) {
                        ColorSetView(set: colorSet)
                    }
                    .buttonStyle(.plain)
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Predefined colors")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.accentColor)
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
}

struct ColorSetPopover_Previews: PreviewProvider {
    static var previews: some View {
        ColorSetPopover(style: .constant(ResumeStyle()))
    }
}
