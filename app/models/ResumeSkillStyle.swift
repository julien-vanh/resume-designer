//
//  ResumeSkillStyle.swift
//  ResumeDesigner
//
//  Created by Julien Vanheule on 26/09/2022.
//

import Foundation

enum ResumeSKillStyle: String, Codable, CaseIterable {
    case empty
    case text
    case stars
    case bar1
    case bar2
    
    static func labelFor(_ option: ResumeSKillStyle) -> String {
        switch option {
        case .text:
            return NSLocalizedString("Label", comment: "")
        case .stars:
            return NSLocalizedString("Stars", comment: "")
        case .bar1:
            return NSLocalizedString("Bar 1", comment: "")
        case .bar2:
            return NSLocalizedString("Bar 2", comment: "")
        default:
            return NSLocalizedString("Empty", comment: "")
        }
    }
}
