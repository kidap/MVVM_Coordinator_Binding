//
//  MainCoordinator.swift
//  ExampleCoordinator
//
//  Created by Karlo Pagtakhan on 3/27/18.
//  Copyright © 2018 kidap. All rights reserved.
//

import UIKit
import Bond
import ReactiveKit

class MainCoordinator {
    
    //Coordinator Protocol Requirements
    var didFinish: CoordinatorDidFinish?
    var childCoordinators: ChildCoordinatorsDictionary = [:]
    var rootController: UIViewController
    
    // Private variables
    private var disposeBag = DisposeBag()
    var onDetail: (() -> ())
    
    init(onDetail: @escaping (() -> ())) {
        self.onDetail = onDetail
        let viewModel = MainViewModel()
        let mainViewController = MainViewController(viewModel: viewModel)
        self.rootController = mainViewController
    }
    
    deinit {
        print("☠️deallocing \(self)")
        disposeBag.dispose()
    }
}

//MARK:- Coordinator
extension MainCoordinator: Coordinator {
    func start() {
        print("✅ Starting MainCoordinator")
        guard let mainViewController = rootController as? MainViewController else { return }
        
        // BOTTOM LEFT
        let bottomLeftViewModel = BottomLeftViewModel(text: "Hello World", isExpanded: false) { [unowned self] in
            self.onDetail()
        }
        
        // RIGHT
        let rightViewModel = RightViewModel(text: "", onDetail: { [unowned self] in
            self.onDetail()
            }, onPopup: {[unowned self] in
                self.onPopup()
        })
        
        // LEFT
        let leftViewModel = LeftViewModel()
        
        //Bindings
        leftViewModel.state.text.bind(to: rightViewModel.state.text).dispose(in: disposeBag)
        rightViewModel.state.text.bind(to: bottomLeftViewModel.state.text).dispose(in: disposeBag)
        bottomLeftViewModel.state.height.bind(to: mainViewController.viewModel.state.bottomLeftHeight).dispose(in: disposeBag)
        
        let rightVC = RightViewController(viewModel: rightViewModel)
        let bottomLeftVC = BottomLeftViewController(viewModel: bottomLeftViewModel)
        let leftVC = LeftViewController(viewModel: leftViewModel)
        
        mainViewController.addVC(bottomLeftVC, position: .bottomLeft)
        mainViewController.addVC(leftVC, position: .left)
        mainViewController.addVC(rightVC, position: .right)
        
        rootController = mainViewController

        
        testDealloc()
    }
    
    func onPopup() {
        let childCoordinator = PopupCoordinator() {}
        childCoordinator.onClose = { [unowned childCoordinator] in
            childCoordinator.didFinish?()
        }
        addReference(to: childCoordinator)
        
        childCoordinator.didFinish = { [unowned childCoordinator, unowned self] in
            self.rootController.dismiss(animated: true, completion: nil)
            self.removeReference(from: childCoordinator)
        }
        
        childCoordinator.start()
        rootController.present(childCoordinator.rootController, animated: true, completion: nil)
    }
    
    func testDealloc() {
        //        //Test what happens if you dealloc the signal
        //        var test: FakeClass? = FakeClass()
        //        test!.text.bind(to: bottomLeftViewModel.state.text)
        //        test = nil
        //        //Test what happens if you dealloc the observer
        //        var test2: FakeUIElement? = FakeUIElement()
        //        bottomLeftViewModel.state.text.bind(to: test2!.textField.reactive.text)
        //        test2 = nil
    }
}

class FakeClass {
    var text = Observable("Karlo")
    
    deinit {
        print("☠️deallocing \(self)")
    }
}

class FakeUIElement {
    var textField: UITextField = {
        let textField = UITextField(frame: CGRect.zero)
        textField.text = ""
        return textField
    }()
    
    
    deinit {
        print("☠️deallocing \(self)")
    }
}
