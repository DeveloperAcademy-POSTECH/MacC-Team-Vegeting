//
//  File.swift
//  Vegeting
//
//  Created by 최동권 on 2022/11/01.
//

import UIKit

extension UINavigationController: ObservableObject, UIGestureRecognizerDelegate {
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
