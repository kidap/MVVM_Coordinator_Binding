//
//  NavigationControllerCoordinator.swift
//  ExampleCoordinator
//
//  Created by Karlo Pagtakhan on 4/5/18.
//  Copyright © 2018 kidap. All rights reserved.
//

import UIKit

//--------------------------------------------------------------------------------
//    NavigationControllerCoordinator
//--------------------------------------------------------------------------------
protocol NavigationControllerCoordinator: Coordinator {
    var navigationController: UINavigationController { get }
    var navigationControllerCoordinatorDelegate: NavigationControllerCoordinatorDelegate { get }
}

// Methods that can be called on the actual type
extension NavigationControllerCoordinator {
    var rootController: UIViewController { return navigationController }
    
    func present(_ viewController: UIViewController, animated: Bool, completion: (() -> ())?) {
        guard let topViewController = navigationController.topViewController else {
            navigationController.viewControllers = [viewController]
            return
        }
        
        topViewController.present(viewController, animated: animated, completion: completion)
    }
    
    func push(_ viewController: UIViewController, animated: Bool) {
        navigationController.pushViewController(viewController, animated: animated)
    }
    
    func pop(_ viewController: UIViewController, animated: Bool) {
        // Adding the guard prevents popping the Coordinator.rootViewController when using the back button
        guard viewController == navigationController.viewControllers.last else { return }
        navigationController.popViewController(animated: animated)
    }
    
    func push(_ childCoordinator: Coordinator, animated: Bool) {
        addReference(to: childCoordinator)
        
        childCoordinator.didFinish = { [unowned childCoordinator, unowned self] in
            self.pop(childCoordinator.rootController, animated: animated)
            self.removeReference(from: childCoordinator)
        }
        
        childCoordinator.start()
        push(childCoordinator.rootController, animated: animated)
    }
    
    func pop(to viewController: UIViewController, animated: Bool) {
        // Adding the guard prevents popping the Coordinator.rootViewController when using the back button
        guard viewController == navigationController.viewControllers.last else { return }
        navigationController.popToViewController(viewController, animated: animated)
    }
}

// Override default implementation
extension NavigationControllerCoordinator {
    func unsafePresentChildCoordinator(_ childCoordinator: Coordinator, animated: Bool, completion: (() -> ())?) {
        present(childCoordinator.rootController, animated: animated, completion: completion)
    }
}
