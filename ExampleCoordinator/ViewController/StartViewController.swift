//
//  StartViewController.swift
//  ExampleCoordinator
//
//  Created by Karlo Pagtakhan on 3/22/18.
//  Copyright © 2018 kidap. All rights reserved.
//

import UIKit
import ReactiveKit

//----------------------------------------------------------------------
//    START
//----------------------------------------------------------------------
//------------------
// VIEW MODEL
//------------------
class StartViewModel {
    let onStart: (() -> ())
    let onAbout: (() -> ())
    
    init(onStart: @escaping (() -> ()), onAbout: @escaping (() -> ())) {
        self.onStart = onStart
        self.onAbout = onAbout
    }
    
    deinit {
        print("☠️deallocing \(self)")
    }
}

//------------------
// VIEW CONTROLLER
//------------------
class StartViewController: UIViewController {
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var aboutButton: UIButton!
    var viewModel: StartViewModel!
    var disposeBag: DisposeBag = DisposeBag()
    
    convenience init(viewModel: StartViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.reactive.tap.observeNext(with: viewModel.onStart).dispose(in: disposeBag)
        aboutButton.reactive.tap.observeNext(with: viewModel.onAbout).dispose(in: disposeBag)
    }
    
    deinit {
        print("☠️deallocing \(self)")
        disposeBag.dispose()
    }
}
