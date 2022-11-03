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
        // Do any additional setup after loading the view.
    }
    
    private func showHalfModal() {
        let viewController = ChatRoomProfileViewController()
        viewController.modalPresentationStyle = .pageSheet
        if let sheet = viewController.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }
        present(viewController, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
