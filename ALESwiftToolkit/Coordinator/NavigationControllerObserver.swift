//
//  Created by Alessio Orlando on 03/05/2019.
//  Copyright © 2025 Alessio Orlando. All rights reserved.
//

import UIKit

/// Use this class to observe a navigation controller to be notified when a view controller gets popped out of the navigation stack.
/// Useful for coordinators, to remove any child coordinator that was presenting the popped view controller.
@MainActor
class NavigationControllerObserver: NSObject {
    private(set) var navigationController: UINavigationController
    private(set) var notificationCenter: NotificationCenter

    static var didPopViewControllerNotification: Notification.Name = Notification.Name("com.ale.toolkit.NavigationControllerObserver.didPopViewControllerNotification")

    static var navigationControllerKey = "com.ale.toolkit.NavigationControllerObserver.navigationControllerKey"
    static var poppedViewControllerKey = "com.ale.toolkit.NavigationControllerObserver.poppedViewControllerKey"

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
