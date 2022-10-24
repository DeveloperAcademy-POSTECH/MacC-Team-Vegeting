//
//  PostDetailViewController.swift
//  Vegeting
//
//  Created by 김원희 on 2022/10/23.
//

import UIKit

class PostDetailViewController: UIViewController {
    
    private lazy var coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "coverImage")
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.text = "남미플랜트랩하고 거북이 먹으러 가요"
        
        return label
    }()
    
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "맛집"
        return label
    }()
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.text = "서울시 동대문구"
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "12월 19일"
        return label
    }()
    
    private lazy var capacityLabel: UILabel = {
        let label = UILabel()
        label.text = "2/4"
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 2
//        stackView.backgroundColor = .blue
        return stackView
    }()
    
    private lazy var contentTextLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "저번에 너무 가고싶엇는데~~ 긴급휴무로 못 가서 너무 아쉬웠어여. 유명 맛집이라던데 갔다가 옆에 있는 거북이까지 갔다 오면 좋을 것 같아요!! 날짜는 10월 내에 토요일 중에 가능한 날짜 맞춰서 다녀오려고 해요~ㅎㅎ 같이 맛난 점심먹어용!"
//        label.backgroundColor = .purple
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupLayout()
        setupNavBar()
    }
    
    private func setupNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .done, target: self, action: #selector(showActionSheet))
        navigationController?.navigationBar.tintColor = .label
    }
    
    private func setupLayout() {
        self.view.addSubview(coverImageView)
        coverImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            coverImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            coverImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            coverImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        self.view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        self.view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        [categoryLabel, locationLabel, dateLabel, capacityLabel].map {
            self.stackView.addArrangedSubviews($0)
//            $0.heightAnchor.constraint(equalTo: $0.widthAnchor, multiplier: 1.0).isActive = true
        }
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        self.view.addSubview(contentTextLabel)
        contentTextLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentTextLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor),
            contentTextLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            contentTextLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            contentTextLabel.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    @objc
    private func showActionSheet() {
        let actionSheet = UIAlertController(title: .none, message: .none, preferredStyle: .actionSheet)
        
        let deletePost = UIAlertAction(title: "게시글 삭제", style: .default) { action in
            //TODO: 게시글 삭제 action 연결
        }
        
        let modifyPost = UIAlertAction(title: "게시글 수정", style: .default) { action in
            //TODO: 게시글 수정 action 연결
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel) { action in
            //TODO: 액션시트 취소 action 연결
        }
        
        [deletePost, modifyPost, cancel].forEach { action in
            actionSheet.addAction(action)
        }
        
        present(actionSheet, animated: true, completion: nil)
    }
}
