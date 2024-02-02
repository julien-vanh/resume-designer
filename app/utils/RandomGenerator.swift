//
//  Signature+Randomize.swift
//  SignatureDesigner
//
//  Created by Julien Vanheule on 13/03/2021.
//

import Foundation
import SwiftUI
import LoremSwiftum


class RandomGenerator {
    static func randomizeStyle(_ s: inout ResumeStyle){
        let colorSet = ColorStore.shared.sets.randomElement()!
        s.primaryColor = colorSet.primaryColor
        s.secondaryColor = colorSet.secondaryColor
        s.titleColor = colorSet.textColor
        s.contactColor = colorSet.textColor
        s.sectionColor = colorSet.textColor
        s.itemColor = colorSet.textColor
        s.skillColor = colorSet.skillColor
        s.backgroundColor = colorSet.backgroundColor
        s.fontSize = 8
        s.layout = TemplateStore.shared.layouts.randomElement()!.id
        s.titleTemplate = randomTemplate(TemplateStore.shared.titles)
        s.sectionTemplate = randomTemplate(TemplateStore.shared.sections)
        s.itemTemplate = randomTemplate(TemplateStore.shared.items)
        s.contactTemplate = randomTemplate(TemplateStore.shared.contacts)
        s.titleAlignment = TextAlignmentType.center.rawValue
    }
    
    static private func randomTemplate(_ group: TemplateGroup) -> Int {
        let templates = group.templates.filter { $0.randomable }
        return templates.randomElement()!.id
    }

    static private func randomThemeColor() -> String {
        return ["f94144", "f3722c","f8961e","f9844a","f9c74f","90be6d","277da1","ff006e", "b7094c", "00509d", "00bbf9"].randomElement()!
    }
    
    static private func randomTextColor() -> String {
        return ["000000", "111111","222222","333333","444444","555555","666666","777777"].randomElement()!
    }
    
    static func randomResume() -> Resume {
        let resume = Resume(CDResume())
        resume.content = self.randomResumeContent()
        return resume
    }
    
    static func randomResumeContent() -> ResumeContent {
        var content = ResumeContent()
        self.randomizeContent(&content)
        self.randomizeStyle(&content.style)
        return content
    }
    
    static func randomizeContent(_ s: inout ResumeContent){
        let contact = contacts.randomElement()!.split(separator: "|")
        let female = Bool.random()
        let name = "\(String(contact[female ? 1 : 0])) \(String(contact[2]))"
        
        s.contact = randomContact(contact, name: name)
        s.sections = [
            ResumeSection(title: NSLocalizedString("Profil", comment: ""), style: .descriptionOnly),
            ResumeSection(title: NSLocalizedString("Experiences", comment: ""), style: .detailled),
            ResumeSection(title: NSLocalizedString("education_section", comment: ""), style: .detailled),
            ResumeSection(title: NSLocalizedString("Skills", comment: ""), style: .titleRate),
            ResumeSection(title: NSLocalizedString("Languages", comment: ""), style: .language),
            ResumeSection(title: NSLocalizedString("Hobbies", comment: ""), style: .titleDescription)
        ]
        
        var profil = ResumeItem()
        profil.description = Lorem.paragraph
        s.sections[0].items.append(profil)
        
        //Experience 2-3
        for _ in 0...Int.random(in: 1...2) {
            s.sections[1].items.append(randomExperience())
        }
        s.sections[1].items.append(randomExperience(currentPosition: true))
        
        //Education 1-2
        if Bool.random() {
            s.sections[2].items.append(randomEducation())
        }
        s.sections[2].items.append(randomEducation(currentPosition: Bool.random()))
        
        //Skills
        for _ in 0...Int.random(in: 3...5) {
            s.sections[3].items.append(randomSkill())
        }
        
        //Language
        for _ in 0...Int.random(in: 1...2) {
            s.sections[4].items.append(randomLanguage())
        }
        
        //Hobbies
        let withDescription = Bool.random()
        for _ in 0...Int.random(in: 2...3) {
            s.sections[5].items.append(randomHobby(withDescription: withDescription))
        }
    }
    
