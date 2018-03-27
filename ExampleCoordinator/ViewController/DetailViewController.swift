//
//  DetailViewController.swift
//  ExampleCoordinator
//
//  Created by Karlo Pagtakhan on 3/22/18.
//  Copyright © 2018 kidap. All rights reserved.
//

import UIKit
import ReactiveKit

//----------------------------------------------------------------------
//    DETAIL
//----------------------------------------------------------------------

//------------------
// MODEL
//------------------
class DetailViewModel {
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
class DetailViewController: UIViewController {
    @IBOutlet weak var closeButton: UIButton!
    var viewModel: DetailViewModel!
    var disposeBag: DisposeBag = DisposeBag()
    
    convenience init(viewModel: DetailViewModel) {
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
