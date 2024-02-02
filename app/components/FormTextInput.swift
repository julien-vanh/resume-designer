//
//  FormTextInputLine.swift
//  SignatureDesigner
//
//  Created by Julien Vanheule on 08/01/2021.
//

import SwiftUI

struct FormTextInput: View {
    @Binding var value: String
    var placeholder = ""
    var autocapitalization: TextInputAutocapitalization
    
    @State private var text: String
    let debouncer = Debouncer(timeInterval: 1)
    
    init(_ value: Binding<String>, placeholder: String = "", autocapitalization: TextInputAutocapitalization = .sentences) {
        self._value = value
        self.placeholder = placeholder
        self._text = State(initialValue: value.wrappedValue)
        self.autocapitalization = autocapitalization
    }
    
    var body: some View {
        TextField(NSLocalizedString(placeholder, comment: ""), text: $text)
            .textInputAutocapitalization(autocapitalization)
            .onChange(of: text) { v in
            debouncer.renewInterval()
            debouncer.handler = {
                value = v.trim()
            }
        }
    }
}

struct FormTextInputLine_Previews: PreviewProvider {
    static var previews: some View {
        FormTextInput(.constant("Jean Dupond"))
    }
}
