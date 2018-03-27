//
//  ExitViewController.swift
//  ExampleCoordinator
//
//  Created by Karlo Pagtakhan on 3/25/18.
//  Copyright © 2018 kidap. All rights reserved.
//

import UIKit
import Bond
import ReactiveKit

class ExitViewController: UIViewController {
    @IBOutlet weak var exitButton: UIButton!
    let disposeBag = DisposeBag()
    var onExit: (() -> ())!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Exit"
        exitButton.reactive.tap.observeNext (with: { [weak self] in
            self?.onExit() }).dispose(in: disposeBag)
    }
    
    deinit {
        print("☠️deallocing \(self)")
        disposeBag.dispose()
    }
}
