//
//  Created by Alessio Orlando on 21/03/2019.
//  Copyright © 2019 Alessio Orlando. All rights reserved.
//

import UIKit

extension UINavigationController {
    var transitionSourceViewController: UIViewController? {
        transitionCoordinator?.viewController(forKey: .from)
    }

    var transitionDestinationViewController: UIViewController? {
        transitionCoordinator?.viewController(forKey: .to)
    }
}
