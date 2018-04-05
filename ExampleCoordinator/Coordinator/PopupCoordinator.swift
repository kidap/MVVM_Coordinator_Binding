//
//  PopupCoordinator.swift
//  ExampleCoordinator
//
//  Created by Karlo Pagtakhan on 3/29/18.
//  Copyright © 2018 kidap. All rights reserved.
//

import UIKit


//kp:in the future can be an actual PopupCoordinator the can be reused
class PopupCoordinator {
    
    //Coordinator Protocol Requirements
    var didFinish: CoordinatorDidFinish?
    var childCoordinators: ChildCoordinatorsDictionary = [:]
    var rootController: UIViewController { return navigationController }
    
    //NavigationControllerCoordinator Protocol Requirements
    var navigationController: UINavigationController = UINavigationController(nibName: nil, bundle: nil)
    var navigationControllerCoordinatorDelegate: NavigationControllerCoordinatorDelegate { return NavigationControllerCoordinatorDelegate(coordinator: self)
    }
    
    // Private variables
    var onClose: ()->()
    
    init(onClose: @escaping ()->()) {
        self.onClose = onClose
        self.navigationController.delegate = navigationControllerCoordinatorDelegate
        self.navigationController.modalPresentationStyle = .formSheet
        self.navigationController.preferredContentSize = CGSize(width: 200, height: 200)
    }
    
    deinit {
        print("☠️deallocing \(self)")
    }
}

//MARK:- Coordinator
extension PopupCoordinator: NavigationControllerCoordinator {
    func start() {
        print("✅ Starting PopupCoordinator")
        showPopup()
    }
}

private extension PopupCoordinator {
    func showPopup() {
        let popupViewModel = PopupViewModel { [unowned self] in
            self.onClose()
        }
        let popupViewController = PopupViewController(viewModel: popupViewModel)
        present(popupViewController, animated: true, completion: nil)
    }
}

