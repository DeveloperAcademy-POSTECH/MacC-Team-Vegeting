//
//  UIViewController+Extension.swift
//  Vegeting
//
//  Created by 최동권 on 2022/10/20.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func constraintsActivate(_ constraints: [NSLayoutConstraint]...) {
        for constraint in constraints {
            NSLayoutConstraint.activate(constraint)
        }
    }
    
    func showTabBar() {
        tabBarController?.tabBar.isHidden = false
    }
    
    func hideTabBar() {
        tabBarController?.tabBar.isHidden = true
    }
}
