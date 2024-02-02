//
//  ItemForm.swift
//  ResumeDesigner
//
//  Created by Julien Vanheule on 30/07/2021.
//

import SwiftUI

struct DetailledForm: View {
    @Binding var item: ResumeItem
    var isEducationsection: Bool
    
    var body: some View {
        Form {
            Section() {
                IconTextField(label: "Title", imageName: "briefcase", text: $item.title)
                IconTextField(label: isEducationsection ? "School" : "Company name", imageName: "building.2", text: $item.company)
                IconTextField(label: "Location", imageName: "globe", text: $item.address)
            }
            
            Section() {
                IconField(imageName: "pin") {
                    Toggle(isEducationsection ? "I am currently studying" : "I am currently working in this role", isOn: $item.currentPosition)
                }
                IconField(imageName: "calendar") {
                    DatePicker("Start date", selection: $item.startDate, displayedComponents: [.date])
                }
                if !item.currentPosition {
                    IconField(imageName: "calendar") {
                        DatePicker("End date", selection: $item.endDate, displayedComponents: [.date])
                    }
                }
            }
            
            Section() {
                TextArea("Description", text: $item.description).frame(height: 300)
            }
            
            Section() {
                IconField(imageName: "eye.slash") {
                    Toggle("Hidden", isOn: $item.hidden)
                }
            }
        }
    }
}

struct ExperienceForm_Previews: PreviewProvider {
    static var previews: some View {
        DetailledForm(item: .constant(RandomGenerator.randomExperience()), isEducationsection: Bool.random())
    }
}
