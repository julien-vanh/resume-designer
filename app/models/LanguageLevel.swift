//
//  LanguageLevel.swift
//  ResumeDesigner
//
//  Created by Julien Vanheule on 26/09/2022.
//

import Foundation

enum LanguageLevel: Int, Codable  {
    case a1
    case a2
    case b1
    case b2
    case c1
    case c2
    case native
    
    static func labelFor(_ option: LanguageLevel) -> String {
        switch option {
        case .a1:
            return NSLocalizedString("Beginner", comment: "")
        case .a2:
            return NSLocalizedString("Elementary", comment: "")
        case .b1:
            return NSLocalizedString("Intermediate", comment: "")
        case .b2:
            return NSLocalizedString("Upper Intermediate", comment: "")
        case .c1:
            return NSLocalizedString("Advanced", comment: "")
        case .c2:
            return NSLocalizedString("Proficient", comment: "")
        default:
            return NSLocalizedString("Native", comment: "")
        }
    }
}
