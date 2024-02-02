//
//  ColorSetView.swift
//  ResumeDesigner
//
//  Created by Julien Vanheule on 30/10/2021.
//

import SwiftUI

struct ColorSetView: View {
    var set: ColorSet
    
    var body: some View {
        HStack {
            ForEach([set.primaryColor, set.secondaryColor, set.textColor, set.skillColor], id:\.self) { color in
                Circle()
                    .strokeBorder(Color.black,lineWidth: 1)
                    .background(Circle().foregroundColor(Color(hex: color)))
            }
        }
        .padding(8)
        .background(Color(hex: set.backgroundColor))
        .frame(height: 50)
        .padding(5)
        
    }
}

struct ColorSetView_Previews: PreviewProvider {
    static var previews: some View {
        ColorSetView(set: ColorStore.shared.sets[0])
            .previewLayout(.sizeThatFits).frame(maxWidth: .infinity)
    }
}
