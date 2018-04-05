//
//  TabBarControllerCoordinator.swift
//  ExampleCoordinator
//
//  Created by Karlo Pagtakhan on 4/5/18.
//  Copyright © 2018 kidap. All rights reserved.
//

import UIKit

//--------------------------------------------------------------------------------
//    TabBarControllerCoordinator
//--------------------------------------------------------------------------------
protocol TabBarControllerCoordinator: Coordinator {
    var tabBarController: UITabBarController { get }
}

// Methods that can be called on the actual type
extension TabBarControllerCoordinator {
    var rootController: UIViewController { return tabBarController }
    
    func add(childCoordinators: [Coordinator]) {
        var viewControllers: [UIViewController] = []
        childCoordinators.forEach { viewControllers.append(add(childCoordinator: $0)) }
        tabBarController.viewControllers = viewControllers
    }
    
    func add(viewControllers: [UIViewController]) {
        tabBarController.viewControllers = viewControllers
    }
}


// Methods that SHOULD NOT be called on the actual type
extension TabBarControllerCoordinator {
    func willFinish(animated: Bool) {
        rootController.dismiss(animated: animated, completion: nil)
    }
}

private extension TabBarControllerCoordinator {
    func add(childCoordinator coordinator: Coordinator) -> UIViewController {
        let childCoordinator = coordinator
        addReference(to: childCoordinator)
        
        childCoordinator.didFinish = { [unowned self] in
            self.didFinish?()
        }
        
        childCoordinator.start()
        return childCoordinator.rootController
    }
}