    static func randomContact(_ contact: Array<Substring>, name: String) -> ResumeContact {
        
        var p = ResumeContact()
        p.name = name
        p.designation = jobtitles.randomElement()!
        p.photo = Bool.random() ? fakePortrait() : ""
        
        p.lines = []
        
        let date1 = Date.parse("1960-01-01")
        let date2 = Date.parse("2010-01-01")
        let randomDate = Date.randomBetween(start: date1, end: date2)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        var birthdateLine = ResumeContactLine()
        birthdateLine.label = ContactType.birthday.id
        birthdateLine.value = dateFormatter.string(from: randomDate)
        p.lines.append(birthdateLine)
        
        p.phone = String(contact[3])
        p.email = "\(name.replacingOccurrences(of: " ", with: "."))@email\(domains.randomElement()!)".lowercased()
        var websiteLine = ResumeContactLine()
        websiteLine.label = ContactType.website.id
        websiteLine.value = "www.\(name.replacingOccurrences(of: " ", with: "."))\(domains.randomElement()!)".lowercased()
        p.lines.append(websiteLine)
        
        let address = addresses.randomElement()!.split(separator: "|")
        p.street = String(address[0])
        p.city = String(address[1])
        p.state = ""
        p.postalCode = String(address[2])
        p.country = String(address[3])
        
        return p
    }
    
    static func randomExperience(currentPosition: Bool = false) -> ResumeItem {
        var i = ResumeItem()
        
        i.title = jobtitles.randomElement()!
        i.company = companies.randomElement()!
        
        let address = addresses.randomElement()!.split(separator: "|")
        i.address = String(address[1])
        
        i.currentPosition = currentPosition
        
        let date1 = Date.parse("2005-01-01")
        let date2 = Date.parse("2010-01-01")
        i.startDate = Date.randomBetween(start: date1, end: date2)
        
        let date3 = Date.parse("2011-01-01")
        let date4 = Date.parse("2015-01-01")
        i.endDate = currentPosition ? Date() : Date.randomBetween(start: date3, end: date4)
        
        i.description = Lorem.sentences(Int.random(in: 1..<6))
        return i
    }
    
    static func randomEducation(currentPosition: Bool = false) -> ResumeItem {
        var i = ResumeItem()
        
        i.title = Lorem.title
        i.company = universities.randomElement()!
        
        let address = addresses.randomElement()!.split(separator: "|")
        i.address = String(address[1])
        
        i.currentPosition = currentPosition
        
        let date1 = Date.parse("2005-01-01")
        let date2 = Date.parse("2010-01-01")
        i.startDate = Date.randomBetween(start: date1, end: date2)
        
        let date3 = Date.parse("2011-01-01")
        let date4 = Date.parse("2015-01-01")
        i.endDate = currentPosition ? Date() : Date.randomBetween(start: date3, end: date4)
        
        i.description = Bool.random() ? "" : Lorem.sentence
        return i
    }
    
    static func randomSkill() -> ResumeItem {
        var i = ResumeItem()
        i.title = Lorem.word
        i.rate = Int.random(in: 1...5)
        return i
    }
    
    static func randomLanguage() -> ResumeItem {
        var i = ResumeItem()
        i.title = ["English", "French", "Italian", "Russian", "Chinese", "Spanish", "Korean"].randomElement()!
        i.rate = Int.random(in: 0...6)
        return i
    }
    
    static func randomHobby(withDescription: Bool) -> ResumeItem {
        var i = ResumeItem()
        i.title = hobbies.randomElement()!
        i.description = withDescription ? Lorem.sentence : ""
        return i
    }
    
    static var companies: [String] = [
        "Frostfire Aviation","Grasshopper Security","Revelation Corporation","Tidustries","Buzzylectrics","Elitelligence","Silver Linetworks","Nimbleshine","Firebeat","Silver Media","Champion Industries","Hookurity","Sunavigations","Raptolutions","Trekords","Cavewater","Chiefwater","Lifebeat","Lion Entertainment","Karma Microsystems","Tiger Sports","Goblintelligence","Mountainetworks","Deserprises","Fairiprises","Oakcloud","Typhoonshine","Wolfbeat","Storm Productions","Heart Arts","Lioness Corporation","Dreamedia","Alpite","Grizzlimited","Rushcorp","Bridgecoms","Omegasys","Hookcast","Lioness Intelligence","Wood Coms","Deluge Systems","Twilightechnologies","Alphacom","Ironavigation","Hookurity","Wavemart","Spritemart","Iceshade",
    ]
    
    static var universities: [String] = [
        "Ursinus College","National Chung Hsing University, Taichung","Université de Kolwezi","Medical College of Pennsylvania and Hahnemann University","Link Campus University of Malta","University of North Bengal","The Global College Lahore","American University of Tirana","Hiroshima Jogakuin University","University of East Anglia","Université des Sciences et de la Technologie d'Oran","Abubakar Tafawa Balewa University","Vladimir State University","Fachhochschule Rosenheim, Hochschule für Technik und Wirtschaft","Isabela State University","Voronezh State University","Meru University of Science and Technology","Berklee College of Music","Dr. Bhim Rao Abdekar University","Nagoya College of Music","California School of Professional Psychology - Berkley/Alameda","Universidad Francisco de Aguirre","University of Vermont"
    ]
    
