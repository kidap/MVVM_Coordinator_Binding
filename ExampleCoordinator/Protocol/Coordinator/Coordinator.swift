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
    typealias CoordinatorDidFinish = () -> ()
    var rootController: UIViewController { get }
    var didFinish: CoordinatorDidFinish? { get set }
    var childCoordinators: ChildCoordinatorsDictionary { get set }
    
    func start()
    
    // Should not be called on the actual type. This method does not ensure references are kept
    // Use present(_ childCoordinator: Coordinator, animated: Bool, completion: (() -> ())?)
    func unsafePresentChildCoordinator(_ childCoordinator: Coordinator, animated: Bool, completion: (() -> ())?)
}

// Methods that can be called on the actual type
extension Coordinator {
    func present(_ childCoordinator: Coordinator, animated: Bool, completion: (() -> ())?) {
        addChildCoordinator(childCoordinator, animated: animated, completion: completion)
        unsafePresentChildCoordinator(childCoordinator, animated: animated, completion: completion)
    }
    
    func addChildCoordinator(_ childCoordinator: Coordinator, animated: Bool, completion: (() -> ())?) {
        addReference(to: childCoordinator)
        
        childCoordinator.didFinish = { [unowned childCoordinator, unowned self] in
            if let tabBarControllerCoordinator = childCoordinator as? TabBarControllerCoordinator {
                tabBarControllerCoordinator.willFinish(animated: animated)
            }
            
            self.removeReference(from: childCoordinator)
        }
        
        childCoordinator.start()
    }
}

// Methods that SHOULD NOT be called on the actual type
extension Coordinator {
    func unsafePresentChildCoordinator(_ childCoordinator: Coordinator, animated: Bool, completion: (() -> ())?) {
        rootController.present(childCoordinator.rootController, animated: animated, completion: completion)
    }
    
    func addReference(to coordinator: Coordinator) {
        childCoordinators[coordinator.rootController] = coordinator
    }
    
    func removeReference(from coordinator: Coordinator) {
        childCoordinators[coordinator.rootController] = nil
    }
}
