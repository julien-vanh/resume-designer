// https://stackoverflow.com/questions/56726663/how-to-add-a-textfield-to-alert-in-swiftui

import SwiftUI
import Combine

class TextFieldAlertViewController: UIViewController {
    private let alertTitle: String
    private let placeholder: String?
    @Binding private var text: String
    private var isPresented: Binding<Bool>?
    private var subscription: AnyCancellable?

    init(title: String, placeholder: String?, text: Binding<String>, isPresented: Binding<Bool>?) {
        self.alertTitle = title
        self.placeholder = placeholder
        self._text = text
        self.isPresented = isPresented
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentAlertController()
    }

    private func presentAlertController() {
        guard subscription == nil else { return } // present only once

        let vc = UIAlertController(title: NSLocalizedString(alertTitle, comment: ""), message: nil, preferredStyle: .alert)
        vc.addTextField { [weak self] textField in
            textField.placeholder = self?.placeholder
            textField.text = self?.text
        }
        vc.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: { _ in
            self.isPresented?.wrappedValue = false
        }))
        vc.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
            let textField = vc.textFields![0] as UITextField
            if let text = textField.text, !text.isEmpty {
                self.text = text
            } else {
                self.text = self.placeholder ?? ""
            }
            self.isPresented?.wrappedValue = false
        }))
        present(vc, animated: true, completion: nil)
    }
}


struct TextFieldAlert {
    let title: String
    let placeholder: String?
    @Binding var text: String
    var isPresented: Binding<Bool>? = nil

    func dismissable(_ isPresented: Binding<Bool>) -> TextFieldAlert {
        TextFieldAlert(title: title, placeholder: placeholder, text: $text, isPresented: isPresented)
    }
}


extension TextFieldAlert: UIViewControllerRepresentable {
    typealias UIViewControllerType = TextFieldAlertViewController

    func makeUIViewController(context: UIViewControllerRepresentableContext<TextFieldAlert>) -> UIViewControllerType {
        TextFieldAlertViewController(title: title, placeholder: placeholder, text: $text, isPresented: isPresented)
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: UIViewControllerRepresentableContext<TextFieldAlert>) {
        // no update needed
    }
}


struct TextFieldWrapper<PresentingView: View>: View {
    @Binding var isPresented: Bool
    let presentingView: PresentingView
    let content: () -> TextFieldAlert

    var body: some View {
        ZStack {
            if (isPresented) {
                content()
                    .dismissable($isPresented)
            }
            presentingView
        }
    }
}


extension View {
    func textFieldAlert(isPresented: Binding<Bool>, content: @escaping () -> TextFieldAlert) -> some View {
        TextFieldWrapper(isPresented: isPresented, presentingView: self, content: content)
    }
}