    static var domains: [String] = [
        ".org", ".com", ".io", ".pro"
    ]
    
    private static var addresses: [String] = [
        "449-8068 Fringilla Avenue|Bochum|868896|Seychelles",
        "458-1320 Elit. Rd.|Rock Springs|403100|Bonaire, Sint Eustatius and Saba",
        "6706 Fringilla Av.|Kumluca|57961|Saint Vincent and The Grenadines",
        "Ap #353-2291 Non, Street|Habay-la-Vieille|6779|Heard Island and Mcdonald Islands",
        "P.O. Box 672, 9783 Gravida. Ave|Wemmel|84731|Cayman Islands",
        "302-3543 A Rd.|Cabo de Santo Agostinho|Z2395|Bosnia and Herzegovina",
        "P.O. Box 570, 8343 Et, St.|Leighton Buzzard|82263|Luxembourg",
        "P.O. Box 927, 3015 Euismod Rd.|Vezirköprü|9378|Cayman Islands",
        "550-5810 Semper St.|Frigento|01934|Libya",
        "P.O. Box 338, 8688 Ligula. Street|Sierning|256341|Bahamas",
        "590-1797 Nonummy Av.|Hoogeveen|N2Z 5H2|Ecuador",
        "830-9412 Duis Rd.|Port Glasgow|J7S 3LY|Falkland Islands",
        "599-4033 Scelerisque Rd.|Isla de Pascua|58310|Trinidad and Tobago",
        "5330 Egestas Ave|Bihar Sharif|2598|Saint Lucia",
        "P.O. Box 918, 9481 Nam Street|Gasteiz|77624|Saint Martin",
        "990-338 Gravida Avenue|Jonesboro|P0S 4PZ|Belarus",
        "368-3753 Erat St.|Fort Resolution|068004|Qatar",
        "3906 Etiam St.|Amaro|146745|Australia",
        "651 Velit Road|Rexton|N3X 4NG|Trinidad and Tobago",
        "P.O. Box 664, 6999 Nunc St.|Anderlecht|41517|Philippines",
        "378 Id, St.|Appleby|384786|Uruguay",
        "2709 Parturient Avenue|Sevsk|682683|Brunei",
        "P.O. Box 935, 1969 Ultrices Rd.|Lincoln|5371|Yemen",
        "9118 Orci Road|Silifke|9828 AT|Norfolk Island",
        "307-7787 Vitae St.|Waitakere|77769-941|Poland",
        "Ap #712-8392 Sem Street|Coleville Lake|70316|Luxembourg",
        "P.O. Box 736, 7293 Vitae St.|Codegua|61101|United States Minor Outlying Islands",
        "9374 Convallis St.|Lac-Serent|936005|France",
        "2458 Cras Rd.|Baardegem|791149|Estania",
        "7726 Tristique Road|Trinità d'Agultu e Vignola|52579|Hungary",
    ]
    
    private static var contacts: [String] = [
        "Graiden|Phyllis|Gillespie|1-780-354-0135",
        "Dominic|Geraldine|Walters|697-1329",
        "Dustin|Kiayada|Garner|1-773-814-9333",
        "Emerson|MacKenzie|Howe|1-412-522-9244",
        "Samson|Josephine|Mcclain|1-550-353-0312",
        "Alan|Portia|Johnston|345-9097",
        "Hakeem|Ayanna|Mayer|377-3873",
        "Sawyer|Sarah|Roberson|1-416-154-3834",
        "Tobias|Suki|Jackson|969-4956",
        "Cullen|Jolie|Mendez|1-806-909-8749",
        "Deacon|Karen|Scott|955-4221",
        "Tad|Kylan|Raymond|136-7836",
        "Yasir|Flavia|Lara|1-151-572-0731",
        "Zeph|Delilah|Marks|178-2570",
        "Berk|Katelyn|Rodriguez|1-884-758-7734",
        "Damon|Olivia|Raymond|1-798-521-9106",
        "Clinton|Gemma|Haney|1-705-197-5782",
        "Galvin|Tana|Guzman|1-865-760-2451",
        "Jerry|Blair|Rhodes|403-9760",
        "Justin|Idona|Merritt|915-4236",
        "Lyle|Grace|Stanley|1-298-622-7973",
        "Daniel|Kimberley|Garner|845-5015",
        "Chandler|Chanda|Molina|1-758-833-9756",
        "Giacomo|Wynter|Norris|1-737-267-7849",
        "Hop|Remedios|Moran|1-933-833-7637",
        "Hamish|Alma|English|1-212-267-1946",
        "Tyrone|Yael|Cotton|916-4200",
        "Palmer|Amanda|Mosley|1-486-627-9272",
        "Quentin|Jena|Madden|559-3916",
        "Adam|Katelyn|Bright|1-472-815-1540",
    ]
   
