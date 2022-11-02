//
//  ViewController.swift
//  Vegeting
//
//  Created by 김원희 on 2022/10/20.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    
    var test: Int = 0
    var user: VFUser?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "로그인 상태"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        
        dataLoad()
    }
    private func dataLoad() {
        Task {
            user = await FirebaseManager.shared.requestUser()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        signInChecker()
        setNavigationBar()
    }
    
    private func setNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "로그아웃", style: .done, target: self, action: #selector(didTapSignOut(_:)))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "게시글쓰기", style: .done, target: self, action: #selector(didTapWrite(_:)))
    }
    
    @objc func didTapWrite(_ sender: Any) {
        
        guard let user = user else { return }
        
        let club = Club(clubID: nil, chatID: nil, clubTitle: "비건 뼤스타 가까요 \(test)", clubCategory: "맛집", hostID: nil, participants: nil, createdAt: Date(), maxNumberOfPeople: 3)
        let chat = Chat(chatRoomID: nil, clubID: nil, chatRoomName: "비건 페스타 단톡", participants: nil, messages: nil, coverImageURL: nil)
        FirebaseManager.shared.requestPost(user: user, club: club, chat: chat)
        test += 1
        
    }
    @objc func didTapSignOut(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            signInChecker()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func signInChecker() {
        if Auth.auth().currentUser == nil {
            let SignInViewController = UINavigationController(rootViewController: SignInViewController())
            SignInViewController.modalPresentationStyle = .fullScreen
            present(SignInViewController, animated: true)
        } else {
            print(Auth.auth().currentUser?.uid)
        }
        
    }
    
}

