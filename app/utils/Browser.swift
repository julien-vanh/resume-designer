//
//  Browser.swift
//  ResumeDesigner
//
//  Created by Julien Vanheule on 15/10/2021.
//

import Foundation
import SwiftUI

class Browser : NSObject {
    static func openLinkInBrowser(link: String){
        var urlString = link
        if !link.hasPrefix("http"){
            urlString = "http://"+link
        }
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}
