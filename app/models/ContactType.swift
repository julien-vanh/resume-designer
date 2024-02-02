//
//  ContactType.swift
//  ResumeDesigner
//
//  Created by Julien Vanheule on 21/10/2021.
//

import Foundation

enum ContactType: String, Codable, CaseIterable, Identifiable {
    case address
    case phone
    case mail
    
    case birthday
    case nationality
    case car
    case family
    case website
    
    case facebook
    case git
    case hangouts
    case instagram
    case linkedin
    case medium
    case msn
    case skype
    case telegram
    case twitter
    case whatsapp
    case yahoo
    case youtube
    
    case other
    
    var id: String { self.rawValue }
    
    
    static func labelFor(_ option: ContactType) -> String {
        switch option {
        case .birthday: return NSLocalizedString("Birthday", comment: "")
        case .nationality: return NSLocalizedString("Nationality", comment: "")
        case .car: return NSLocalizedString("Mobility", comment: "")
        case .family: return NSLocalizedString("Family", comment: "")
        case .website: return NSLocalizedString("Website", comment: "")
            
        case .facebook: return NSLocalizedString("Facebook", comment: "")
        case .git: return NSLocalizedString("Git", comment: "")
        case .hangouts: return NSLocalizedString("Hangouts", comment: "")
        case .instagram: return NSLocalizedString("Instagram", comment: "")
        case .linkedin: return NSLocalizedString("Linkedin", comment: "")
        case .medium: return NSLocalizedString("Medium", comment: "")
        case .msn: return NSLocalizedString("MSN", comment: "")
        case .skype: return NSLocalizedString("Skype", comment: "")
        case .telegram: return NSLocalizedString("Telegram", comment: "")
        case .twitter: return NSLocalizedString("Twitter", comment: "")
        case .whatsapp: return NSLocalizedString("WhatsApp", comment: "")
        case .yahoo: return NSLocalizedString("Yahoo", comment: "")
        case .youtube: return NSLocalizedString("Youtube", comment: "")
        
        default: return NSLocalizedString("Other", comment: "")
        }
    }
    
    static func placeholderFor(_ option: ContactType) -> String {
        switch option {
        case .website: return NSLocalizedString("www.mywebsite.com", comment: "")
        case .linkedin: return "www.linkedin.com/in/<user>"
        default: return NSLocalizedString("Value", comment: "")
        }
    }
    
    static func svgFor(_ type: ContactType) -> String {
        do {
            if let url = Bundle.main.url(forResource: type.id, withExtension: "svg") {
                let contents = try String(contentsOf: url)
                return contents
            }
        } catch {
            print(error.localizedDescription)
        }
        return ""
    }
}
