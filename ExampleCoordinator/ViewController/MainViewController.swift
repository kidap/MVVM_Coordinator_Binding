//
//  ViewController.swift
//  ExampleCoordinator
//
//  Created by Karlo Pagtakhan on 3/19/18.
//  Copyright © 2018 kidap. All rights reserved.
//

import UIKit
import Bond
import ReactiveKit

//----------------------------------------------------------------------
//    MAIN
//----------------------------------------------------------------------

//------------------
// MODEL
//------------------
class MainViewModel {
    struct State {
        var bottomLeftHeight: Observable<CGFloat>
    }
    
    var state: State
    
    init() {
        self.state = State(bottomLeftHeight: Observable(50.0))
    }
    
    deinit {
        print("☠️deallocing \(self)")
    }
}

//------------------
// VIEW CONTROLLER
//------------------
class MainViewController: UIViewController {
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var bottomLeftView: UIView!
    @IBOutlet weak var bottomLeftViewHeightConstraint: NSLayoutConstraint!
    
    enum ViewPosition {
        case left
        case right
        case bottomLeft
    }
    
    var leftVC: UIViewController!
    var rightVC: UIViewController!
    var bottomLeftVC: UIViewController!
    var viewModel: MainViewModel!
    private var disposeBag: DisposeBag = DisposeBag()
    
    convenience init(viewModel: MainViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Main VC"
        setFramesOfChildVCs()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.viewModel.state.bottomLeftHeight.observeNext { [weak self] (height) in
            guard let layoutIfNeeded = self?.view?.layoutIfNeeded,
                self?.bottomLeftViewHeightConstraint != nil else {
                    return
            }
            self?.bottomLeftViewHeightConstraint.constant = height
            UIView.animate(withDuration: 0.25, animations: layoutIfNeeded)
        }.dispose(in: disposeBag)
    }
    
    deinit {
        print("☠️deallocing \(self)")
        disposeBag.dispose()
    }

    func addVC(_ vc: UIViewController, position: ViewPosition) {
        switch position {
        case .left:
            leftVC = vc
        case .right:
            rightVC = vc
        case .bottomLeft:
            bottomLeftVC = vc
        }
        addChild(vc)
    }
}

private extension MainViewController {
    func setFramesOfChildVCs() {
        place(bottomLeftVC.view, in: bottomLeftView )
        place(leftVC.view, in: leftView, belowView: bottomLeftView)
        place(rightVC.view, in: rightView)
    }
}
