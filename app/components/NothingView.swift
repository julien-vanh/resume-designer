//https://stackoverflow.com/questions/68807418/how-to-show-in-swiftui-the-sidebar-in-ipad-and-portrait-mode

import SwiftUI
import UIKit

struct UIKitShowSidebar: UIViewRepresentable {
  let showSidebar: Bool
  
  func makeUIView(context: Context) -> some UIView {
    let uiView = UIView()
    if self.showSidebar {
      DispatchQueue.main.async { [weak uiView] in
        uiView?.next(of: UISplitViewController.self)?
          .show(.primary)
      }
    } else {
      DispatchQueue.main.async { [weak uiView] in
        uiView?.next(of: UISplitViewController.self)?
          .show(.secondary)
      }
    }
    return uiView
  }
  
  func updateUIView(_ uiView: UIViewType, context: Context) {
    DispatchQueue.main.async { [weak uiView] in
      uiView?.next(
        of: UISplitViewController.self)?
        .show(showSidebar ? .primary : .secondary)
    }
  }
}

extension UIResponder {
  func next<T>(of type: T.Type) -> T? {
    guard let nextValue = self.next else {
      return nil
    }
    guard let result = nextValue as? T else {
      return nextValue.next(of: type.self)
    }
    return result
  }
}

struct NothingView: View {
  @State var showSidebar: Bool = false
  var body: some View {
    Text("app.name")
    if UIDevice.current.userInterfaceIdiom == .pad {
      UIKitShowSidebar(showSidebar: showSidebar)
        .frame(width: 0,height: 0)
        .onAppear {
            showSidebar = true
        }
        .onDisappear {
            showSidebar = false
        }
    }
  }
}
