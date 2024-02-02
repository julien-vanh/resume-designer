//
//  AppState.swift
//  ResumeDesigner
//
//  Created by Julien Vanheule on 17/08/2021.
//

import Foundation

enum UserDefaultsKeys : String {
    case launchCounter = "launchCounter"
}


class AppState: ObservableObject {
    static let shared = AppState()
    
    @Published var isPremium: Bool
    @Published var displayPurchasePage = false
    
    init(){
        isPremium = IAPManager.shared.isActive(productIdentifier: ProductsStore.Premium)
        ProductsStore.shared.initializeProducts()
    }
}
