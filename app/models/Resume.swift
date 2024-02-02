//
//  Resume.swift
//  ResumeDesigner
//
//  Created by Julien Vanheule on 18/07/2021.
//

import SwiftUI
import Contacts
import Combine

let MAX_FREE_SECTIONS_COUNT = 5

class Resume: ObservableObject, Equatable {
    var cdResume: CDResume
    @Published var content: ResumeContent
    let subject = PassthroughSubject<Date, Never>()
    var cancellable = [AnyCancellable]()
    
    init(_ cdResume: CDResume) {
        self.cdResume = cdResume
        if let content = cdResume.content {
            do {
                self.content = try JSONDecoder().decode(ResumeContent.self, from: content)
            } catch {
                print("Cannot read file", error.localizedDescription)
                self.content = ResumeContent()
            }
        } else {
            print("Pas de contenu")
            self.content = ResumeContent() 
        }
        
        subject.debounce(for: .seconds(5), scheduler: RunLoop.main).sink { date in
            self.cdResume.lastUpdate = date
            self.cdResume.content = self.toData
            PersistenceController.shared.save()
        }.store(in: &cancellable)
    }
    
    var filename: String {
        var name = self.cdResume.name ?? ""
        if name.isEmpty {
            name = NSLocalizedString("filename", comment: "")
        }
        name = name.replacingOccurrences(of: " ", with: "-")
        name = name.components(separatedBy: .init(charactersIn: "/\\?%*|\"<>")).joined()
        return name
    }
    
    var toData: Data {
        return try! JSONEncoder().encode(content)
    }

    func randomize(){
        content = RandomGenerator.randomResumeContent();
    }
    
    var html: String {
        return ResumeGenerator.shared.getHTML(resume: content)
    }
    
    var containsPremiumAsset: Bool {
        let store = TemplateStore.shared
        let layoutIsPremium = store.layoutAtIndex(content.style.layout).isPremium
        let titleIsPremium = store.titles.templateAtIndex(content.style.titleTemplate).isPremium
        let contactIsPremium = store.contacts.templateAtIndex(content.style.contactTemplate).isPremium
        let sectionIsPremium = store.sections.templateAtIndex(content.style.sectionTemplate).isPremium
        let itemIsPremium = store.items.templateAtIndex(content.style.itemTemplate).isPremium
        let hasAdditionalSection = content.sections.count > MAX_FREE_SECTIONS_COUNT
        return layoutIsPremium || titleIsPremium || contactIsPremium || sectionIsPremium || itemIsPremium || hasAdditionalSection
    }
    func backToFree() {
        let store = TemplateStore.shared
        if store.layoutAtIndex(content.style.layout).isPremium {
            content.style.layout = 0
        }
        if store.titles.templateAtIndex(content.style.titleTemplate).isPremium {
            content.style.titleTemplate = 0
        }
        if store.contacts.templateAtIndex(content.style.contactTemplate).isPremium {
            content.style.contactTemplate = 0
        }
        if store.sections.templateAtIndex(content.style.sectionTemplate).isPremium {
            content.style.sectionTemplate = 0
        }
        if store.items.templateAtIndex(content.style.itemTemplate).isPremium {
            content.style.itemTemplate = 0
        }
        content.sections = Array(content.sections[..<MAX_FREE_SECTIONS_COUNT])
    }
    
    static func == (lhs: Resume, rhs: Resume) -> Bool {
        return lhs.content == rhs.content
    }
}

struct ResumeContent: Codable, Equatable {
    var contact = ResumeContact()
    var sections: [ResumeSection]
    var style = ResumeStyle()
    
    init(){
        sections = [
            ResumeSection(title: NSLocalizedString("Experiences", comment: ""), style: .detailled),
            ResumeSection(title: NSLocalizedString("Education", comment:""), style: .detailled),
            ResumeSection(title: NSLocalizedString("Skills", comment:""), style: .titleRate),
            ResumeSection(title: NSLocalizedString("Languages", comment:""), style: .language),
            ResumeSection(title: NSLocalizedString("Hobbies", comment:""), style: .titleOnly)
        ]
    }
}

struct ResumeContact: Codable, Equatable {
    var sectionName: String = NSLocalizedString("Contact", comment:"")
 
    var photo: String = ""
    var name: String = ""
    var designation: String = ""
    
