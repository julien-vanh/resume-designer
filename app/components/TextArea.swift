//
//  TextArea.swift
//  ResumeDesigner
//
//  Created by Julien Vanheule on 16/10/2021.
//

import SwiftUI

struct TextArea: View {
    private let placeholder: String
    @Binding var text: String
    
    init(_ placeholder: String, text: Binding<String>) {
        self.placeholder = placeholder
        self._text = text
    }
    
    var body: some View {
        TextEditor(text: $text)
            .background(
                VStack() {
                    HStack {
                        Text(text.isEmpty ? placeholder : "")
                            .padding(EdgeInsets(top: 8, leading: 4, bottom: 7, trailing: 0))
                        Spacer()
                    }
                    Spacer()
                }
                .foregroundColor(Color.primary.opacity(0.25))
            )
    }
}
