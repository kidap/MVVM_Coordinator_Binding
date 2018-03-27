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
    var rootController: UIViewController
    var childCoordinators = [UIViewController: Coordinator]()
    var didFinish: (() -> ())?
    
    init() {
        let viewModel = DetailViewModel(onClose: {})
        self.rootController = DetailViewController(viewModel: viewModel)
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
            self.didFinish?()
        }
    }
}
