//Base on : https://github.com/apphud/ios-swiftui-subscriptions/blob/master/subscriptions/ProductsStore.swift
import Foundation
import SwiftUI
import Combine
import StoreKit



class ProductsStore : ObservableObject {
    static let shared = ProductsStore()
    
    public static let Premium = "com.jva.apps.ResumeDesigner.premium"
    
    @Published var products: [SKProduct] = []
    @Published var anyString = "123" // little trick to force reload ContentView from PurchaseView by just changing any Published value
    
    func handleUpdateStore(){
        anyString = UUID().uuidString
    }
    
    func initializeProducts(){
        IAPManager.shared.loadProducts() { products in
            self.products = products
        }
    }
}

extension SKProduct {
    var localizedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price)!
    }
}
