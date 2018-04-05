//
//  FlowCoordinator.swift
//  ExampleCoordinator
//
//  Created by Karlo Pagtakhan on 3/19/18.
//  Copyright © 2018 kidap. All rights reserved.
//

import UIKit

//--------------------------------------------------------------------------------
//    MAIN COORDINATOR
//--------------------------------------------------------------------------------
class FlowCoordinator {
    
    //Coordinator Protocol Requirements
    var didFinish: CoordinatorDidFinish?
    var childCoordinators: ChildCoordinatorsDictionary = [:]
    
    //NavigationControllerCoordinator Protocol Requirements
    var navigationController: UINavigationController = UINavigationController(nibName: nil, bundle: nil)
    var navigationControllerCoordinatorDelegate: NavigationControllerCoordinatorDelegate { return NavigationControllerCoordinatorDelegate(coordinator: self)
    }

    init() {
        navigationController.delegate = navigationControllerCoordinatorDelegate
    }
    
    deinit {
        print("☠️deallocing \(self)")
    }
}

//MARK:- Coordinator
extension FlowCoordinator: NavigationControllerCoordinator {
    func start() {
        print("✅ Starting FlowCoordinator")
        showMainViewController()
    }
}

//MARK:- Private Methods
private extension FlowCoordinator {
    func showMainViewController() {
        let childCoordinator = MainCoordinator() { [unowned self] in
            self.showDetail()
        }
        push(childCoordinator, animated: true)
    }
    
    func showDetail() {
        let childCoordinator = DetailCoordinator()
        childCoordinator.onClose = { [unowned childCoordinator] in
            childCoordinator.didFinish?()
        }
        push(childCoordinator, animated: true)
    }
}
