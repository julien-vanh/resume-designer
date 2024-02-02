//https://stackoverflow.com/questions/56533564/showing-uiactivityviewcontroller-in-switui

import UIKit
import SwiftUI

class SharingObject: ObservableObject {
    @Published var displayPopup = false
    @Published var sharedItems: [Any] = []
    @Published var excludedActivityTypes: [UIActivity.ActivityType] = []
}


struct ActivityViewController: UIViewControllerRepresentable {
    var activityItems: [Any]
    var excludedActivityTypes: [UIActivity.ActivityType]

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        controller.excludedActivityTypes = excludedActivityTypes
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityViewController>) {}

}
