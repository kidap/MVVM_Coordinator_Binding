//
//  ChildViewControllerContaining.swift
//  ExampleCoordinator
//
//  Created by Karlo Pagtakhan on 4/5/18.
//  Copyright © 2018 kidap. All rights reserved.
//

import UIKit


protocol ChildViewControllerContaining {
    func addChild(_ vc: UIViewController)
    func place(_ vcView: UIView, in containerView: UIView, belowView: UIView?)
}

extension UIViewController: ChildViewControllerContaining {
    func addChild(_ vc: UIViewController) {
        addChildViewController(vc)
        vc.didMove(toParentViewController: self)
    }
    
    func place(_ vcView: UIView, in containerView: UIView, belowView: UIView? = nil) {
        defer {
            vcView.frame = containerView.bounds
        }
        
        guard let belowView = belowView else {
            containerView.addSubview(vcView)
            return
        }
        
        containerView.insertSubview(vcView, belowSubview: belowView)
    }
}
