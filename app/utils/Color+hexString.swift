//
//  Color+hexString.swift
//  SignatureDesigner
//
//  Created by Julien Vanheule on 25/01/2021.
//

import Foundation
import SwiftUI

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.currentIndex = hex.startIndex
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff

        self.init(red: Double(r) / 0xff, green: Double(g) / 0xff, blue: Double(b) / 0xff)
    }
    
    var toHex: String {
        return toHex()
    }

    func toHex(alpha: Bool = false) -> String {
        guard let components = cgColor?.components, components.count >= 3 else {
            return "1c1c1c"
        }

        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)

        if components.count >= 4 {
            a = Float(components[3])
        }

        if alpha {
            return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }
    
    func contrastedHex() -> String {
        guard let components = cgColor?.components, components.count >= 3 else {
            return "FFFFFF"
        }

        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        
        let uicolors = [r, g, b];
        
        let c = uicolors.map { col -> Float in
            if (col <= 0.03928) {
                return col / 12.92;
            }
            return pow((col + 0.055) / 1.055, 2.4);
        }
        
        let L = (0.2126 * c[0]) + (0.7152 * c[1]) + (0.0722 * c[2]);
        return (L > 0.179) ? "1c1c1c" : "FFFFFF";
    }
}
