//
//  TemplateStore.swift
//  ResumeDesigner
//
//  Created by Julien Vanheule on 11/08/2021.
//

import Foundation

enum ColoredLayer {
    case top
    case left
}
struct Layout: Identifiable, Hashable {
    var id: Int
    var isPremium: Bool = false
    var layers: [ColoredLayer] = [] //order is important
}

struct TemplateGroup {
    var title: String
    var templates: [Template]
    var prefix: String
    var description: String
    
    func templateAtIndex(_ index: Int) -> Template {
        guard index < templates.count else {
            print("Tempalte not found")
            return templates[0]
        }
        return templates[index]
    }
}

struct Template: Identifiable, Hashable {
    var id: Int
    var isPremium: Bool = false
    var randomable: Bool = true //can be use by the generator
}

class TemplateStore {
    static let shared = TemplateStore()
    
    var layouts : [Layout]
    var titles : TemplateGroup
    var sections : TemplateGroup
    var contacts : TemplateGroup
    var items : TemplateGroup
    
    func layoutAtIndex(_ index: Int) -> Layout {
        guard index < layouts.count else {
            print("Template not found")
            return layouts[0]
        }
        return layouts[index]
    }
    
    init() {
        layouts = [
            Layout(id: 0, layers: [.top]),
            Layout(id: 1, layers: [.top]),
            Layout(id: 2, layers: [.top]),
            Layout(id: 3, layers: [.top]),
            Layout(id: 4, layers: [.top]),
            Layout(id: 5, layers: [.top]),
            Layout(id: 6, isPremium: true, layers: [.left, .top]),
            Layout(id: 7, isPremium: true, layers: [.left, .top]),
            Layout(id: 8, isPremium: true, layers: [.left]),
            Layout(id: 9, isPremium: true, layers: [.left]),
            Layout(id: 10, isPremium: true, layers: [.top, .left]),
            Layout(id: 11, isPremium: true),
            Layout(id: 12, isPremium: true),
            Layout(id: 13, isPremium: true),
            Layout(id: 14, isPremium: true, layers: [.top]),
        ]
        
        titles = TemplateGroup(title:NSLocalizedString("Name and headline", comment: ""), templates: [
            Template(id: 0),
            Template(id: 1),
            Template(id: 2),
            Template(id: 3),
            Template(id: 4),
            Template(id: 5),
            Template(id: 6),
            Template(id: 7),
            Template(id: 8, isPremium: true),
            Template(id: 9, isPremium: true),
            Template(id: 10, isPremium: true),
            Template(id: 11, isPremium: true),
            Template(id: 12, isPremium: true),
            Template(id: 13, isPremium: true),
            Template(id: 14, isPremium: true),
            Template(id: 15, isPremium: true),
            Template(id: 16, isPremium: true),
            Template(id: 17, isPremium: true),
        ], prefix: "title-", description: "Name and job title section")
        
        sections = TemplateGroup(title:NSLocalizedString("Section titles", comment: ""), templates: [
            Template(id: 0),
            Template(id: 1),
            Template(id: 2),
            Template(id: 3),
            Template(id: 4),
            Template(id: 5, isPremium: true),
            Template(id: 6, isPremium: true),
            Template(id: 7, isPremium: true, randomable: false),
            Template(id: 8, isPremium: true, randomable: false),
            Template(id: 9, isPremium: true),
            Template(id: 10, isPremium: true),
            Template(id: 11, isPremium: true, randomable: false),
        ], prefix: "section-", description: "Section headlines")
        
        contacts = TemplateGroup(title:NSLocalizedString("Contact block", comment: ""), templates: [
            Template(id: 0),
            Template(id: 1),
            Template(id: 2),
            Template(id: 3, isPremium: true),
            Template(id: 4, isPremium: true),
            Template(id: 5, isPremium: true),
            Template(id: 6, isPremium: true),
        ], prefix: "contact-", description: "Contact block")
        
        items = TemplateGroup(title:NSLocalizedString("Items", comment: ""), templates: [
            Template(id: 0),
            Template(id: 1),
            Template(id: 2),
            Template(id: 3),
            Template(id: 4, isPremium: true),
            Template(id: 5, isPremium: true),
        ], prefix: "item-", description: "Item")
    }
}
