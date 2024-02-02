//
//  BorderType.swift
//  ResumeDesigner
//
//  Created by Julien Vanheule on 17/08/2021.
//

import Foundation


enum PhotoFrame: String, CaseIterable, Identifiable {
    case none, simple, contrasted, double, bicolor
    
    var id: String { self.rawValue }
    var isMulticolor: Bool { self == .double || self == .bicolor }
    
    static func labelFor(_ option: PhotoFrame) -> String {
        switch option {
            case .none: return NSLocalizedString("None", comment: "")
            case .simple: return NSLocalizedString("Simple", comment: "")
            case .contrasted: return NSLocalizedString("Contrasted", comment: "")
            case .double: return NSLocalizedString("Double", comment: "")
            case .bicolor: return NSLocalizedString("Two tones", comment: "")
        }
    }
}


enum PhotoShape: String, CaseIterable, Identifiable {
    case square, rounded, circle
    
    var id: String { self.rawValue }
    
    static func labelFor(_ option: PhotoShape) -> String {
        switch option {
            case .square: return NSLocalizedString("Square", comment: "")
            case .rounded: return NSLocalizedString("Rounded", comment: "")
            case .circle: return NSLocalizedString("Circle", comment: "")
        }
    }
    
    static func imageFor(_ option: PhotoShape) -> String {
        switch option {
            case .square: return "squareshape.fill"
            case .rounded: return "square.fill"
            case .circle: return "circle.fill"
        }
    }
}
