//
//  ResumeDesignerApp.swift
//  Shared
//
//  Created by Julien Vanheule on 18/07/2021.
//

import SwiftUI


@main
struct ResumeDesignerApp: App {
    @Environment(\.scenePhase) private var scenePhase
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ResumeList()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            .withHostingWindow { window in
                #if targetEnvironment(macCatalyst)
                if let titlebar = window?.windowScene?.titlebar {
                    titlebar.titleVisibility = .hidden
                    titlebar.toolbar = nil
                }
                #endif
            }

        }.onChange(of: scenePhase) { phase in
            if phase == .background {
                persistenceController.save()
            } else if phase == .active {
                RatingManager.countLaunchAndRate()
            }
        }
    }
}
