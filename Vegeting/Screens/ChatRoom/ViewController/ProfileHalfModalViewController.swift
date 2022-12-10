//
//  ChatRoomProfileViewController.swift
//  Vegeting
//
//  Created by 최동권 on 2022/11/03.
//

import UIKit

struct ModalModel {
    let image: UIImage
    let nickname: String
    let vegetarianStep: String
    let ageGroup: String
    let location: String
    let gender: String
    let introduction: String
}

protocol ProfileHalfModalViewControllerDelgate: AnyObject {
    func showReportViewController(user: Participant)
}

final class ProfileHalfModalViewController: UIViewController {
    
    // MARK: - properties
    
    private lazy var reportButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "verticalEllipsis"), for: .normal)
        button.addTarget(self, action: #selector(showActionSheet), for: .touchUpInside)
        return button
    }()
    
    private let profileView = ProfileView()
    private var participant: Participant? = nil
    weak var delegate: ProfileHalfModalViewControllerDelgate?
    // MARK: - lifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        configureUI()
    }
    
    // MARK: - func
    
    private func setupLayout() {
        view.addSubviews(reportButton,
                         profileView)
        reportButton.constraint(top: view.topAnchor,
                                trailing: view.trailingAnchor,
                                padding: UIEdgeInsets(top: 25, left: 0, bottom: 0, right: 24))
        reportButton.constraint(.widthAnchor, constant: 30)
        reportButton.constraint(.heightAnchor, constant: 30)

        NSLayoutConstraint(item: view as Any,
                           attribute: .centerY,
                           relatedBy: .equal,
                           toItem: profileView,
                           attribute: .centerY,
                           multiplier: 1.0,
                           constant: 0).isActive = true
        
        profileView.constraint(leading: view.leadingAnchor,
                               trailing: view.trailingAnchor)
    }
    
    private func configureUI() {
        view.backgroundColor = .white
    }
    
    @objc
    private func showActionSheet() {
        let alert = UIAlertController(title: .none, message: .none, preferredStyle: .actionSheet)
        
        let userBlockAction = UIAlertAction(title: "사용자 차단", style: .default) { action in
            DispatchQueue.main.async {
                self.dismiss(animated: true)
            }
            guard let participant = self.participant else { return }
            self.delegate?.showReportViewController(user: participant)
        }
        
        let cancelAlertAction = UIAlertAction(title: "취소", style: .cancel) { action in
            //
        }
        
        [userBlockAction, cancelAlertAction].forEach { action in
            alert.addAction(action)
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    func configure(with data: Participant) {
        profileView.configure(with: data)
        self.participant = data
    }
}
