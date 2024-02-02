//https://samwize.com/2019/07/02/how-to-generate-pdf-with-images/

import PDFKit
import WebKit
import SwiftUI
import Combine


public enum PDFBuilderError: Error, LocalizedError{
    case cannotBuildPDF
    case loadingFail
    
    public var errorDescription: String? {
        switch self {
        case .cannotBuildPDF:
            return "Cannot Build PDF"
        case .loadingFail:
            return "Cannot Load PDF"
        }
    }
}


typealias PDFBuilderCompletion = (Result<PDFDocument, Error>) -> Void


class PDFBuilder: NSObject, WKNavigationDelegate {
    static let shared = PDFBuilder()
    
    var webView: WKWebView
    var completion: PDFBuilderCompletion!
    var style = ResumeStyle()
    let subject = PassthroughSubject<String, Never>()
    var cancellable = [AnyCancellable]()
    
    override init(){
        webView = WKWebView()
        if let window = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first {
            webView.frame = window.frame
            //window.addSubview(webView)
        }
        
        super.init()
        
        subject.debounce(for: .seconds(0.5), scheduler: RunLoop.main).sink { html in
            self.webView.stopLoading()
            self.webView.loadHTMLString(html, baseURL: nil)
        }.store(in: &cancellable)
        
        webView.isHidden = true
        webView.navigationDelegate = self
    }

    func exportPDF(html: String, style: ResumeStyle, completion: @escaping PDFBuilderCompletion) {
        self.style = style
        self.completion = completion
        subject.send(html)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        createPDF(webView: webView)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.completion?(.failure(PDFBuilderError.loadingFail))
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.completion?(.failure(PDFBuilderError.loadingFail))
    }

    private func createPDF(webView: WKWebView) {
        let pdfData = NSMutableData()
        let formatter = webView.viewPrintFormatter()
        let render = CustomPrintPageRenderer(marge: self.style.inset)
        let layout = TemplateStore.shared.layouts.first { $0.id == self.style.layout } ?? TemplateStore.shared.layouts.first!
        render.addPrintFormatter(formatter, startingAtPageAt: 0)
        
        UIGraphicsBeginPDFContextToData(pdfData, render.pageFrame, nil)
        
        let context = UIGraphicsGetCurrentContext()!
        
        for i in 0..<render.numberOfPages {
            UIGraphicsBeginPDFPage();
            
            // Order is important
            //1 - Background color
            let backCoverView = UIView(frame: render.pageFrame)
            backCoverView.backgroundColor = UIColor(Color(hex: style.backgroundColor))
            backCoverView.layer.render(in: context)
            
            layout.layers.forEach { layer in
                if layer == .top && i == 0 {
                    let headerCoverView = UIView(frame: CGRect(x: 0, y: 0, width: Int(render.pageFrame.width), height: style.inset+5))
                    headerCoverView.backgroundColor = UIColor(Color(hex: style.primaryColor))
                    headerCoverView.layer.render(in: context)
                }
                if layer == .left {
                    let sideCoverView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: Int(render.pageFrame.height)))
                    sideCoverView.backgroundColor = UIColor(Color(hex: style.secondaryColor))
                    sideCoverView.layer.render(in: context)
                }
            }
            
            render.drawPage(at: i, in: UIGraphicsGetPDFContextBounds())
        }
        UIGraphicsEndPDFContext();
        
        guard let pdfDocument = PDFDocument(data: pdfData as Data) else {
            self.completion?(.failure(PDFBuilderError.cannotBuildPDF))
            return
        }

        self.completion?(.success(pdfDocument))
    }
}


class CustomPrintPageRenderer: UIPrintPageRenderer {
    //Par defaut iOS utilise le format 612 x 792 US Letter pour PDF dans la webview et le Printer
    //http://www.shanirivers.com/blog/2019-10-17-paper-dimensions-in-pixels/
    let pageFrame = CGRect(x: 0.0, y: 0.0, width: 612, height: 792)
    var marge: CGFloat
    
    init(marge: Int) {
        self.marge = CGFloat(marge)
        super.init()
        
        self.setValue(NSValue(cgRect: pageFrame), forKey: "paperRect")
        self.setValue(NSValue(cgRect: pageFrame), forKey: "printableRect")
        
        self.headerHeight = self.marge
        self.footerHeight = self.marge
    }
    
    override func drawPage(at pageIndex: Int, in printableRect: CGRect) {
        super.drawPage(at: pageIndex, in: printableRect)
        
        
        let font = UIFont.systemFont(ofSize: 10)
        let padding: CGFloat = 10
        
        if self.numberOfPages > 1 {
            //Nombre de page
            let textAttributes = [
                NSAttributedString.Key.font: font,
                NSAttributedString.Key.foregroundColor: UIColor.lightGray
            ]
            let pageText = "\(pageIndex+1)/\(self.numberOfPages)"
            let pageTextSize = getTextSize(text: pageText, font: font)
            
            pageText.draw(at: CGPoint( // bottom center
                x: printableRect.size.width / 2 - pageTextSize.width / 2,
                y: printableRect.size.height - padding - pageTextSize.height
            ), withAttributes: textAttributes)
        }
        
        
        if !AppState.shared.isPremium {
            //Lien vers le site web
            let linkAttributes = [
                NSAttributedString.Key.font: font,
                NSAttributedString.Key.foregroundColor: UIColor.gray
            ]
            let linkText = "www.resume-designer.com"
            
            let linkTextSize = getTextSize(text: linkText, font: font)
            linkText.draw(at: CGPoint( //bottom right corner
                x: printableRect.size.width - padding - linkTextSize.width,
                y: printableRect.size.height - padding -  linkTextSize.height
            ), withAttributes: linkAttributes)
        }
    }
    
    private func getTextSize(text: String, font: UIFont!, textAttributes: [NSAttributedString.Key: Any]! = nil) -> CGSize {
        let testLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: self.paperRect.size.width, height: footerHeight))
        if let attributes = textAttributes {
            testLabel.attributedText = NSAttributedString(string: text, attributes: attributes)
        }
        else {
            testLabel.text = text
            testLabel.font = font!
        }
        
        testLabel.sizeToFit()
        
        return testLabel.frame.size
    }
}
