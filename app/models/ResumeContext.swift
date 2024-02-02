//
//  ResumeContext.swift
//  ResumeDesigner
//
//  Created by Julien Vanheule on 18/10/2021.
//

import Foundation

struct ResumeContext {
    //Content
    let photo: PhotoContext
    let name: String
    let contactlines: [ContextContactLine]
    let designation: String
    let contactTitle: String
    let allSections: [String: Any]
    let detailledSections: [String: Any]
    let otherSections: [String: Any]
    
    //Style
    let color1: String
    let color2: String
    let color1Contrasted: String
    let color2Contrasted: String
    let background: String
    let backgroundContrasted: String
    
    //Traduction
    let colons: String
    
    let titleColor: String
    let titleColorContrasted: String
    let contactColor: String
    let contactColorContrasted: String
    let sectionColor: String
    let sectionColorContrasted: String
    let itemColor: String
    let itemColorContrasted: String
    let skillColor: String
    let skillColorContrasted: String
    
    let fontFamily: String
    let fontSize: String
    let inset: String
    let skillStyle: String
    
    //Templates
    let TITLE: String
    let titleAlignment: String
    let SECTIONSTYLE: String
    let SECTIONCLASS: String
    let CONTACT: String
    let ITEM: String
    
    var asDictionary : [String:Any] {
        let mirror = Mirror(reflecting: self)
        let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({ (label:String?, value:Any) -> (String, Any)? in
            guard let label = label else { return nil }
            return (label, value)
        }).compactMap { $0 })
        return dict
    }
}

struct ContextSections {
    let sections: [ContextSection]
    
    var asDictionary : [String:Any] {
        let mirror = Mirror(reflecting: self)
        let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({ (label:String?, value:Any) -> (String, Any)? in
            guard let label = label else { return nil }
            return (label, value)
        }).compactMap { $0 })
        return dict
    }
}

struct ContextSection {
    let title: String
    let items: [ContextItem]
    let style: String
}

struct ContextItem {
    let title: String
    let description: String
    let rate: Int
    let company: String
    let address: String
    let startDate: String
    let endDate: String
    let currentPosition: Bool
    let formattedDate: String
}

struct ContextContactLine {
    let label: String
    let value: String
    let link: String
    let icon: String
}

struct PhotoContext {
    var content: String
    
    var shapeClass: String
    var width: String
    var height: String
    var frameClass: String
    var color1: String
    var color2: String
}
