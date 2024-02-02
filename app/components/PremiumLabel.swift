//
//  PremiumLabel.swift
//  ResumeDesigner
//
//  Created by Julien Vanheule on 17/08/2021.
//

import SwiftUI

struct PremiumLabel: View {
    var body: some View {
        Text("PRO").bold().font(.caption)
            .foregroundColor(.white)
            .padding(3)
            .background(Color("premium"))
            .cornerRadius(5)
    }
}

struct PremiumLabel_Previews: PreviewProvider {
    static var previews: some View {
        PremiumLabel()
    }
}
