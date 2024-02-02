//
//  StencilExtensions.swift
//  ResumeDesigner
//
//  Created by Julien Vanheule on 13/10/2021.
//

import Stencil

class StencilExtensionStore {
    static let shared = StencilExtensionStore()
    
    let itemExtension: Extension
    
    var all: [Extension] {
        return [itemExtension]
    }
    
    init(){
        itemExtension = Extension()
        itemExtension.registerFilter("skill") { (value: Any?, arguments: [Any?]) in
            if let value = value as? Int {
                return ResumeItem.skillDescriptionFor(value)
            }
            return ""
        }
        itemExtension.registerFilter("language") { (value: Any?, arguments: [Any?]) in
            if let value = value as? Int {
                let language = LanguageLevel.init(rawValue: value) ?? .native
                return LanguageLevel.labelFor(language)
            }
            return value
        }
    }
    
}



