//
//  NavigationControllerCoordinatorDelegate.swift
//  ExampleCoordinator
//
//  Created by Karlo Pagtakhan on 4/5/18.
//  Copyright © 2018 kidap. All rights reserved.
//

import UIKit

class NavigationControllerCoordinatorDelegate: NSObject, UINavigationControllerDelegate {
    weak var coordinator: NavigationControllerCoordinator?
    
    init(coordinator: NavigationControllerCoordinator) {
        self.coordinator = coordinator
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        
        guard let coordinator = coordinator,
            let fromVC = coordinator.navigationController.transitionCoordinator?.viewController(forKey: .from) else { return }
        guard !navigationController.viewControllers.contains(fromVC) else { return }
        let childCoordinator = coordinator.childCoordinators[fromVC]
        childCoordinator?.didFinish?()
    }
}
