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
class FlowCoordinator: NSObject {
    
    //Coordinator Protocol Requirements
    var didFinish: (() -> ())?
    var childCoordinators = [UIViewController: Coordinator]()
    var rootController: UIViewController { return navigationController }
    
    //NavigationControllerCoordinator Protocol Requirements
    var navigationController: UINavigationController = UINavigationController(nibName: nil, bundle: nil)
    
    override init() {
        super.init()
        navigationController.delegate = self
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
    
    // UINavigationControllerDelegate - required in classes that conform to NavigationControllerCoordinator *boilerplate*
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        navigationControllerTransitioned(navigationController, didShow: viewController, animated: animated)
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
