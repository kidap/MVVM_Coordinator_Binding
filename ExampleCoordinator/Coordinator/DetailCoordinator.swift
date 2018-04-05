//
//  DetailCoordinator.swift
//  ExampleCoordinator
//
//  Created by Karlo Pagtakhan on 3/22/18.
//  Copyright © 2018 kidap. All rights reserved.
//

import UIKit

//--------------------------------------------------------------------------------
//    DETAIL COORDINATOR
//--------------------------------------------------------------------------------
class DetailCoordinator {
    
    //Coordinator Protocol Requirements
    var rootController: UIViewController
    var childCoordinators: ChildCoordinatorsDictionary = [:]
    var didFinish: CoordinatorDidFinish?
    
    //Public variables
    var onClose: (() -> Void)! {
        didSet {
            guard let detailViewController = rootController as? DetailViewController else { return }
            detailViewController.viewModel.onClose = onClose
        }
    }
    
    init(onClose: (() -> Void)? = nil) {
        let viewModel = DetailViewModel(onClose: onClose ?? {} )
        self.rootController = DetailViewController(viewModel: viewModel)
        self.onClose = onClose
    }
    
    deinit {
        print("☠️deallocing \(self)")
    }
}

//MARK:- Coordinator
extension DetailCoordinator: Coordinator {
    func start() {
        print("✅ Starting DetailCoordinator")
        guard let detailViewController = rootController as? DetailViewController else { return }
        detailViewController.viewModel.onClose = { [unowned self] in
            self.onClose()
        }
    }
}
