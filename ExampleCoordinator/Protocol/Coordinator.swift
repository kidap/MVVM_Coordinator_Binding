//
//  Coordinator.swift
//  ExampleCoordinator
//
//  Created by Karlo Pagtakhan on 3/27/18.
//  Copyright © 2018 kidap. All rights reserved.
//

import UIKit

//--------------------------------------------------------------------------------
//    Coordinator
//--------------------------------------------------------------------------------
protocol Coordinator: class {
    typealias ChildCoordinatorsDictionary = [UIViewController: Coordinator]
    var rootController: UIViewController { get }
    var childCoordinators: ChildCoordinatorsDictionary { get set }
    var didFinish: (() -> ())? { get set }
    
    func start()
}

extension Coordinator {
    func store(coordinator: Coordinator) {
        childCoordinators[coordinator.rootController] = coordinator
    }
    
    func free(coordinator: Coordinator) {
        childCoordinators[coordinator.rootController] = nil
    }
}

//--------------------------------------------------------------------------------
//    NavigationControllerCoordinator
//--------------------------------------------------------------------------------
protocol NavigationControllerCoordinator: UINavigationControllerDelegate, Coordinator {
    var navigationController: UINavigationController { get }
}

extension NavigationControllerCoordinator {
    func navigationControllerTransitioned(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromVC = navigationController.transitionCoordinator?.viewController(forKey: .from) else { return }
        guard !navigationController.viewControllers.contains(fromVC) else { return }
        let coordinator = childCoordinators[fromVC]
        coordinator?.didFinish?()
    }
    
    func push(_ viewController: UIViewController, animated: Bool) {
        if !didSetInitialViewController(to: viewController) {
            navigationController.pushViewController(viewController, animated: animated)
        }
    }
    
    func present(_ viewController: UIViewController, animated: Bool, completion: (() -> ())?) {
        if !didSetInitialViewController(to: viewController) {
            navigationController.topViewController?.present(viewController, animated: animated, completion: completion)
        }
    }
    
    func pop(_ viewController: UIViewController, animated: Bool) {
        // Adding the if prevents popping the Coordinator.rootViewController when using the back button
        if viewController == navigationController.viewControllers.last {
            navigationController.popViewController(animated: animated)
        }
    }
    
    func push(_ childCoordinator: Coordinator, animated: Bool) {
        store(coordinator: childCoordinator)
        
        childCoordinator.didFinish = { [unowned childCoordinator, unowned self] in
            self.pop(childCoordinator.rootController, animated: true)
            self.free(coordinator: childCoordinator)
        }
        
        childCoordinator.start()
        push(childCoordinator.rootController, animated: animated)
    }
    
    func present(_ childCoordinator: Coordinator, animated: Bool, completion: (() -> ())?) {
        store(coordinator: childCoordinator)
        
        childCoordinator.didFinish = { [unowned childCoordinator, unowned self] in
            self.free(coordinator: childCoordinator)
        }
        
        childCoordinator.start()
        present(childCoordinator.rootController, animated: animated, completion: completion)
    }
}

private extension NavigationControllerCoordinator {
    //Returns true if view controller was set to initial view controller
    func didSetInitialViewController(to viewController: UIViewController) -> Bool {
        guard navigationController.viewControllers.isEmpty else { return false }
        navigationController.viewControllers = [viewController]
        return true
    }
}

//--------------------------------------------------------------------------------
//    TabBarControllerCoordinator
//--------------------------------------------------------------------------------
protocol TabBarControllerCoordinator: Coordinator {
    var tabBarController: UITabBarController { get }
}

extension TabBarControllerCoordinator {
    func willFinish() {
        freeAllChildCoordinators()
        rootController.dismiss(animated: true, completion: nil)
    }
    
    func freeAllChildCoordinators() {
        childCoordinators.forEach { childCoordinators[$0.key] = nil }
    }
    
    func add(childCoordinators: [Coordinator]) {
        var viewControllers: [UIViewController] = []
        childCoordinators.forEach { viewControllers.append(add(childCoordinator: $0)) }
        tabBarController.viewControllers = viewControllers
    }
}

private extension TabBarControllerCoordinator {
    func add(childCoordinator coordinator: Coordinator) -> UIViewController {
        let childCoordinator = coordinator
        store(coordinator: childCoordinator)
        
        childCoordinator.didFinish = { [unowned self] in
            self.willFinish()
            self.didFinish?()
        }
        
        childCoordinator.start()
        return childCoordinator.rootController
    }
}
