//
//  ProgressionBar.swift
//  ResumeDesigner
//
//  Created by Julien Vanheule on 30/08/2021.
//

import SwiftUI

struct ProgressionBar: View {
    var value: Float
        
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle().frame(width: geometry.size.width , height: geometry.size.height)
                    .opacity(0.7)
                    .foregroundColor(.red)
                
                Rectangle().frame(width: min(CGFloat(self.value)*geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(.green)
                    .animation(.linear, value: value)
            }.cornerRadius(45.0)
        }
    }
    
    
}

struct ProgressionBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressionBar(value: 0.6)
            .previewLayout(.sizeThatFits).frame(maxWidth: .infinity)
    }
}
