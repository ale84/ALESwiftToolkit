//
//  Created by Alessio Orlando on 10/06/2019.
//  Copyright © 2025 Bandyer. All rights reserved.
//

import Foundation

extension Coordinator {
    func forwardDeepLinkToChildren(link: DeepLinkType) {
        let deepLinkHandlers: [DeepLinkHandler] = childCoordinators.compactMap { $0 as? DeepLinkHandler }
        deepLinkHandlers.forEach { $0.handleDeepLink(deepLink: link) }
    }
}
