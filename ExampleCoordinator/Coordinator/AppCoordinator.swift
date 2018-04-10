//
//  AppCoordinator.swift
//  ExampleCoordinator
//
//  Created by Karlo Pagtakhan on 3/22/18.
//  Copyright © 2018 kidap. All rights reserved.
//

import UIKit
import CoreData

//--------------------------------------------------------------------------------
//    APP COORDINATOR
//--------------------------------------------------------------------------------
class AppCoordinator {
    
    //Coordinator Protocol Requirements
    var didFinish: CoordinatorDidFinish?
    var childCoordinators: ChildCoordinatorsDictionary = [:]
    
    // NavigationControllerCoordinator Protocol Requirements
    let navigationController: UINavigationController = UINavigationController(nibName: nil, bundle: nil)
    var navigationControllerCoordinatorDelegate: NavigationControllerCoordinatorDelegate { return NavigationControllerCoordinatorDelegate(coordinator: self)
    }
    
    // Private variables
    private let container: NSPersistentContainer
    
    init(container: NSPersistentContainer = CoreDataManager.container) {
        self.container = container
        navigationController.delegate = navigationControllerCoordinatorDelegate
    }
    
    deinit {
        print("☠️deallocing \(self)")
    }
}

//MARK:- Coordinator
extension AppCoordinator: NavigationControllerCoordinator {
    func start() {
        print("✅ Starting AppCoordinator")
        showMain()
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
        childCoordinator.onExit = { [unowned childCoordinator] in
            childCoordinator.didFinish?()
        }
        present(childCoordinator, animated: true, completion: nil )
    }
    
    func showAbout() {
        print("✅ Starting AboutViewController")
        let aboutViewController = AboutViewController()
        push(aboutViewController, animated: true)
    }
}
