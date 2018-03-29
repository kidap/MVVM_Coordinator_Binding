//
//  PopupCoordinator.swift
//  ExampleCoordinator
//
//  Created by Karlo Pagtakhan on 3/29/18.
//  Copyright © 2018 kidap. All rights reserved.
//

import UIKit

class PopupCoordinator: NSObject {
    
    //Coordinator Protocol Requirements
    var didFinish: (() -> ())?
    var childCoordinators = [UIViewController: Coordinator]()
    var rootController: UIViewController { return navigationController }
    
    //NavigationControllerCoordinator Protocol Requirements
    var navigationController: UINavigationController = UINavigationController(nibName: nil, bundle: nil)
    
    // Private variables
    var onClose: ()->()
    
    init(onClose: @escaping ()->()) {
        self.onClose = onClose
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
    
    // UINavigationControllerDelegate - required in classes that conform to NavigationControllerCoordinator *boilerplate*
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        navigationControllerTransitioned(navigationController, didShow: viewController, animated: animated)
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

