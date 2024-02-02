//
//  SectionLine.swift
//  ResumeDesigner
//
//  Created by Julien Vanheule on 11/08/2021.
//

import SwiftUI

struct SectionLine: View {
    var section: ResumeSection
    var item: ResumeItem
    var offImage: Image?
    var onImage = Image(systemName: "star.fill")
    var offColor = Color.gray
    var onColor = Color.yellow
    
    var body: some View {
        if section.style == .detailled {
            HStack {
                VStack(alignment: .leading) {
                    Text(item.title)
                        .bold()
                        .lineLimit(1)
                    
                    if !item.company.isEmpty {
                        Text(item.company)
                            .lineLimit(1)
                            
                    }
                        
                    Text(item.formattedDate)
                        .font(.callout)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                if item.hidden {
                    Image(systemName: "eye.slash.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        else if section.style == .language {
            HStack {
                Text(item.title)
                    .bold()
                Spacer()
                Text(LanguageLevel.labelFor(LanguageLevel(rawValue: item.rate) ?? .native))
            }
        }
        else if section.style == .titleDescription {
            VStack(alignment: .leading) {
                Text(item.title)
                    .bold()
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)

                if !item.description.isEmpty {
                    Text(item.description)
                        .font(.callout)
                        .lineLimit(1)
                        .foregroundColor(.gray)
                }
            }
        }
        else if section.style == .titleOnly {
            Text(item.title)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        else if section.style == .descriptionOnly {
            Text(item.description)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        else if section.style == .titleRate {
            HStack {
                Text(item.title)
                Spacer()
                ForEach(1...5, id: \.self) { number in
                    self.image(for: number)
                        .foregroundColor(number > item.rate ? self.offColor : self.onColor)
                }
            }
        } else {
            EmptyView()
        }
    }
    
    func image(for number: Int) -> Image {
        if number > item.rate {
            return offImage ?? onImage
        } else {
            return onImage
        }
    }
}

struct SectionLine_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SectionLine(section: ResumeSection(title: "Experiences", style: .detailled), item: RandomGenerator.randomExperience(currentPosition: false))
                .previewLayout(.sizeThatFits).frame(maxWidth: .infinity)
            
            SectionLine(section: ResumeSection(title: "Languages", style: .language), item: RandomGenerator.randomLanguage())
                .previewLayout(.sizeThatFits).frame(maxWidth: .infinity)
            
            SectionLine(section: ResumeSection(title: "Hobbies", style: .titleDescription), item: RandomGenerator.randomHobby(withDescription: true))
                .previewLayout(.sizeThatFits).frame(maxWidth: .infinity)
            
            SectionLine(section: ResumeSection(title: "List", style: .titleOnly), item: RandomGenerator.randomHobby(withDescription: false))
                .previewLayout(.sizeThatFits).frame(maxWidth: .infinity)
            
            SectionLine(section: ResumeSection(title: "Skills", style: .titleRate), item: RandomGenerator.randomSkill())
                .previewLayout(.sizeThatFits).frame(maxWidth: .infinity)
        }
    }
}
