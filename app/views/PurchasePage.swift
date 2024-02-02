//
//  PurchasePage.swift
//  ResumeDesigner
//
//  Created by Julien Vanheule on 17/08/2021.
//

import SwiftUI
import StoreKit

struct PurchasePage: View {
    @ObservedObject var appState = AppState.shared
    @ObservedObject var productsStore : ProductsStore = ProductsStore.shared
    @State private var isDisabled : Bool = false
    @State var errorMessage = ""
    
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            
            ScrollView {
                VStack(alignment: .center){
                    Image("premium-icon")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150, height: 150)
                        
                    
                    Text("PRO Version")
                        .font(.title)
                        .bold()
                        .foregroundColor(Color("premium"))
                    Text("Get access to all our features")
                    
                    VStack(spacing: 8) {
                        PurchasePageItem(title: "Unlock all templates")
                        PurchasePageItem(title: "Customize the colors")
                        PurchasePageItem(title: "Removal of the footer link.")
                        PurchasePageItem(title: "Add additional sections")
                        #if targetEnvironment(macCatalyst)
                            PurchasePageItem(title: "HTML Export")
                        #endif
                    }
                    .padding()

                    Text("One-time purchase without subscription")
                        .font(.footnote)
                        .padding(.bottom)
                }.padding()
            }
            
            
            VStack {
                Spacer()
                
                VStack(spacing: 16) {
                    if productsStore.products.count > 0 {
                        ForEach(productsStore.products, id: \.self) { prod in
                            VStack(spacing: 0) {
                                if prod.productIdentifier == ProductsStore.Premium {
                                    PremiumButton(label: String(format: NSLocalizedString("BUY %@", comment: ""), prod.localizedPrice), action: {
                                        self.purchaseProduct(skproduct: prod)
                                    })
                                    .keyboardShortcut(.defaultAction)
                                    .disabled(self.isDisabled || IAPManager.shared.isActive(productIdentifier: prod.productIdentifier))
                                }
                            }
                        }
                    } else {
                        Text("Internet is required.")
                            .foregroundColor(.orange)
                            
                        
                        PremiumButton(label: "Retry", action: {
                            self.productsStore.initializeProducts()
                        })
                    }
                    
                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }
                    
                    Button(action: {
                        self.restorePurchases()
                    }) {
                        Text("Restore purchases")
                    }
                    .disabled(isDisabled)
                    .buttonStyle(.borderless)
                    .tint(Color("premium"))
                    
                }
                .padding(8)
                .padding(.bottom, 20)
                .frame(maxWidth: .infinity)
                .background(VisualEffectView(effect: UIBlurEffect(style: .systemMaterial)))
            }
            
            CloseButton(action: close)
        }.edgesIgnoringSafeArea(.bottom)
    }
    
    func close(){
        appState.displayPurchasePage = false
    }
    
    func restorePurchases(){
        self.errorMessage = ""
        isDisabled = true
        IAPManager.shared.restorePurchases(success: {
            self.isDisabled = false
            self.productsStore.handleUpdateStore()
            self.close()
        }, failure: { error in
            self.isDisabled = false
            self.errorMessage = error?.localizedDescription ?? "Error"
        })
    }
    
    func purchaseProduct(skproduct : SKProduct){
        self.errorMessage = ""
        isDisabled = true
        IAPManager.shared.purchaseProduct(product: skproduct, success: {
            self.isDisabled = false
            self.productsStore.handleUpdateStore()
            self.close()
        }) { (error) in
            self.isDisabled = false
            self.errorMessage = error?.localizedDescription ?? "Error"
        }
    }
}

struct PurchasePage_Previews: PreviewProvider {
    static var previews: some View {
        PurchasePage()
    }
}

struct PremiumButton: View {
    var label: String
    var action : SuccessBlock!
    
    var body: some View {
        Button(action: {
            action()
        }){
            Text(NSLocalizedString(label, comment: "")).padding(.horizontal)
        }
        .controlSize(.large)
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.roundedRectangle)
        .tint(Color("premium"))
    }
}

struct PurchasePageItem: View {
    var title: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            Image(systemName: "checkmark.circle")
                .font(.title)
                .foregroundColor(Color("premium"))
            Text(NSLocalizedString(title, comment: ""))
            Spacer()
        }
    }
}

struct CloseButton : View {
    var action : SuccessBlock!
    let CROSSSIZE = 25.0

    var body: some View {
        Image(systemName: "xmark")
            .foregroundColor(.white)
            .background(
            Circle()
                .fill(Color.gray)
                .frame(width: CROSSSIZE, height: CROSSSIZE)
        )
        .frame(width: CROSSSIZE, height: CROSSSIZE)
        .onTapGesture {
            action()
        }
        .padding()
    }
}