    private static var jobtitles: [String] = [
        "Computer Scientist","IT Professional","UX Designer & UI Developer","SQL Developer","Web Designer","Web Developer","Help Desk Worker/Desktop Support","Software Engineer","Data Entry","DevOps Engineer","Computer Programmer","Network Administrator","Information Security Analyst","Artificial Intelligence Engineer","Cloud Architect","IT Manager","Technical Specialist","Application Developer","Chief Technology Officer (CTO)","Chief Information Officer (CIO)","Marketing coordinator","Marketing manager","Marketing assistant","Marketing director","Product marketing manager","Creative director","Demand generation director","Social media manager","Account manager","Brand manager","Content marketing manager","Marketing analyst","Marketing consultant","Social media coordinator","Search engine optimization specialist",
    ]
    
    private static var hobbies: [String] = [
        "Embroidery","Gun collecting","Curling","Competitive eating","Bird watching","Fossil hunting","Mountain climbing","Salsa dancing","Furniture building","Diving","Learn magic","Antique / Hand Tool Restoration","Ice skating","Whale watching","Dressage","Ghost hunting","Leaf collecting","Stamp collecting","Ballroom dancing","Tarot card reading","Survial Prepping","Model Trains","Knitting","Samurai sword collecting","Rock painting","Lapidary","Rugby","Astronomy","Furniture restoration","Paintball"
    ]
    
