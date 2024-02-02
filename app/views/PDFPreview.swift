//
//  PDFPreview.swift
//  SimulateurLocatif
//
//  Created by Julien Vanheule on 05/05/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI
import PDFKit

struct PDFPreview: UIViewRepresentable {
    @ObservedObject var resume: Resume
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.backgroundColor = .systemGray5
        pdfView.autoScales = true
        
        PDFBuilder.shared.exportPDF(html: resume.html, style: resume.content.style) { result in
            switch result {
            case let .success(pdf):
                pdfView.document = pdf
                pdfView.scaleFactor = pdfView.scaleFactorForSizeToFit
            case let .failure(error):
                print("Preview error", error)
            }
        }
        
        return pdfView
    }

    func updateUIView(_ pdfView: PDFView, context: Context) {
        
        PDFBuilder.shared.exportPDF(html: resume.html, style: resume.content.style) { result in
            switch result {
            case let .success(pdf):
                pdfView.document = pdf
                pdfView.scaleFactor = pdfView.scaleFactorForSizeToFit
            case let .failure(error):
                print("Preview error", error)
            }
        }
 
    }
}
