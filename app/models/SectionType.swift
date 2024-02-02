//
//  SectionType.swift
//  ResumeDesigner
//
//  Created by Julien Vanheule on 21/10/2021.
//

import Foundation

enum SectionType: String, Codable, CaseIterable {
    case detailled
    case descriptionOnly
    case titleDescription
    case titleOnly
    case titleRate
    case language
    
    static func labelFor(_ option: SectionType) -> String {
        switch option {
        case .detailled:
            return NSLocalizedString("Detailled items", comment: "")
        case .descriptionOnly:
            return NSLocalizedString("Text", comment: "")
        case .language:
            return NSLocalizedString("Languages", comment: "")
        case .titleOnly:
            return NSLocalizedString("Items", comment: "")
        case .titleRate:
            return NSLocalizedString("Skills", comment: "")
        default:
            return NSLocalizedString("Items with description", comment: "")
        }
    }
    
    static func descriptionFor(_ option: SectionType) -> String {
        switch option {
        case .detailled:
            return NSLocalizedString("List of items with dates, description, company name and location.", comment: "")
        case .descriptionOnly:
            return NSLocalizedString("A simple text area", comment: "")
        case .language:
            return NSLocalizedString("A list of languages with level.", comment: "")
        case .titleOnly:
            return NSLocalizedString("A list of simple elements.", comment: "")
        case .titleRate:
            return NSLocalizedString("A list of skills with rating.", comment: "")
        default:
            return NSLocalizedString("A list of items with a paragraph description.", comment: "")
        }
    }
    
    static func systemImageFor(_ option: SectionType) -> String {
        switch option {
        case .detailled: return "rectangle.grid.1x2.fill"
        case .descriptionOnly: return "character.cursor.ibeam"
        case .titleDescription: return "list.dash"
        case .titleRate: return "star"
        case .language: return "flag"
        case .titleOnly: return "text.justify"
        }
    }
}
