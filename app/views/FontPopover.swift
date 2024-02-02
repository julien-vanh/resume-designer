//
//  FontPopover.swift
//  ResumeDesigner
//
//  Created by Julien Vanheule on 12/10/2021.
//

import SwiftUI

struct FontPopover: View {
    @Binding var value: String
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            List {
                ForEach(FontType.allCases, id: \.self) { font in
                    Button(action: {
                        value = font.rawValue
                        isPresented = false
                    }) {
                        HStack {
                            Text(font.id)
                                .font(Font.custom(font.id, size: 20))
                            Spacer()
                            if value == font.rawValue {
                                Image(systemName: "checkmark").foregroundColor(.accentColor)
                                    .layoutPriority(1)
                            }
                        }
                        .padding(.horizontal, 6)
                    }
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Font")
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

struct FontPopover_Previews: PreviewProvider {
    static var previews: some View {
        FontPopover(value: .constant(FontType.allCases.first!.rawValue), isPresented: .constant(true))
    }
}
