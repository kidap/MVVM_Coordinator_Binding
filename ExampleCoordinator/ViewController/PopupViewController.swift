//
//  PopupViewController.swift
//  ExampleCoordinator
//
//  Created by Karlo Pagtakhan on 3/29/18.
//  Copyright © 2018 kidap. All rights reserved.
//

import UIKit
import ReactiveKit

//----------------------------------------------------------------------
//    POPUP
//----------------------------------------------------------------------

//------------------
// MODEL
//------------------
class PopupViewModel {
    var onClose: (() -> Void)
    
    init(onClose: @escaping (() -> Void)) {
        self.onClose = onClose
    }
    
    deinit {
        print("☠️deallocing \(self)")
    }
}

//------------------
// VIEW CONTROLLER
//------------------
class PopupViewController: UIViewController {
    @IBOutlet weak var closeButton: UIButton!
    var viewModel: PopupViewModel!
    var disposeBag: DisposeBag = DisposeBag()
    
    convenience init(viewModel: PopupViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
    
    func setupBindings() {
        closeButton.reactive.tap.observeNext(with: viewModel.onClose).dispose(in: disposeBag)
    }
    
    deinit {
        print("☠️deallocing \(self)")
        disposeBag.dispose()
    }
}

