//
//  PortalViewController.swift
//  ExampleCoordinator
//
//  Created by Karlo Pagtakhan on 3/26/18.
//  Copyright © 2018 kidap. All rights reserved.
//

import UIKit
import Bond
import ReactiveKit

class PortalViewController: UIViewController {
    @IBOutlet weak var openButton: UIButton!
    let disposeBag = DisposeBag()
    var onOpen: (() -> ())!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Portal"
        openButton.reactive.tap.observeNext (with: { [weak self] in
            self?.onOpen() }).dispose(in: disposeBag)
    }
    
    deinit {
        print("☠️deallocing \(self)")
        disposeBag.dispose()
    }
}

