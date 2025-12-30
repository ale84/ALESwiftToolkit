//
//  Created by Alessio on 28/07/2020
//  Copyright © 2025 Alessio Orlando. All rights reserved.
//


import Foundation

protocol OptionalString {}
extension String: OptionalString {}

extension Optional where Wrapped: OptionalString {
    var isNilOrEmpty: Bool {
        return ((self as? String) ?? "").isEmpty
    }
}
