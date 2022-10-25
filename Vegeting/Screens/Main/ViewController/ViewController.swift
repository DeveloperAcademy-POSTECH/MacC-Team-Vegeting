//
//  ViewController.swift
//  Vegeting
//
//  Created by 김원희 on 2022/10/20.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "로그인 상태"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        signInChecker()
        setNavigationBar()
    }
    
    private func setNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "로그아웃", style: .done, target: self, action: #selector(didTapSignOut(_:)))
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

