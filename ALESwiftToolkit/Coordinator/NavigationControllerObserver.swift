//
//  Created by Alessio Orlando on 03/05/2019.
//  Copyright © 2019 Alessio Orlando. All rights reserved.
//

import UIKit

class NavigationControllerObserver: NSObject {
    private(set) var navigationController: UINavigationController
    private(set) var notificationCenter: NotificationCenter

    static var didPopViewControllerNotification: Notification.Name = Notification.Name("com.alessioorlando.benchmark.NavigationControllerObserver.didPopViewControllerNotification")

    static var navigationControllerKey = "com.alessioorlando.benchmark.NavigationControllerObserver.navigationControllerKey"
    static var poppedViewControllerKey = "com.alessioorlando.benchmark.NavigationControllerObserver.poppedViewControllerKey"

    init(with navigationController: UINavigationController,
         notificationCenter: NotificationCenter = NotificationCenter.default) {
        self.navigationController = navigationController
        self.notificationCenter = notificationCenter
        super.init()
        navigationController.delegate = self
    }
}

extension NavigationControllerObserver: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController,
                              didShow viewController: UIViewController,
                              animated: Bool) {
        guard let fromViewController = navigationController.transitionSourceViewController else { return }

        // Check whether our view controller array already contains that view controller. If it does it means we’re pushing a different view controller on top rather than popping it, so exit.
        guard !navigationController.viewControllers.contains(fromViewController) else { return }

        let info = [NavigationControllerObserver.navigationControllerKey: navigationController,
                    NavigationControllerObserver.poppedViewControllerKey: fromViewController]

        notificationCenter.post(name: NavigationControllerObserver.didPopViewControllerNotification,
                                object: self,
                                userInfo: info)
    }
}
