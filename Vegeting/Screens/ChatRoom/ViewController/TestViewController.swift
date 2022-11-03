//
//  TestViewController.swift
//  Vegeting
//
//  Created by 최동권 on 2022/11/03.
//

import UIKit

class TestViewController: UIViewController {

    private lazy var testButton: UIButton = {
        let button = UIButton(primaryAction: UIAction { _ in
            self.showHalfModal()
        })
        button.setTitle("테스트버튼", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(testButton)
        testButton.constraint(to: view)
    }
    
    private func showHalfModal() {
        let viewController = ChatRoomProfileViewController()
        viewController.modalPresentationStyle = .pageSheet
        if let sheet = viewController.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        present(viewController, animated: true, completion: nil)
    }
}
