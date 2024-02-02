//
//  TitleRateForm.swift
//  ResumeDesigner
//
//  Created by Julien Vanheule on 11/08/2021.
//

import SwiftUI

struct TitleRateForm: View {
    @Binding var item: ResumeItem
    
    
    var offImage: Image?
    var onImage = Image(systemName: "star.fill")
    var offColor = Color.gray
    var onColor = Color.yellow
    
    var body: some View {
        Form {
            Section(header: LabelSectionHeader("Skill")) {
                TextField("", text: $item.title)
            }
            
            Section(header: LabelSectionHeader("Rate")) {
                HStack {
                    ForEach(1...5, id: \.self) { number in
                        self.image(for: number)
                            .foregroundColor(number > item.rate ? self.offColor : self.onColor)
                            .onTapGesture {
                                item.rate = number
                            }
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
    
    func image(for number: Int) -> Image {
        if number > item.rate {
            return offImage ?? onImage
        } else {
            return onImage
        }
    }
}

struct TitleRateForm_Previews: PreviewProvider {
    static var previews: some View {
        TitleRateForm(item: .constant(RandomGenerator.randomSkill()))
    }
}
