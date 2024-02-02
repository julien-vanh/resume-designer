//
//  ContactLineListItem.swift
//  ResumeDesigner
//
//  Created by Julien Vanheule on 30/09/2022.
//

import SwiftUI


struct ContactLineListItem: View {
    @Binding var line: ResumeContactLine
    var types: [ContactType] = [
        .birthday,
        .nationality,
        .car,
        .family,
        .website,
        
        .facebook,
        .git,
        .hangouts,
        .instagram,
        .linkedin,
        .medium,
        .msn,
        .skype,
        .telegram,
        .twitter,
        .whatsapp,
        .yahoo,
        .youtube
    ]
    
    var body: some View {
        VStack {
            HStack(spacing: 4) {
                Picker("", selection: $line.label) {
                    ForEach(types) { v in
                        Text(ContactType.labelFor(v)).font(.callout)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                #if !targetEnvironment(macCatalyst)
                .frame(width: 120, alignment: .leading).padding(0)
                #endif
                
                Divider()
                
                FormTextInput($line.value, placeholder: ContactType.placeholderFor(ContactType(rawValue: line.label) ?? .other), autocapitalization: .never)
            }
        }
        .padding(.vertical, 4)
        .frame(minHeight: 25)
    }
}

struct ContactLineListItem_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContactLineListItem(line: .constant(ResumeContactLine())).previewLayout(.fixed(width: 320, height: 50))
        }
    }
}
