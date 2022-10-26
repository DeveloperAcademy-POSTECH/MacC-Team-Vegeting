//
//  PostDetailViewController.swift
//  Vegeting
//
//  Created by 김원희 on 2022/10/23.
//

import UIKit

final class PostDetailViewController: UIViewController {
    
    let profileImages = ["profile1.jpg", "profile2.jpg", "profile3.jpg", "profile4.jpg", "profile5.jpg"]
    let participantsNames = ["거북짱", "내가 올해 수영왕", "양송이좋아", "베프", "고수러버"]
    
    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "coverImage")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "남미플랜트랩하고 거북이 먹으러 가요"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.backgroundColor = .orange
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "맛집"
        label.backgroundColor = .gray
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.text = "서울시 동대문구"
        label.backgroundColor = .gray
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "12월 19일"
        label.backgroundColor = .gray
        return label
    }()
    
    private let capacityLabel: UILabel = {
        let label = UILabel()
        label.text = "2/4"
        label.backgroundColor = .gray
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.isUserInteractionEnabled = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let contentTextLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "저번에 너무 가고싶엇는데~~ 긴급휴무로 못 가서 너무 아쉬웠어여. 유명 맛집이라던데 갔다가 옆에 있는 거북이까지 갔다 오면 좋을 것 같아요!! 날짜는 10월 내에 토요일 중에 가능한 날짜 맞춰서 다녀오려고 해요~ㅎㅎ 같이 맛난 점심먹어용!"
        label.backgroundColor = .purple
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let participantsLabel: UILabel = {
        let label = UILabel()
        label.text = "참여하는 회원"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let profileCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height: 80)
        layout.scrollDirection = .horizontal
        
    
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ProfileCollectionViewCell.self, forCellWithReuseIdentifier: ProfileCollectionViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let enterButton: UIButton = {
        let button = UIButton()
        button.setTitle("참여하기", for: .normal)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileCollectionView.delegate = self
        profileCollectionView.dataSource = self
        
        configureAddSubviews()
        configureUI()
        configureNavBar()
        setupLayout()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
    }
    
    private func configureNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"),
                                                            style: .done, target: self,
                                                            action: #selector(showActionSheet))
        navigationController?.navigationBar.tintColor = .label
    }
    
    private func configureAddSubviews() {
        [coverImageView, titleLabel, stackView, contentTextLabel,
         participantsLabel, profileCollectionView, enterButton].forEach { subView in
            view.addSubview(subView)
        }
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            coverImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            coverImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            coverImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        ])
        
        stackView.addArrangedSubviews(categoryLabel, locationLabel, dateLabel, capacityLabel)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            contentTextLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            contentTextLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            contentTextLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            contentTextLabel.heightAnchor.constraint(equalToConstant: 180)
        ])
        
        NSLayoutConstraint.activate([
            participantsLabel.bottomAnchor.constraint(equalTo: profileCollectionView.topAnchor),
            participantsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            profileCollectionView.bottomAnchor.constraint(equalTo: enterButton.topAnchor, constant: -20),
            profileCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            profileCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            profileCollectionView.heightAnchor.constraint(equalToConstant: 120)
        ])
        
        NSLayoutConstraint.activate([
            enterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            enterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            enterButton.widthAnchor.constraint(equalToConstant: 350),
            enterButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    @objc
    private func showActionSheet() {
        let actionSheet = UIAlertController(title: .none, message: .none, preferredStyle: .actionSheet)
        
        let deletePostAlert = UIAlertAction(title: "게시글 삭제", style: .default) { action in
            //TODO: 게시글 삭제 action 연결
        }
        
        let modifyPostAlert = UIAlertAction(title: "게시글 수정", style: .default) { action in
            //TODO: 게시글 수정 action 연결
        }
        
        let cancelAlert = UIAlertAction(title: "취소", style: .cancel) { action in
            //TODO: 액션시트 취소 action 연결
        }
        
        [deletePostAlert, modifyPostAlert, cancelAlert].forEach { action in
            actionSheet.addAction(action)
        }
        
        present(actionSheet, animated: true, completion: nil)
    }
}

extension PostDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profileImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCollectionViewCell.identifier, for: indexPath)
                as? ProfileCollectionViewCell else { return UICollectionViewCell() }
        cell.profileImage.image = UIImage(named: profileImages[indexPath.row])
        cell.participantsName.text = participantsNames[indexPath.row]
        return cell
    }
}
