//
//  ExitCoordinator.swift
//  ExampleCoordinator
//
//  Created by Karlo Pagtakhan on 3/25/18.
//  Copyright © 2018 kidap. All rights reserved.
//

import UIKit

class ExitCoordinator: NSObject {
    
    //Coordinator Protocol Requirements
    var didFinish: (() -> ())?
    var childCoordinators = [UIViewController: Coordinator]()
    var rootController: UIViewController
    
    override init() {
        self.rootController = ExitViewController()
        super.init()
    }
    
    deinit {
        print("☠️deallocing \(self)")
    }
}

//MARK:- Coordinator
extension ExitCoordinator: Coordinator {
    func start() {
        print("✅ Starting ExitCoordinator")
        guard let viewController = rootController as? ExitViewController else { return }
        viewController.onExit = { [weak self] in
            self?.didFinish?()
            
        }
    }
}
