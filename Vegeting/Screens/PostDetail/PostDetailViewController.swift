//
//  PostDetailViewController.swift
//  Vegeting
//
//  Created by 김원희 on 2022/10/23.
//
import UIKit

final class PostDetailViewController: UIViewController {
    
    // MARK: - properties
    
    enum EntryPoint {
        case mine
        case other
    }
    
    private var club: Club
    private let entryPoint: EntryPoint
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private lazy var coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        guard let url = self.club.coverImageURL else {
            imageView.image = UIImage(named: "coverImage")
            return imageView
        }
        Task { [weak self] in
            FirebaseStorageManager.downloadImage(url: url) { image in
                imageView.image = image
            }
        }
        return imageView
    }()
    
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.text = club.clubCategory
        label.backgroundColor = .vfYellow2
        label.layer.cornerRadius = 15.5
        label.font = .preferredFont(forTextStyle: .subheadline, compatibleWith: .init(legibilityWeight: .bold))
        label.textColor = .vfGray1
        label.textAlignment = .center
        label.layer.masksToBounds = true
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = club.clubTitle
        label.font = .preferredFont(forTextStyle: .title3, compatibleWith: .init(legibilityWeight: .bold))
        return label
    }()
    
    private lazy var datePlaceLabel: UILabel = {
        let label = UILabel()
        let place = club.placeToMeet
        let date = club.dateToMeet.toString(format: "M월 d일")
        label.text = "\(place)ㆍ\(date)"
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .gray
        return label
    }()
    
    private lazy var contentTextLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = club.clubContent
        label.font = .preferredFont(forTextStyle: .callout)
        return label
    }()
    
    private lazy var participantsCapacityLabel: UILabel = {
        let label = UILabel()
        let participatedNum = club.participants?.count
        label.text = "참여하는 회원 \(participatedNum?.description ?? "1")/\(club.maxNumberOfPeople)"
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    
    let profileImages = ["profile1.jpg", "profile2.jpg", "profile3.jpg", "profile4.jpg", "profile5.jpg"]
    
    private let profileCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height: 125)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ProfileCollectionViewCell.self, forCellWithReuseIdentifier: ProfileCollectionViewCell.className)
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    
    private lazy var enterButton: BottomButton = {
        let button = BottomButton()
        button.setTitle("참여하기", for: .normal)
        button.addTarget(self, action: #selector(enterButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - init
    
    init(club: Club, entryPoint: EntryPoint) {
        self.club = club
        self.entryPoint = entryPoint
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - lifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        configureAddSubviews()
        configureUI()
        configureNavBar()
        setupEnterButtonUI()
        setupLayout()
    }
    
    // MARK: - func
    
    private func configureUI() {
        view.backgroundColor = .white
    }
    
    private func configureNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"),
                                                            style: .done, target: self,
                                                            action: #selector(showActionSheet))
        navigationController?.navigationBar.tintColor = .label
    }
    
    private func configureCollectionView() {
        profileCollectionView.delegate = self
        profileCollectionView.dataSource = self
    }
    
    private func configureAddSubviews() {
        view.addSubviews(scrollView, enterButton)
        scrollView.addSubviews(contentView)
        contentView.addSubviews(coverImageView, categoryLabel, titleLabel, datePlaceLabel,
                                contentTextLabel, participantsCapacityLabel, profileCollectionView)
    }
    
    private func setupLayout() {
        scrollView.constraint(top: view.safeAreaLayoutGuide.topAnchor,
                              leading: view.safeAreaLayoutGuide.leadingAnchor,
                              bottom: enterButton.topAnchor,
                              trailing: view.safeAreaLayoutGuide.trailingAnchor,
                              padding: UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0))
        
        contentView.constraint(top: scrollView.contentLayoutGuide.topAnchor,
                               leading: scrollView.contentLayoutGuide.leadingAnchor,
                               bottom: scrollView.contentLayoutGuide.bottomAnchor,
                               trailing: scrollView.contentLayoutGuide.trailingAnchor)
        
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        NSLayoutConstraint.activate([
            coverImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            coverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            coverImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        let width = club.clubCategory.size(withAttributes: [.font : UIFont.preferredFont(forTextStyle: .subheadline)]).width + 40
        
        NSLayoutConstraint.activate([
            categoryLabel.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 15),
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            categoryLabel.widthAnchor.constraint(equalToConstant: width),
            categoryLabel.heightAnchor.constraint(equalToConstant: 31)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
        ])
        
        NSLayoutConstraint.activate([
            datePlaceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            datePlaceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            contentTextLabel.topAnchor.constraint(equalTo: datePlaceLabel.bottomAnchor, constant: 19),
            contentTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            contentTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        ])
        
        NSLayoutConstraint.activate([
            participantsCapacityLabel.topAnchor.constraint(equalTo: contentTextLabel.bottomAnchor, constant: 60),
            participantsCapacityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            profileCollectionView.topAnchor.constraint(equalTo: participantsCapacityLabel.bottomAnchor, constant: 15),
            profileCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            profileCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            profileCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            profileCollectionView.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        NSLayoutConstraint.activate([
            enterButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -55),
            enterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    private func setupEnterButtonUI() {
        if entryPoint == .mine {
            enterButton.isEnabled = false
        }
    }
    
    @objc
    private func enterButtonTapped() {
        showParticipateHalfModal()
        
    }
    
    private func showParticipateHalfModal() {
        let viewController = ParticipateHalfViewController(club: self.club)
        viewController.delegate = self
        viewController.modalPresentationStyle = .pageSheet
        if let sheet = viewController.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = false
        }
        present(viewController, animated: true, completion: nil)
    }
    
    @objc
    private func showActionSheet() {
        let actionSheet = UIAlertController(title: .none, message: .none, preferredStyle: .actionSheet)
        let firstAlertAction: UIAlertAction
        let secondAlertAction: UIAlertAction
        
        switch entryPoint {
        case .mine:
            firstAlertAction = UIAlertAction(title: "게시글 삭제", style: .destructive, handler: { [weak self] _ in
                self?.makeRequestAlert(title: "게시글을 삭제하시겠습니까?",
                                      message: "게시글이 삭제되어도,\n채팅방은 사라지지 않습니다.",
                                      okTitle: "삭제",
                                      cancelTitle: "취소") { okAction in
                    // TODO: - 삭제 코드
                }
            })
            
            secondAlertAction = UIAlertAction(title: "게시글 수정", style: .default, handler: { action in
                // TODO: - 게시글 수정
                let viewController = FirstCreateGroupViewController(entryPoint: .revise, club: self.club)
                viewController.configure(with: self.club)
                self.navigationController?.pushViewController(viewController, animated: true)
            })
            
        case .other:
            firstAlertAction = UIAlertAction(title: "게시글 신고", style: .default, handler: { [weak self] _ in
                self?.makeRequestAlert(title: "게시글을 신고하시겠습니까?",
                                      message: "",
                                      okTitle: "신고",
                                      cancelTitle: "취소") { okAction in
                    // TODO: - 신고 코드
                }
            })
            
            secondAlertAction = UIAlertAction(title: "작성자 차단", style: .default, handler: { [weak self] _ in
                self?.makeRequestAlert(title: "사용자 차단",
                                      message: "해당 사용자가 작성한\n모임 모집글을 볼 수 없게 됩니다.",
                                      okTitle: "차단",
                                      cancelTitle: "취소") { okAction in
                    // TODO: - 차단 코드
                }
            })
        }
        
        let cancelAlertAction = UIAlertAction(title: "취소", style: .cancel)
        
        [firstAlertAction, secondAlertAction, cancelAlertAction].forEach { action in
            actionSheet.addAction(action)
        }
        present(actionSheet, animated: true, completion: nil)
    }
}

extension PostDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return club.participants?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCollectionViewCell.className, for: indexPath)
                as? ProfileCollectionViewCell else { return UICollectionViewCell() }
        
        let isHost = self.club.hostID == club.participants?[indexPath.item].userID
        let participant = ParticipantMinimum(profileImage: UIImage(named: profileImages[indexPath.item]) ?? UIImage(),
                                                    participantsName: club.participants?[indexPath.item].name ?? "",
                                                    isHost: isHost)
        cell.configure(with: participant)
        return cell
    }
}

extension PostDetailViewController:  UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let participant = club.participants?[indexPath.item] else { return }
        
        showProfileHalfModal(of: participant)
    }
    
    private func showProfileHalfModal(of user: Participant) {
        
        let viewController = ProfileHalfModalViewController()
        viewController.modalPresentationStyle = .pageSheet
        if let sheet = viewController.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = false
        }
        viewController.configure(with: user)
        present(viewController, animated: true, completion: nil)
    }
}

extension PostDetailViewController: ParticipateHalfViewControllerDelegate {
    func navigateChatRoom() {
        let viewController = ChatRoomViewController()
        let participatedChatRoom = ParticipatedChatRoom(chatID: club.chatID,
                                                        chatName: club.clubTitle,
                                                        imageURL: club.coverImageURL?.description)
        guard let user = AuthManager.shared.getCurrentUser() else { return }
        viewController.configureViewModel(participatedChatRoom: participatedChatRoom, user: user)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

