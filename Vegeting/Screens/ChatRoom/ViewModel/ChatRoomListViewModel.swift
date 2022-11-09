//
//  ChatRoomListViewModel.swift
//  Vegeting
//
//  Created by 최동권 on 2022/11/09.
//

import Combine
import Foundation

import FirebaseAuth

final class ChatRoomListViewModel {
    
    var fbUser: FirebaseAuth.User?
    var user: VFUser?
    var cancellables = Set<AnyCancellable>()
    
    init() {
        self.signIn(self)
    }
    @objc
    func signIn(_ sender: Any) {
        AuthManager.shared.signInUser(email: "admintest1@macvegeting.com"
                                      , password: "123456789").sink { completion in
            if case .failure(let error) = completion {
                print(error)
            }
        } receiveValue: { [weak self] user in
            self?.fbUser = user
            self?.requestUserInfo()
        }.store(in: &cancellables)
    }
    
    func requestUserInfo() {
        Task { [weak self] in
            user = await FirebaseManager.shared.requestUser()
            guard let user = user else { return }
            self?.user = user
        }
    }
}
