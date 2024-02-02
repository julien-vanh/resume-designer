//
//  ResumeGenerator.swift
//  ResumeDesigner
//
//  Created by Julien Vanheule on 11/08/2021.
//

import Foundation
import Stencil
import PathKit
import SwiftUI

class ResumeGenerator {
    static let shared = ResumeGenerator()
    
    private let environment: Stencil.Environment
    
    init(){
        let path = PathKit.Path(Bundle.main.resourcePath ?? "")
        let loader = FileSystemLoader(paths: [path])
        let extensions = StencilExtensionStore.shared.all
        self.environment = Environment(loader: loader, extensions: extensions)
    }
    
    func getHTML(resume: ResumeContent, forcedLayout: String? = nil) -> String {
        let layout: String
        if let forcedLayout = forcedLayout {
            layout = forcedLayout
        } else {
            layout = "layout-\(resume.style.layout).html"
        }
        
        let context = buildContext(resume: resume)
        
        let rendered: String
        do {
            rendered = try environment.renderTemplate(name: layout, context: context.asDictionary)
        } catch {
            print("Template Error", error.localizedDescription)
            rendered = "Template could not be loaded"
        }
        
        return rendered
    }
    
    private func buildContext(resume: ResumeContent) -> ResumeContext {
        return ResumeContext(
            photo: photo(resume.contact.photo, style: resume.style.photoStyle),
            name: resume.contact.name.safeString(),
            contactlines: contactlines(resume: resume),
            designation: resume.contact.designation.safeString(),
            contactTitle: resume.contact.sectionName.safeString(),
            allSections: ContextSections(sections: sectionsArray(resume: resume)).asDictionary,
            detailledSections: ContextSections(sections: sectionsArray(resume: resume, filters: [.detailled])).asDictionary,
            otherSections: ContextSections(sections: sectionsArray(resume: resume, filters: [.language, .titleDescription, .titleOnly, .titleRate])).asDictionary,
            
            color1: resume.style.primaryColor.cssColor(),
            color2: resume.style.secondaryColor.cssColor(),
            color1Contrasted: Color(hex: resume.style.primaryColor).contrastedHex().cssColor(),
            color2Contrasted: Color(hex: resume.style.secondaryColor).contrastedHex().cssColor(),
            background: resume.style.backgroundColor.cssColor(),
            backgroundContrasted: Color(hex: resume.style.backgroundColor).contrastedHex().cssColor(),
            
            colons: NSLocalizedString(": ", comment: "colons"),
            
            titleColor: resume.style.titleColor.cssColor(),
            titleColorContrasted: Color(hex: resume.style.titleColor).contrastedHex().cssColor(),
            contactColor: resume.style.contactColor.cssColor(),
            contactColorContrasted: Color(hex: resume.style.contactColor).contrastedHex().cssColor(),
            sectionColor: resume.style.sectionColor.cssColor(),
            sectionColorContrasted: Color(hex: resume.style.sectionColor).contrastedHex().cssColor(),
            itemColor: resume.style.itemColor.cssColor(),
            itemColorContrasted: Color(hex: resume.style.itemColor).contrastedHex().cssColor(),
            skillColor: resume.style.skillColor.cssColor(),
            skillColorContrasted: Color(hex: resume.style.skillColor).contrastedHex().cssColor(),
            
            fontFamily: FontType.cssFor(FontType(rawValue: resume.style.font) ?? FontType.arial),
            fontSize: "\(resume.style.fontSize)pt",
            inset: "\(resume.style.inset)pt",
            skillStyle: resume.style.skillStyle,
            
            TITLE: "title-\(resume.style.titleTemplate).html",
            titleAlignment: TextAlignmentType.cssFor(TextAlignmentType(rawValue: resume.style.titleAlignment) ?? TextAlignmentType.left),
            SECTIONSTYLE: "section-\(resume.style.sectionTemplate).css",
            SECTIONCLASS: "section-\(resume.style.sectionTemplate)", //css class
            CONTACT: "contact-\(resume.style.contactTemplate).html",
            ITEM: "item-\(resume.style.itemTemplate).html"
        )
    }
    
    
    
    private func photo(_ photo: String, style: PhotoStyle) -> PhotoContext {
        let shape = PhotoShape(rawValue: style.shape) ?? PhotoShape.square
        let width = "\(style.width)pt"
        let height = (shape == PhotoShape.circle) ? width : "\(style.height)pt"
        
        return PhotoContext(
            content: photo,
            shapeClass: "shape-\(style.shape)",
            width: width,
            height: height,
            frameClass: "frame-\(style.frame)",
            color1: style.color1.cssColor(),
            color2: style.color2.cssColor()
        )
    }
    
    private func contactlines(resume: ResumeContent) -> [ContextContactLine] {
        var result: [ContextContactLine] = []
        if !resume.contact.formattedAddress.isEmpty {
            result.append(ContextContactLine(
                label: NSLocalizedString("Address", comment: ""),
                value: resume.contact.formattedAddress,
                link: "",
                icon: ContactType.svgFor(.address)))
        }
        if !resume.contact.email.isEmpty {
            result.append(ContextContactLine(
                label: NSLocalizedString("Email", comment: ""),
                value: resume.contact.email,
                link: "mailto:\(resume.contact.email)",
                icon: ContactType.svgFor(.mail)))
        }
        if !resume.contact.phone.isEmpty {
            result.append(ContextContactLine(
                label: NSLocalizedString("Phone", comment: ""),
                value: resume.contact.phone,
                link: "tel:\(resume.contact.phone)",
                icon: ContactType.svgFor(.phone)))
        }
        for line in resume.contact.lines {
            if !line.value.isEmpty {
                var icon = ""
                var label = ""
                let type = ContactType(rawValue: line.label)
                if let type = type {
                    icon = ContactType.svgFor(type)
                    label = ContactType.labelFor(type)
                }
                result.append(ContextContactLine(
                    label: label,
                    value: line.value,
                    link: "",
                    icon: icon))
            }
        }
        
        return result
    }
    
    private func sectionsArray(resume: ResumeContent, filters: [SectionType] = []) -> [ContextSection] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        
        var result: [ContextSection] = []
        resume.sections.forEach { section in
            if filters.contains(section.style) || filters.isEmpty {
                var items: [ContextItem] = []
                section.items.forEach { item in
                    if !item.hidden {
                        items.append(ContextItem(
                            title: item.title,
                            description: item.description.replacingOccurrences(of: "\n", with: "<br />"),
                            rate: item.rate,
                            company: item.company,
                            address: item.address,
                            startDate: dateFormatter.string(from: item.startDate),
                            endDate: dateFormatter.string(from: item.endDate),
                            currentPosition: item.currentPosition,
                            formattedDate: item.formattedDate
                        ))
                    }
                }
                result.append(ContextSection(
                    title: section.title,
                    items: items,
                    style: section.style.rawValue
                ))
            }
        }
        return result
    }
}
