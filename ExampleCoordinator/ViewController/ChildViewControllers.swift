//
//  ChildViewControllers.swift
//  ExampleCoordinator
//
//  Created by Karlo Pagtakhan on 3/22/18.
//  Copyright © 2018 kidap. All rights reserved.
//

import UIKit
import Bond
import ReactiveKit

//----------------------------------------------------------------------
//    LEFT
//----------------------------------------------------------------------

//------------------
// MODEL
//------------------
class LeftViewModel {
    struct State {
        var text: Observable<String?>
    }
    
    var state: State = State(text: Observable("Hello World"))
    
    deinit {
        print("☠️deallocing \(self)")
    }
}

//------------------
// VIEW CONTROLLER
//------------------
class LeftViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    var viewModel: LeftViewModel!
    private var disposeBag: DisposeBag = DisposeBag()
    
    convenience init(viewModel: LeftViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
    
    func setupBindings() {
        textField.reactive.text.bind(to: viewModel.state.text).dispose(in: disposeBag)
    }
    
    deinit {
        print("☠️deallocing \(self)")
        disposeBag.dispose()
    }
}

//----------------------------------------------------------------------
//    RIGHT
//----------------------------------------------------------------------

//------------------
// VIEW MODEL
//------------------
class RightViewModel {
    struct State {
        var text: Observable<String?>
    }
    
    var state: State
    var onDetail: (() -> ())
    var onPopup: (() -> ())
    
    init(text: String, onDetail: @escaping () -> (), onPopup: @escaping () -> ()) {
        self.state = State(text: Observable(text))
        self.onDetail = onDetail
        self.onPopup = onPopup
    }
    
    deinit {
        print("☠️deallocing \(self)")
    }
}

//------------------
// VIEW CONTROLLER
//------------------
class RightViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var showDetailButton: UIButton!
    @IBOutlet weak var showPopupButton: UIButton!
    var viewModel: RightViewModel!
    private var disposeBag: DisposeBag = DisposeBag()
    
    convenience init(viewModel: RightViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
    
    func setupBindings() {
        viewModel.state.text.bind(to: label.reactive.text).dispose(in: disposeBag)
        showDetailButton.reactive.tap.observeNext(with: viewModel.onDetail).dispose(in: disposeBag)
        showPopupButton.reactive.tap.observeNext(with: viewModel.onPopup).dispose(in: disposeBag)
    }
    
    deinit {
        print("☠️deallocing \(self)")
        disposeBag.dispose()
    }
}

//----------------------------------------------------------------------
//    BOTTOM LEFT
//----------------------------------------------------------------------

//------------------
// MODEL
//------------------
class BottomLeftViewModel {
    let collapseTitle = "Collapse"
    let expandTitle = "Expand"
    let collapseHeight = CGFloat(50)
    let expandHeight = CGFloat(100)
    
    struct State {
        var text: Observable<String?>
        var isExpanded: Observable<Bool>
        var expandButtonTitle: Observable<String?>
        var height: Observable<CGFloat>
    }
    var state: State
    let onDetail: (() -> ())
    
    init(text: String, isExpanded: Bool, onDetail: @escaping () -> ()) {
        self.state = State(text: Observable(text), isExpanded: Observable(isExpanded), expandButtonTitle: Observable(expandTitle), height: Observable(collapseHeight))
        self.onDetail = onDetail
    }
    
    func toggleViewSize() {
        state.isExpanded.value = !state.isExpanded.value
        state.expandButtonTitle.value = state.isExpanded.value ? collapseTitle : expandTitle
        state.height.value = state.isExpanded.value ? expandHeight : collapseHeight
    }
    
    deinit {
        print("☠️deallocing \(self)")
    }
}

//------------------
// VIEW CONTROLLER
//------------------
class BottomLeftViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var expandButton: UIButton!
    @IBOutlet weak var showDetailButton: UIButton!
    var viewModel: BottomLeftViewModel!
    private var disposeBag: DisposeBag = DisposeBag()
    
    convenience init(viewModel: BottomLeftViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
    
    func setupBindings() {
        expandButton.reactive.tap.observeNext(with: viewModel.toggleViewSize).dispose(in: disposeBag)
        showDetailButton.reactive.tap.observeNext(with: viewModel.onDetail).dispose(in: disposeBag)
        viewModel.state.text.bind(to: label).dispose(in: disposeBag)
        viewModel.state.expandButtonTitle.bind(to: expandButton.reactive.title).dispose(in: disposeBag)
    }
    
    deinit {
        print("☠️deallocing \(self)")
        disposeBag.dispose()
    }
}
