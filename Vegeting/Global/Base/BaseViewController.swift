//
//  BaseViewController.swift
//  Vegeting
//
//  Created by 최동권 on 2022/10/20.
//

import UIKit

class BaseViewController: UIViewController {
    
    var safeArea: UILayoutGuide {
        return view.safeAreaLayoutGuide
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        configureUI()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setupLayout() {
        // Override Layout
    }
    
    func configureUI() {
        // Override Component
        view.backgroundColor = .backgroundColor
    }
}
