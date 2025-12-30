//
//  Created by Alessio Orlando on 20/02/18.
//  Copyright © 2025 Alessio Orlando. All rights reserved.
//

import UIKit

/// The Coordinator protocol
protocol Coordinator: AnyObject {

    /// The array containing any child Coordinators
    var childCoordinators: [Coordinator] { get set }
    var parentCoordinator: Coordinator? { get set }
    func childDidFinish(_ childCoordinator: Coordinator)
}

extension Coordinator {

    /// Add a child coordinator to the parent
    func addChildCoordinator(_ childCoordinator: Coordinator) {
        childCoordinators.append(childCoordinator)
        childCoordinator.parentCoordinator = self
    }

    /// Remove a child coordinator from the parent
    func removeChildCoordinator(_ childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== childCoordinator }
        childCoordinator.parentCoordinator = nil
    }

    func removeAllChildCoordinatorsOfType<T>(_ childType: T) {
        childCoordinators
            .filter { $0 is T }
            .forEach { removeChildCoordinator($0) }
    }

    func childDidFinish(_ childCoordinator: Coordinator) {
        removeChildCoordinator(childCoordinator)
    }
}

// Would be nice to have a root coordinator protocol for coordinators that need to manage and observe a nav controller, but unfortunately @objc cannot be used in protocol extensions, rendering the implementation impossible.

//protocol RootCoordinator: Coordinator {
//    var navigationControllerObserver: NavigationControllerObserver! { get set }
//    func observeNavigationController(_ notification: Notification)
//    func makeNavController() -> UINavigationController
//}
//
//extension RootCoordinator {
//    func makeNavController() -> UINavigationController {
//        let navigationController = UINavigationController()
//
//        //navigationController.navigationBar.prefersLargeTitles = true
//
//        self.navigationControllerObserver = NavigationControllerObserver(with: navigationController)
//        navigationController.delegate = navigationControllerObserver
//
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(observeNavigationController(_:)),
//            name: NavigationControllerObserver.didPopViewControllerNotification,
//            object: navigationControllerObserver)
//        
////        navigationController.tabBarItem = UITabBarItem(
////            title: NSLocalizedString("Results", comment: ""),
////            image: UIImage(named: "Results_tab"),
////            selectedImage: nil)
//        
//        return navigationController
//    }
//}
