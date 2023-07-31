//
//  Created by Alessio Orlando on 02/05/18.
//  Copyright © 2018 Alessio Orlando. All rights reserved.
//

import Foundation
import StoreKit

class IAPHelper: NSObject {

    enum IAPError: Error {
        case connectionError(detail: Error)
        case paymentCancelled(detail: SKError)
        case paymentInvalid(detail: SKError)
        case paymentNotAllowed(detail: SKError)
        case storeProductNotAvailable(detail: SKError)
        case storeError(detail: SKError)
        case unknown(detail: Error)
        case productRequestError(detail: Error)

        init(with skError: SKError) {
            switch skError.code {
            case .paymentCancelled:
                self = .paymentCancelled(detail: skError)
            case .paymentInvalid:
                self = .paymentInvalid(detail: skError)
            case .paymentNotAllowed:
                self = .paymentNotAllowed(detail: skError)
            case .storeProductNotAvailable:
                self = .storeProductNotAvailable(detail: skError)
            default:
                self = .storeError(detail: skError)
            }
        }
    }

    typealias RequestProductsCompletionHandler = (Result<[BFProduct], IAPError>) -> Void

    var products: [BFProduct] = []

    private var productsRequest: SKProductsRequest?

    private var isFetchingProducts: Bool {
        return productsRequest != nil
    }

    private (set) var completionHandlers: [RequestProductsCompletionHandler] = []

    private (set) var productIdentifiers: Set<String>

    class func canMakePayments() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }

    init(with productIds: Set<String>) {
        self.productIdentifiers = productIds
    }

    func getProducts(_ completion: @escaping RequestProductsCompletionHandler) {
        completionHandlers.append(completion)

        guard !isFetchingProducts else {
            return
        }

        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productsRequest?.delegate = self
        productsRequest?.start()
    }

    func purchaseProduct(_ product: BFProduct) {
        let payment = SKPayment(product: product.skProduct)
        SKPaymentQueue.default().add(payment)
    }

    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }

    private func clearRequest() {
        productsRequest = nil
        completionHandlers.removeAll()
    }
}

extension IAPHelper: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        products =  response.products.map { BFProduct(with: $0) }
        products.sort { $0.price.compare($1.price) == .orderedAscending }
        completionHandlers.forEach { completion in
            DispatchQueue.main.async { completion(.success(self.products)) }
        }
        clearRequest()
    }

    func request(_ request: SKRequest, didFailWithError error: Error) {
        completionHandlers.forEach { $0(.failure(.productRequestError(detail: error))) }
        clearRequest()
    }
}