    var phone: String = ""
    var email: String = ""
    
    var street: String = ""
    var city: String = ""
    var state: String = ""
    var postalCode: String = ""
    var country: String = ""
    
    var lines: [ResumeContactLine] = []
    
    var formattedAddress: String {
        let address = CNMutablePostalAddress()
        address.city = city.safeString()
        address.postalCode = postalCode.safeString()
        address.street = street.safeString()
        address.state = state.safeString()
        address.country = country.safeString()
        
        let formatter = CNPostalAddressFormatter()
        return formatter.string(from: address)
    }
}

struct ResumeContactLine: Codable, Equatable, Hashable, Identifiable {
    var id : UUID = UUID()
    var label: String = ContactType.other.id
    var value: String = ""
}


struct ResumeSection: Codable, Hashable, Identifiable, Equatable {
    var id : UUID = UUID()
    var title: String
    var items: [ResumeItem]
    var style: SectionType
    
    init(title: String, style: SectionType){
        self.title = title
        items = []
        self.style = style
    }
}


struct ResumeItem: Codable, Hashable, Identifiable, Equatable {
    var id : UUID = UUID()
    var title: String = ""
    var description: String = ""
    var rate: Int = 1
    
    var company: String = ""
    var address: String = ""
    
    var startDate: Date = Date()
    var endDate: Date = Date()
    var currentPosition: Bool = false
    
    var hidden: Bool = false
    
    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        
        if currentPosition {
            let current = NSLocalizedString("Present", comment: "")
            return "\(dateFormatter.string(from: startDate)) - \(current)"
        } else {
            return "\(dateFormatter.string(from: startDate)) - \(dateFormatter.string(from: endDate))"
        }
    }
    
    static func skillDescriptionFor(_ rate: Int) -> String {
        switch rate {
        case 1:
            return NSLocalizedString("Junior", comment: "")
        case 2:
            return NSLocalizedString("Intermediate", comment: "")
        case 3:
            return NSLocalizedString("Confirmed", comment: "")
        case 4:
            return NSLocalizedString("Advanced", comment: "")
        case 5:
            return NSLocalizedString("Expert", comment: "")
        default:
            return NSLocalizedString("", comment: "")
        }
    }
}


struct ResumeStyle: Codable, Equatable {
    var primaryColor: String = "CFE5E8"
    var secondaryColor: String = "E0F8FF"
    var backgroundColor: String = "FFFFFF"
    
    var titleColor: String = "32CAE0"
    var contactColor: String = "32CAE0"
    var sectionColor: String = "32CAE0"
    var itemColor: String = "32CAE0"
    var skillColor: String = "32CAE0"
    
    var font: String = FontType.arial.id
    var fontSize: Int = 10
    var inset: Int = 30
    var skillStyle: String = ResumeSKillStyle.bar1.rawValue
    
    var photoStyle: PhotoStyle = PhotoStyle()
    var layout: Int = (TemplateStore.shared.layouts.first(where: {!$0.isPremium}))!.id
    
    var titleTemplate: Int = (TemplateStore.shared.titles.templates.first(where: {!$0.isPremium}))!.id
    var titleAlignment: String = TextAlignmentType.left.rawValue
    var sectionTemplate: Int = (TemplateStore.shared.sections.templates.first(where: {!$0.isPremium}))!.id
    var itemTemplate: Int = (TemplateStore.shared.items.templates.first(where: {!$0.isPremium}))!.id
    var contactTemplate: Int = (TemplateStore.shared.contacts.templates.first(where: {!$0.isPremium}))!.id
}


struct PhotoStyle: Codable, Equatable {
    var shape: String = PhotoShape.square.rawValue
    var width: Int = 70
    var height: Int = 70
    var frame: String = PhotoFrame.none.rawValue
    var color1: String = "000000"
    var color2: String = "FFFFFF"
    
    var shouldDisplayHeight: Bool {
        let shapeType = PhotoShape(rawValue: self.shape) ?? .square
        return shapeType != .circle
    }
        
    var shouldDisplayColor1: Bool {
        let frameType = PhotoFrame(rawValue: self.frame) ?? .none
        return frameType != .none
    }
    
    var shouldDisplayColor2: Bool {
        let frameType = PhotoFrame(rawValue: self.frame) ?? .none
        return frameType.isMulticolor
    }
}
