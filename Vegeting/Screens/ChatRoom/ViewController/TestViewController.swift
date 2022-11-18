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
        let viewController = ProfileHalfModalViewController()
        viewController.modalPresentationStyle = .pageSheet
        if let sheet = viewController.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = false
        }
        
        let modalModel = ModalModel(nickname: "내가 짱이얌",
                                    vegetarianStep: "플렉시테리언",
                                    ageGroup: "20대",
                                    location: "포항시 남구",
                                    gender: "여성",
                                    introduction: "사람을 좋아하고, 자연을 사랑하는 플렉시테리언입니다. 이곳에서 소중한 인연 많이 만들어갔으면 좋겠어요.")
        
        
        viewController.configure(with: modalModel)
        
        present(viewController, animated: true, completion: nil)
    }
    
}