    static func fakePortrait() -> String {
        return "/9j/4AAQSkZJRgABAQABLAEsAAD/4QCMRXhpZgAATU0AKgAAAAgABQESAAMAAAABAAEAAAEaAAUAAAABAAAASgEbAAUAAAABAAAAUgEoAAMAAAABAAIAAIdpAAQAAAABAAAAWgAAAAAAAAEsAAAAAQAAASwAAAABAAOgAQADAAAAAQABAACgAgAEAAAAAQAAAt6gAwAEAAAAAQAAAtkAAAAA/+0AOFBob3Rvc2hvcCAzLjAAOEJJTQQEAAAAAAAAOEJJTQQlAAAAAAAQ1B2M2Y8AsgTpgAmY7PhCfv/CABEIAtkC3gMBIgACEQEDEQH/xAAfAAABBQEBAQEBAQAAAAAAAAADAgQBBQAGBwgJCgv/xADDEAABAwMCBAMEBgQHBgQIBnMBAgADEQQSIQUxEyIQBkFRMhRhcSMHgSCRQhWhUjOxJGIwFsFy0UOSNIII4VNAJWMXNfCTc6JQRLKD8SZUNmSUdMJg0oSjGHDiJ0U3ZbNVdaSVw4Xy00Z2gONHVma0CQoZGigpKjg5OkhJSldYWVpnaGlqd3h5eoaHiImKkJaXmJmaoKWmp6ipqrC1tre4ubrAxMXGx8jJytDU1dbX2Nna4OTl5ufo6erz9PX29/j5+v/EAB8BAAMBAQEBAQEBAQEAAAAAAAECAAMEBQYHCAkKC//EAMMRAAICAQMDAwIDBQIFAgQEhwEAAhEDEBIhBCAxQRMFMCIyURRABjMjYUIVcVI0gVAkkaFDsRYHYjVT8NElYMFE4XLxF4JjNnAmRVSSJ6LSCAkKGBkaKCkqNzg5OkZHSElKVVZXWFlaZGVmZ2hpanN0dXZ3eHl6gIOEhYaHiImKkJOUlZaXmJmaoKOkpaanqKmqsLKztLW2t7i5usDCw8TFxsfIycrQ09TV1tfY2drg4uPk5ebn6Onq8vP09fb3+Pn6/9sAQwAIBgYHBgUIBwcHCQkICgwUDQwLCwwZEhMPFB0aHx4dGhwcICQuJyAiLCMcHCg3KSwwMTQ0NB8nOT04MjwuMzQy/9sAQwEJCQkMCwwYDQ0YMiEcITIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIy/9oADAMBAAIRAxEAAAHrdtW21bbVttW21bbVttW21bbVttW21bbVttW21bbVttW21bbVttW21bbVttW21bbVttW21bbVttW21bbVttW21bbVttW21bbVttW21bbVttW21bbVttW21bbVlJVSdtW21bbVttW21bbVttW21bbVttW21bbVttW21bbVttW21bbVttW21bbVttW21bbVttW21bbVttW21bbVttW21bbVttW21bbVttW21bbVttW21bbVttW21bbVlJVSdtW21bbVttW21bbVttW21bbVttW21bbVttW21bbVttW21bbVttW21bbVttW21bbVttW21bbVttW21bbVttW21bbVttW21bbVttW21bbVttW21bbVttW21bbVlJVSdtW21bbVttW21bbVttW21bbVttW21bbVttW21bbVttW21bbVttW21bbVttW21bbVttW21bbVttW21bbVttW21bbVttW21bbVttW21bbVttW21bbVttW21bbVlJVSdtW21bbVttW21bbVttW21bbVttW21bbVttW21bbVttWwmNWLRomnIxajLbajy31P3VMurfNnNbbVttW21bbVttW21bbVttW21bbVttW21bbVttW21bbVttW21bbVttW21bbVlJVSdtW21bbVttW21bbVttW21bbVttW21bbVttW21bbVmcM60bVttW21bbVttW21Ls6nVdaqf0bbVttW21bbVttW21bbVttW21bbVttW21bbVttW21bbVttW21bbVttW21ZSVUnbVttW21bbVttW21bbVttW21bbVttW21bbVttWbuKmh7attq22rbattq22rbattq0xqsz01rRNtW21bbVttW21bbVttW21bbVttW21bbVttW21bbVttW21bbVttW21ZSVUnbVttW21bbVttW21bbVttW21bbVttW21bbVttTetcN62z2my7+a55PR6uajptXNT0mrnFdDq56Oi1cxr6noO2rGDqusA9bbVttW21bbVttW21bbVttW21bbVttW21bbVttW21bbVttW21bbVlJVSdtW21bbVttW21bbVttW21bbVttW21bbVttWiQ1WRpo98E9bbVttW21bbVttW21YRYrmomK22qwdNHdbbVttW21bbVttW21bbVttW21bbVttW21bbVttW21bbVttW21bbVlJVSdtW21bbVttW21bbVttW21bbVttW21bbVttWCaKpnrOyq021bbVttW21bbVttW21ZKtXMaYrbarB02c1ttW21bbVttW21bbVttW21bbVttW21bbVttW21bbVttW21bbVttWUlVJ21bbVttW21bbVttW21bbVttW21bbVttW21bbVVWDR5Vjtq22rbattq22rbattq22rnRPGdbaatCxNbbVttW21bbVttW21bbVttW21bbVttW21bbVttW21bbVttW21bbVlJVSdtW21bbVttW21bbVttW21bbVttW21bbVttW21M3I9Vptq22rbattq22rbattq22oHP9Pz9AKJ1Vhtq22rbattq22rbattq22rbattq22rbattq22rbattq22rbattq22rKSqk7attq22rbattq22rbattq22rbattq22rbastB6irumVPttW21bbVttW21bbVttW21aku6amNg0uqFiirbattq22rbattq22rbattq22rbattq22rbattq22rbattq22rbaspKqTtq22rbattq22rbattq22rbattq22rbattqxgkpztq22rbattq22rbattq22rbatX2GpC9qG2cN622rbattq22rbattq22rbattq22rbattq22rbattq22rbattq22rKSqk7attq22rbattq22rbattq22rbattq22rbattqdLbOa22rbattq22rbattq22rbattq2yKELattq22rbattq22rbattq22rbattq22rbattq22rbattq22rbattqykqpO2rbattq22rbattq22rbattq22rbattq22rbapdsy0421bbVttW21bbVttW21bbVttWambVttW21bbVttW21bbVttW21bbVttW21bbVttW21bbVttW21bbVttW21ZSVUnbVttW21bbVttW21bbVttW21bbVttW21bbVttWUnU90TW21bbVttW21bbVttW21ZCwUKNq22rbattq22rbattq22rbattq22rbattq22rbattq22rbattq22rbaspKqTtq22rbattq22rbattq22rbattq22rbattq22rbanBWrqttq22rbattq22rbattqzJw0pe2rbattq22rbattq22rbattq22rbattq22rbattq22rbattq22rbattqykqpO2rbattq22rbattq22rbattq22rbattq22rbattqzhvNPMhdbbVttW21bbVttWiG1JidW21bbVttW21bbVttW21bbVttW21bbVttW21bbVttW21bbVttW21bbVttWUlVJ21bbVttW21bbVttW21bbVttW21bbVttW21bbVttW21S4brpzgkpW2rbatsiljQmohWpOVqRCk1ttW21bbVttW21bbVttW21bbVttW21bbVttW21bbVttW21bbVttW21ZSVUnbVttW21bbVttW21bbVttW21bbVttW21bbVttW21bbUtc6o06tMapjao06o06o06o06k4k01zJ7W21bbVttW21bbVttW21bbVttW21bbVttW21bbVttW21bbVttW21ZSVUnbVttW21bbVttW21bbVttW21bbVttW21bbVttW21aY1OoVFRp1Rp1Rp1Rp1Rp1Rp1Rpmttq58zUdXuYP622rbattq22rbattq22rbattq22rbattq22rbattq22rbattqykqpO2rbattq22rbattq22rbattq22rbattq22rbatswpa6u6p9omtp1Rp1Rp1Rp1Rp1RpTWmNUhNX1T7as+Y6ryaM1W2qZq11YqrHMCU7zclE21bbVttW21bbVttW21bbVttW21bbVttW21ZSVUnbVttW21bbVttW21bbVttW21bbVttW21bQ2p1Fa3py02rdBz/AE1TMapUmanTqjTqjTFZMRU6JrbatT3HPUHbVttW21bbVttW21bbU+f0d1SttW21bbVttW21bbVttW21bbVttW21bbVlJVSdtW21bbVttW21bbVttW21bbVsFlVmKqRVg3b6pjattq22pfS0F/Ubatk8/XRK5fV0+5fV0k804q+wyVttU6JpHN3lHW21bbVttW21bbVttW21Z011Xuq7Op21bbVttW21bbVttW21bbVttW21bbVlJVSdtW21bbVttW21bbVttW21ZKq6myNq22rbattq22rban11VWtJ21IZPYrnc5bVttWcgvKxxrpWia0xNVtU+Y1ttWiYqdtW21bbVttW21bbVjg1Xk1NrU7attq22rbattq22rbattq22rbaspKqTtq22rbattq22rbattq20UGpKKttq22rbattq22rbarl+1dUmJ1JytTWj6WipvtY0d2rUnK1bbVKkzXPgmK22rbLqNoqMpNbbVttW21bbVttWODVeTV2lbbVttW21bbVttW21bbVttW21ZSVUnbVttW21bbVttW21bbVmTylpO2rbattq22rbRU7attFdC4Guttq20VHOW9NWesprpdpqNMVonUoJmdUe2raYrLRqnTFaNq22rbattq22rbattqz1lqvc0d1ttW21bbVttW21bbVttW21ZSVUnbVttW21bbVttW21bbU1rHbSttq22rbattq0TFTtNZY3FXspmonKpOgdVTRSamYirp7UWtbQqo0TUsH1ZVdMRUxMUqI1aUzUzk1Mxq2jVOmK0bVttW21bbVNtULq6yVVttW21bbVttW21bbVttWUlVJ21bbVttW21bbVttW21VAVJrbattq22rbatExUzGqXjOxqylWpK0qobCy5+gaYqdtS+h5u+oqoVSJ01FPc0VN4mKmNNRpTU6YpSZip2itMap21RExU7attq22rbanFrRPqf7attq22rbattq22rbaspKqTtq22rbattq22rbatEjqm21bbVttW21bbVomKnbVreovKebattqHzfQ89W21bbVrukuaf7attq3O9FzNJ21bbVttW21bbVttW21bbVttW21bbVttW21bbVZuqO3ou2rbattq22rbattqykqpO2rbattq22rbattqwTNarNtW21bbVttW21bbVttW6Dn+lpe2rbam1Be0VbbVttWuKe2qy21bbVHMdJzdbbVttW21bbVttW21bbVttW21bbVttW21bbVttWIPVdqqrWttq22rbattq22rKSqk7attq22rbattq22rMH9VTfbVttW21bbVttW21bbVPT850dbbVttTKkuaattq22rWtVZ1a7attqDzt/QVttW21bbVttW21bbVttW21bbVttW21bbVttW21bbVnzHVe5s5rbattq22rbaspKqTtq22rbattq22rbatSW1PW21bbVttW21bbVttW21Or6luq22rbaq6otaqttq22rWVbYVcbattqaUV3SVttW21bbVttW21bbVttW21bbVttW21bbVttW21bbVttSremLVxomttq22rbaspKqTtq22rbattq22rbamla8Z1ttW21bbVttW21bbVttVlbVtlW21bbVVVljXVttW21Z8xe1d7attqY0txT1ttW21bbVttW21bbVttVg1tVVRaxr6jbVttW21bbVttW21bbVttTm0on9PttW21bbVlJVSdtW21bbVttW21bbVUBmK22rbattq22rbattq22q6fNXVbbVttVMwesq22rbas7aOqvttW21VtTa1VbbVttW21bbVttW21bbVfQQdZu41UcWtXUbattq22rbattq22rbatMarVxSXFL21bbVlJVSdtW21bbVttW21YJmdV22rbattq22rbattq22rbauiMlVbbVttVE0ctq22rbas4bnrodtW21VdXZVtbbVttW21bbVttW21aYLV6Ig622rAPqpE3FVSNtW21bbVttW21bbVttWMHVeTXWNbbVlJVSdtW21bbVttW21aqfVNbbVttW21bbVstFbbVttWUktdHtq22rbaueAUVbbVttWKIldJtq22qorrCvrbattq22rbattq22rOWzyrKNq22rbasheqnFeVdN9tW21bbVttW21bbVttWs6xVXeQuspKqTtq22rbattq2yKrAbVttW21bbViisKE0fMa22rbas5bPau9tW21bbVzSJittq22rKTNdPtq22qnr7Cvrbattq22rbattq22rPmNhT3bVttW21bbVttVczvWVV+2rbattq22rbattq22qwe1lnWUlVJ21bbVttW21YJg1Ubattq22rbalXLGwpnXWtVW21bbVrCvtKtNtW21aJRXNbattq22rbaunlC622qnr7Gurbattq22rbattq22rWdZbUfbVttW21bbVttWbuKymu2rbattq22rbattq22pV3X2FZSVUnbVttW21bbVhFTVJtq22rbattqdWdJd0KnvKOttq22rW9Rd0921bbVhFb1z+2rbattq22rpCBNW21VVZa1VbbVttW21bbVttW21a5pryp21bbVttW21bbUmlsK6ttq22rbattq22rbastFpR1bVlJVSdtW21bbVttW21UcEHW21bbVttWtap5VjSXdPQttW21a+oeio22rbas1dM6o9tW21bbVttXQOGzmttqYU19Q1ttW21bbVttW21bbVrapf0+21bbVttW21bZFVreYrbattq22rbattq2004tBkrbaspKqTtq22rbattq22qqbvWVbbVttW21ZaNV7VvmlM9tW21bpeb6ettq22rMX1fVPtq22rbattqvXbN5W21C5zqOZpO2rbattq22rbattqVZt7Cttq22rbattqzF7S0nbVttW21bbVttW21Z02t6Ltq22rKSqk7attq22rbattqa1l3SVttW21bbVttT7NnFMttW21E6Tnuhrbattq1bZVdVe2rbattq22q6fMH9bbVqG+qqrNtW21bbVttW21b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APB7MX/50YJaWzL/APyuF+X/APO9c1/+Ln/+X82I/wDypZ2ZRp5//CNQ/wDxr/8AJ/H8v/w+iGP/AM3NAn/8oDLgrq+X/wDN5sL27/8Axc//AMuafl/+Vr99/Uf/AMIheR/+Pj+3/wCT/M//AEN4/n9P/wCTxH5f/wA7wkcf/j5//l+9T/8AK+Vtv63/AOESH/4z4fP/AOmLh61f/wAjbfAqIuX/APNcDQLgP/x8/wD8zB8fz/8Az8Jn0S//AI3j6f8A87JJ/wDnnvxn/wCIJH0ea5SV/wDztx93/wCRz/8AzJ1+X/5U4Hj/APDL65/+NY//AJL98/8Awgy4SKjLkY//ADofN3/8KgVwKk3XR/8AneMjj5//ACef/wCYJPIipDH/AOdMf/jTz8f/AMn+r/8AFI9DP/53pB//AAyOo5//ADnAcdtAggP/AMnn/wDm/vv/AM15L+h/f/4/4P8A+T/F/wDxf5Pj/wDP4fg/j/8AQf8Ad4//AJTnf//aAAwDAQACEQMRAAAQ888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888UM8cM888888888888888888888888888888888888888Yc88888c8888888888888888888888888888888888888s88888888sc8888888888888888888888888888888888888AA4Ygg48888888888888888888888888888888888884cIAAAAAAAU8U8888888888888888888888888888888888gAAAAAAAQ08c8888888888888888888888888888888888UAAAAAAAAU4c8888888888888888888888888888888888kAAAAAAAAQ88888888888888888888888888888888888o4AAAAAAAAUo88888888888888888888888888888888884AAAAAAAAAQg88888888888888888888888888888888888IAAAAAAAAAA88888888888888888888888888888888888MAAAAAAAAAE88888888888888888888888888888888888sAAAAAAAAQ8888888888888888888888888888888888888oAAAAAAAE8888888888888888888888888888888888888oAAAAAAMM888888888888888888888888888888888888884MAAEYQwU8888888888888888888888888888888888888MMc8MMMMA888888888888888888888888888888888888sgAAAAAAAA888888888888888888888888888888888884cI888880sU8s84w4w88888888888888888888888888048osw8840I0o88o8888c888888888888888888888840scgcgQ8YgIA0I888gU888sU888888888888888888884888g88o8008owIgU8Uc88888sQ8888888888888888888U888A88A4wc4wQQMU8800888888888888888888888888s8888M8kkEM8s8gcA400Q4w8w888s0888888888888888888888844Y0okYwIAoY40sYgM0c888M0888888888888888U88888sQwAk0gEYcUkY0UoEoUU8888o88888888888888s88888884AA888sAAE88o8888888888888888888888888o88888o8oAA888sAAc88U8888888888888888888888888888888o8oAA888sAAc88U8888888888888088888888888s88888o8AAA888sAA88o88888888888888I08888888888U88888o8AAA8884AAU8s88888Q08888888888888888884088888o8AAA8884AA08U88888UsU8888888s4888888888888888o8AAA8884AAc8c8888408sU8888888888888888k8888088sAAA8884AAco888888888s08888888408888848888oc884AAQc88ogA8o8888888888s88888888U88888o8888U0884AAA8884IA0U888888888884888888888888848888Q0884AAE8888AAcU88888488888E888888o8888888c888os884AAU8888gAU888888888888U8888848888888888888g88wAAU8888gA0888888k8888k888888k8888888808888k88IAAU8888gAQ888888488848888884U8888888888888488gAAU8888gAE0888888888088888888888888888U888884IAAQ8888oAA0888888Y8k888888k88888/8QAMxEBAQEAAwABAgUFAQEAAQEJAQARITEQQVFhIHHwkYGhsdHB4fEwQFBgcICQoLDA0OD/2gAIAQMRAT8Q/wD7CJ//2gAIAQIRAT8Q/wD7CJ//2gAIAQEAAT8Q/wD2b5fj/wDZzl+P/wBnOX4//Zzl+P8A9nOX4/8A2c5fj/8AZzl+P/2c5fj/APUcM468vxdoz8/1FEj7RP7q7IHqV7I+Qb/PCH8VvsLB+7wp/wCHFcB/uFElTsf/ANYcvx/+ods3Rp/BW3oIC+89L/8AJQrkQnTVLHFInT/f/wCr+X4//T1ArwU9iD9v1191VKlXle//AMxhfInk7pua+WP4/wD1dy/H/wCnsK0Rj/p/uqpVVeV//PTJn5BY4Z8v+vP/AOrOX4//AE7V4w+Dv/8AQgSIMidUc4DfTyf/AKr5fj/9NUCVgr/Hvh1/+hyIhI0wMGeB/wD1Vy/H/wCmyZel8d//AIDFIOWQ/wCGed+ZXiH7f6qXIfLv/wBFRuG+9H4T7f6o3D/aj8fmWW+PM8rj/wDFun/EH/8AVXL8f/psoXCHz3/1YhGw4X4+KZYUAID/ALL5bL5bL5bL5bL5bL5//AKo9Aw/Z3YvY6PA9f8A4UM817On/wDVPL8f/phPcJ+FRuRS/wDAGjIdHj5aGAUB0f8A5xDku/iGopEhGH/8BP5n5Dp/f/6p5fj/APTMb4fk/wDHRKAHbQpC/kf/AJ71YLVJXLr/APggR8l8mn6X/wDVPL8f/piAOQfg/wDBBki/fg/n/wDQDIe38U4P/wAH+N6//VPL8f8A6YaPAT81FK5GG/T/AOR//QInPOX1Ip/+CZ8l/r/9U8vx/wDpvgrR97Rv6v0//oP+SKf/AMELeWX53/8AVPL8f/pvoX/WU6+Qfr/9BeDxF98P8f8AQUDlYKRvAD/9U8vx/wDps/iL8v8A5Xh4P8f/AKDAo+of+uLw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"
    }
}
