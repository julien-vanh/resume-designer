//
//  ColorPicker.swift
//  ResumeDesigner (iOS)
//
//  Created by Julien Vanheule on 25/08/2021.
//

import SwiftUI

struct HexColorPicker: View {
    @Binding var value: String

    var body: some View {
        ColorPicker("", selection: binding(), supportsOpacity: false).frame(maxWidth: 80, minHeight: 25)
    }
    
    func binding() -> Binding<Color> {
        return Binding<Color>(
            get: {
                Color(hex: value)
            },
            set: {
                value = $0.toHex
            }
        )
    }
}

struct HexColorPicker_Previews: PreviewProvider {
    static var previews: some View {
        HexColorPicker(value: .constant("003366"))
            .previewLayout(.sizeThatFits)
            .frame(maxWidth: .infinity)
    }
}
