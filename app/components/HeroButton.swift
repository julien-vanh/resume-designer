//
//  BigButton.swift
//  ResumeDesigner
//
//  Created by Julien Vanheule on 22/10/2021.
//
import SwiftUI


struct HeroButton : View {
    var label: String
    var action : SuccessBlock!

    var body: some View {
        VStack(alignment: .center){
            Button(action: {
                action()
            }){
                Text(NSLocalizedString(label, comment: ""))
                    .font(.headline)
                    .frame(maxWidth: 300,alignment: .center)
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle)
            .tint(.accentColor)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

struct BigButton_Previews: PreviewProvider {
    static var previews: some View {
        HeroButton(label: "Un big bouton", action: {
            print("click")
        })
    }
}
