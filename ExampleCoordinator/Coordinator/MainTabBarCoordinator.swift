//
//  MainTabBarCoordinator.swift
//  ExampleCoordinator
//
//  Created by Karlo Pagtakhan on 3/23/18.
//  Copyright © 2018 kidap. All rights reserved.
//

import UIKit

//--------------------------------------------------------------------------------
//    TAB COORDINATOR
//--------------------------------------------------------------------------------
class MainTabBarCoordinator {
    
    //Coordinator Protocol Requirements
    var didFinish: (() -> ())?
    var childCoordinators = [UIViewController: Coordinator]()
    var rootController: UIViewController { return tabBarController }
    
    // TabBarControllerCoordinator Protocol Requirements
    let tabBarController: UITabBarController
        
    init() {
        self.tabBarController = UITabBarController(nibName: nil, bundle: nil)
    }
    
    deinit {
        print("☠️deallocing \(self)")
    }
}

//MARK:- Coordinator
extension MainTabBarCoordinator: TabBarControllerCoordinator {
    func start() {
        let flowCoordinator = FlowCoordinator()
        let exitCoordinator = ExitCoordinator()
        
        add(childCoordinators: [flowCoordinator, exitCoordinator])
    }
}
