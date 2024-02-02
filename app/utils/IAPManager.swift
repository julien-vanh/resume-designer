//Based on : https://github.com/apphud/ios-swiftui-subscriptions/blob/master/subscriptions/IAPManager.swift
import StoreKit

public typealias SuccessBlock = () -> Void
public typealias FailureBlock = (Error?) -> Void
public typealias ProductsBlock = ([SKProduct]) -> Void
public typealias ProductIdentifier = String


class IAPManager : NSObject {
    @objc static let shared = IAPManager(productIdentifiers: [ProductsStore.Premium])
    
    private var purchasedProductIdentifiers: Set<ProductIdentifier> = []
    private var productIds : Set<ProductIdentifier> = []
    @objc private(set) var products = [SKProduct]()
    
    private var didLoadsProducts : ProductsBlock?
    private var successBlock : SuccessBlock?
    private var failureBlock : FailureBlock?
    var productsRequest = SKProductsRequest()
    
    
    init(productIdentifiers: Set<ProductIdentifier>) {
        super.init()
        self.productIds = productIdentifiers
        
        for productIdentifier in productIdentifiers {
            let purchased = UserDefaults.standard.bool(forKey: productIdentifier)
            if purchased {
                purchasedProductIdentifiers.insert(productIdentifier)
            }
        }
    }
    
    func loadProducts(callback : @escaping  ProductsBlock){
        SKPaymentQueue.default().add(self)
        self.didLoadsProducts = callback

        productsRequest = SKProductsRequest.init(productIdentifiers: productIds)
        productsRequest.delegate = self
        productsRequest.start()
    }
    
    func isActive(productIdentifier : ProductIdentifier) -> Bool {
        return purchasedProductIdentifiers.contains(productIdentifier)
    }
    
    func purchaseProduct(product : SKProduct, success: @escaping SuccessBlock, failure: @escaping FailureBlock){
        guard SKPaymentQueue.canMakePayments() else {
            return
        }
        guard SKPaymentQueue.default().transactions.last?.transactionState != .purchasing else {
            return
        }
        self.successBlock = success
        self.failureBlock = failure
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    func restorePurchases(success: @escaping SuccessBlock, failure: @escaping FailureBlock){
        self.successBlock = success
        self.failureBlock = failure
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

// MARK:- SKReceipt Refresh Request Delegate
extension IAPManager : SKRequestDelegate {
    
    func requestDidFinish(_ request: SKRequest) {
        if request is SKReceiptRefreshRequest {
            DispatchQueue.main.async {
                self.successBlock?()
                self.cleanUp()
            }
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error){
        if request is SKReceiptRefreshRequest {
            DispatchQueue.main.async {
                self.failureBlock?(error)
                self.cleanUp()
            }
        }
        print("SKRequestDelegate request error: \(error.localizedDescription)")
    }
}

// MARK:- SKProducts Request Delegate
extension IAPManager: SKProductsRequestDelegate {
    
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        products = response.products
        DispatchQueue.main.async {
            if response.products.count > 0 {
                self.didLoadsProducts?(self.products)
                self.didLoadsProducts = nil
            }
        }
    }
}

// MARK:- SKPayment Transaction Observer
extension IAPManager: SKPaymentTransactionObserver {
    
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            switch (transaction.transactionState) {
            case .purchased:
                SKPaymentQueue.default().finishTransaction(transaction)
                print("complete...")
                purchaseSuccedFor(identifier: transaction.payment.productIdentifier)
                break
            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                print("purchase error : \(transaction.error?.localizedDescription ?? "")")
                DispatchQueue.main.async {
                    self.failureBlock?(transaction.error)
                    self.cleanUp()
                }
                break
            case .restored:
                SKPaymentQueue.default().finishTransaction(transaction)
                guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }
                print("restore... \(productIdentifier)")
                purchaseSuccedFor(identifier: productIdentifier)
                break
            case .deferred, .purchasing:
                break
            default:
                break
            }
        }
    }
    
    public func paymentQueue(_ queue: SKPaymentQueue, shouldAddStorePayment payment: SKPayment, for product: SKProduct) -> Bool {
        return !AppState.shared.isPremium
    }
    
    private func purchaseSuccedFor(identifier: String?) {
        guard let identifier = identifier else {
            /*DispatchQueue.main.async {
                self.failureBlock?(error)
                self.cleanUp()
            }*/
            return
        }

        purchasedProductIdentifiers.insert(identifier)
        UserDefaults.standard.set(true, forKey: identifier)
        
        DispatchQueue.main.async {
            if identifier == ProductsStore.Premium {
                AppState.shared.isPremium = true
            }
            self.successBlock?()
            self.cleanUp()
        }
    }
    
    func cleanUp(){
        self.successBlock = nil
        self.failureBlock = nil
    }
}
