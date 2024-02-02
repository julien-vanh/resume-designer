//
//  TextAlignmentType.swift
//  ResumeDesigner
//
//  Created by Julien Vanheule on 21/10/2021.
//

import Foundation

enum TextAlignmentType: String, Codable, CaseIterable, Identifiable {
    case left
    case center
    case right
    
    var id: String { self.rawValue }
    
    static func imageFor(_ option: TextAlignmentType) -> String {
        switch option {
        case .center:
            return "text.aligncenter"
        case .right:
            return "text.alignright"
        default:
            return "text.alignleft"
        }
    }
    
    static func cssFor(_ option: TextAlignmentType) -> String {
        switch option {
        case .center:
            return "text-align: center;"
        case .right:
            return "text-align: right;"
        default:
            return "text-align: left;"
        }
    }
}
