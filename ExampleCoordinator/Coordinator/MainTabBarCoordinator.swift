//
//  MainTabBarCoordinator.swift
//  ExampleCoordinator
//
//  Created by Karlo Pagtakhan on 3/23/18.
//  Copyright © 2018 kidap. All rights reserved.
//

import UIKit
import CoreData

//--------------------------------------------------------------------------------
//    TAB COORDINATOR
//--------------------------------------------------------------------------------
class MainTabBarCoordinator {
    
    //Coordinator Protocol Requirements
    var didFinish: CoordinatorDidFinish?
    var childCoordinators: ChildCoordinatorsDictionary = [:]
    
    // TabBarControllerCoordinator Protocol Requirements
    let tabBarController: UITabBarController = UITabBarController(nibName: nil, bundle: nil)
    
    // Public variables
    var onExit: (()->())!
    
    // Private variables
    private let container: NSPersistentContainer
    
    init(container: NSPersistentContainer = CoreDataManager.container) {
        self.container = container
    }
    
    deinit {
        print("☠️deallocing \(self)")
    }
}

//MARK:- Coordinator
extension MainTabBarCoordinator: TabBarControllerCoordinator {
    func start() {
        let flowCoordinator = FlowCoordinator()
        let exitCoordinator = ExitCoordinator() { [unowned self] in
            self.onExit()
        }
        
        add(childCoordinators: [flowCoordinator, exitCoordinator])
    }
}
