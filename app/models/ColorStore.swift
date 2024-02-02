//
//  ColorStore.swift
//  ResumeDesigner
//
//  Created by Julien Vanheule on 30/10/2021.
//

import Foundation

struct ColorSet: Hashable {
    var backgroundColor: String
    var primaryColor: String
    var secondaryColor: String
    var textColor: String
    var skillColor: String
    
    init(_ array: [String]) {
        backgroundColor = array[0]
        primaryColor = array[1]
        secondaryColor = array[2]
        textColor = array[3]
        skillColor = array[4]
    }
    
    init(backgroundColor: String, primaryColor: String, secondaryColor: String, textColor: String, skillColor: String) {
        self.backgroundColor = backgroundColor
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
        self.textColor = textColor
        self.skillColor = skillColor
    }
}

class ColorStore {
    static let shared = ColorStore()
    
    var sets : [ColorSet] = [
        ColorSet(["ffffff", "CFE5E8","E0F8FF","32CAE0","32CAE0"]),
        ColorSet(["ffffff", "E3D4E8","F0E2FF","AB4F9E","E36EC9"]),
        ColorSet(["ffffff", "DBEBD7","E6FFE9","387F2A","4A9E33"]),
        ColorSet(["ffffff", "F7DBC6","FFEFEA","F78A3E","F78A3E"]),
        ColorSet(["ffffff", "D75862","FF6879","BF0D25","BF0D25"]),
        ColorSet(["ffffff", "1E1E1E","F4F4F4","8D6501","E5A303"]),
        ColorSet(["000000","001d3d","003566","ffc300","fb8500"]),
    ]
}
