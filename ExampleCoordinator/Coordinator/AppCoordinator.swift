//
//  AppCoordinator.swift
//  ExampleCoordinator
//
//  Created by Karlo Pagtakhan on 3/22/18.
//  Copyright © 2018 kidap. All rights reserved.
//

import UIKit

//--------------------------------------------------------------------------------
//    APP COORDINATOR
//--------------------------------------------------------------------------------
class AppCoordinator: NSObject {
    
    //Coordinator Protocol Requirements
    var didFinish: (() -> ())?
    var childCoordinators = [UIViewController: Coordinator]()
    var rootController: UIViewController { return navigationController }
    
    // NavigationControllerCoordinator Protocol Requirements
    let navigationController: UINavigationController = UINavigationController(nibName: nil, bundle: nil)
    
    override init() {
        super.init()
        navigationController.delegate = self
    }
    
    deinit {
        print("☠️deallocing \(self)")
    }
}

//MARK:- Coordinator
extension AppCoordinator: NavigationControllerCoordinator {
    func start() {
        print("✅ Starting AppCoordinator")
        showStart()
    }
    
    // UINavigationControllerDelegate - required in classes that conform to NavigationControllerCoordinator *boilerplate*
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        navigationControllerTransitioned(navigationController, didShow: viewController, animated: animated)
    }
}

//MARK:- Private Methods
private extension AppCoordinator {
    func showStart() {
        print("✅ Starting StartViewController")
        let viewModel = StartViewModel(onStart: {[unowned self] in
                self.showPortal()
            }, onAbout: {[unowned self] in
                self.showAbout()
        })
        let startViewController = StartViewController(viewModel: viewModel)
        
        push(startViewController, animated: true)
    }
    
    func showPortal() {
        print("✅ Starting PortalViewController")
        let portalViewController = PortalViewController()
        portalViewController.onOpen = { [unowned self] in
            self.showMain()
        }
        
        push(portalViewController, animated: true)
    }
    
    func showMain() {
        print("✅ Starting MainTabBarCoordinator")
        let childCoordinator = MainTabBarCoordinator()
        present(childCoordinator, animated: true, completion: nil )
    }
    
    func showAbout() {
        print("✅ Starting AboutViewController")
        let aboutViewController = AboutViewController()
        push(aboutViewController, animated: true)
    }
}
