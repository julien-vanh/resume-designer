//
//  String+trim.swift
//  SignatureDesigner
//
//  Created by Julien Vanheule on 27/01/2021.
//

import Foundation

extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension String {
    private static let slugSafeCharacters = CharacterSet(charactersIn: "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-")

    public func convertedToSlug() -> String? {
        if let latin = self.applyingTransform(StringTransform("Any-Latin; Latin-ASCII; Lower;"), reverse: false) {
            let urlComponents = latin.components(separatedBy: String.slugSafeCharacters.inverted)
            let result = urlComponents.filter { $0 != "" }.joined(separator: "-")

            if result.count > 0 {
                return result
            }
        }

        return nil
    }
    
    func safeUrl() -> String {
        var result = self.trim()
        guard !result.isEmpty else {
            return "#"
        }
        if (!result.starts(with: "http://") && !result.starts(with: "https://")){
            result = "https://" + result
        }
        return result
    }
    
    func safeString() -> String {
        return self.trim()
    }
    
    func cssColor() -> String {
        return "#\(self)"
    }
}
