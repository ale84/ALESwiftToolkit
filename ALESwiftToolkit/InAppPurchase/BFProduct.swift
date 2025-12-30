//
//  Created by Alessio Orlando on 02/05/18.
//  Copyright © 2025 Alessio Orlando. All rights reserved.
//

import Foundation
import StoreKit

class BFProduct {
    private(set) var skProduct: SKProduct

    var productIdentifier: String {
        skProduct.productIdentifier
    }

    var localizedDescription: String {
        skProduct.localizedDescription
    }

    var localizedTitle: String {
        skProduct.localizedTitle
    }

    var price: NSDecimalNumber {
        skProduct.price
    }

    var priceLocale: Locale {
        skProduct.priceLocale
    }

    init(with product: SKProduct) {
        self.skProduct = product
    }
}

extension BFProduct: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(skProduct)
    }

    static func == (lhs: BFProduct, rhs: BFProduct) -> Bool {
        return lhs.skProduct == rhs.skProduct
    }
}
