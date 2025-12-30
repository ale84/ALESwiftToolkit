//
//  Created by Alessio Orlando on 02/05/18.
//  Copyright © 2025 Alessio Orlando. All rights reserved.
//

import Foundation
import StoreKit

typealias ProductIdentifier = String

@MainActor
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
        productsRequest != nil
    }

    private(set) var completionHandlers: [RequestProductsCompletionHandler] = []

    private(set) var productIdentifiers: Set<ProductIdentifier>

    class func canMakePayments() -> Bool {
        SKPaymentQueue.canMakePayments()
    }

    init(with productIds: Set<ProductIdentifier>) {
        self.productIdentifiers = productIds
    }

    func getProducts(_ completion: @escaping RequestProductsCompletionHandler) {
        completionHandlers.append(completion)

        guard !isFetchingProducts else {
            return
        }

        let request = SKProductsRequest(productIdentifiers: productIdentifiers)
        productsRequest = request
        request.delegate = self
        request.start()
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
    nonisolated func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        // Hop to the main actor to mutate main-actor-isolated state and call handlers.
        Task { @MainActor in
            self.products = response.products.map { BFProduct(with: $0) }
            self.products.sort { $0.price.compare($1.price) == .orderedAscending }

            // Take immutable snapshots to avoid capturing self/state later.
            let currentProducts = self.products
            let handlers = self.completionHandlers

            // Clear request state before invoking handlers to avoid re-entrancy issues.
            self.clearRequest()

            // Call handlers on the main actor (no extra dispatch needed).
            handlers.forEach { completion in
                completion(.success(currentProducts))
            }
        }
    }

    nonisolated func request(_ request: SKRequest, didFailWithError error: Error) {
        Task { @MainActor in
            let handlers = self.completionHandlers
            self.clearRequest()
            handlers.forEach { $0(.failure(.productRequestError(detail: error))) }
        }
    }
}
