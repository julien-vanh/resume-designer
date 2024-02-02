//
//  ImageStore.swift
//  SimulateurLocatif
//
//  Created by Julien Vanheule on 19/05/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import UIKit
import SwiftUI

enum ImageStoreError: Error {
    case cannotLoadImage
}

final class ImageStore {
    static var shared = ImageStore()
    fileprivate static var scale = 1
    
    func localImage(name: String) -> Image {
        var cgimage: CGImage
        if let image = try? loadImage(name: name) {
            cgimage = image
        } else {
            cgimage = try! loadImage(name: "placeholder.jpg")
        }
        return Image(cgimage, scale: CGFloat(ImageStore.scale), label: Text(verbatim: name))
    }

    private func loadImage(name: String) throws -> CGImage {
        guard
            let url = Bundle.main.url(forResource: name, withExtension: nil),
            let imageSource = CGImageSourceCreateWithURL(url as NSURL, nil),
            let image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil)
        else {
            throw ImageStoreError.cannotLoadImage
            
        }
        return image
    }
}
