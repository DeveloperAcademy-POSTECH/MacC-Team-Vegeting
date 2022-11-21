//
//  PostDetailViewController.swift
//  Vegeting
//
//  Created by 김원희 on 2022/10/23.
//
import UIKit

public class VerticalAlignLabel: UILabel {
    enum VerticalAlignment {
        case top
        case middle
        case bottom
    }
    
    var verticalAlignment : VerticalAlignment = .top {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override public func textRect(forBounds bounds: CGRect, limitedToNumberOfLines: Int) -> CGRect {
        let rect = super.textRect(forBounds: bounds, limitedToNumberOfLines: limitedToNumberOfLines)
        
        if UIView.userInterfaceLayoutDirection(for: .unspecified) == .rightToLeft {
            switch verticalAlignment {
            case .top:
                return CGRect(x: self.bounds.size.width - rect.size.width, y: bounds.origin.y, width: rect.size.width, height: rect.size.height)
            case .middle:
                return CGRect(x: self.bounds.size.width - rect.size.width, y: bounds.origin.y + (bounds.size.height - rect.size.height) / 2, width: rect.size.width, height: rect.size.height)
            case .bottom:
                return CGRect(x: self.bounds.size.width - rect.size.width, y: bounds.origin.y + (bounds.size.height - rect.size.height), width: rect.size.width, height: rect.size.height)
            }
        } else {
            switch verticalAlignment {
            case .top:
                return CGRect(x: bounds.origin.x, y: bounds.origin.y, width: rect.size.width, height: rect.size.height)
            case .middle:
                return CGRect(x: bounds.origin.x, y: bounds.origin.y + (bounds.size.height - rect.size.height) / 2, width: rect.size.width, height: rect.size.height)
            case .bottom:
                return CGRect(x: bounds.origin.x, y: bounds.origin.y + (bounds.size.height - rect.size.height), width: rect.size.width, height: rect.size.height)
            }
        }
    }
    
    override public func drawText(in rect: CGRect) {
        let r = self.textRect(forBounds: rect, limitedToNumberOfLines: self.numberOfLines)
        super.drawText(in: r)
    }
}

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
    
    private lazy var contentTextLabel: VerticalAlignLabel = {
        let label = VerticalAlignLabel()
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
    let participantsNames = ["거북짱", "내가 올해 수영왕", "양송이좋아", "베프", "고수러버"]
    
    private let profileCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height: 80)
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ProfileCollectionViewCell.self, forCellWithReuseIdentifier: ProfileCollectionViewCell.className)
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    
    private let enterButton: BottomButton = {
        let button = BottomButton()
        button.setTitle("참여하기", for: .normal)
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
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(coverImageView, categoryLabel, titleLabel, datePlaceLabel,
                                contentTextLabel, participantsCapacityLabel, profileCollectionView)
    }
    
    private func setupLayout() {
        scrollView.constraint(top: view.safeAreaLayoutGuide.topAnchor,
                              leading: view.safeAreaLayoutGuide.leadingAnchor,
                              bottom: entryPoint == .mine ? view.bottomAnchor : enterButton.topAnchor,
                              trailing: view.safeAreaLayoutGuide.trailingAnchor,
                              padding: UIEdgeInsets(top: 0, left: 0, bottom: 21, right: 0))
        
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
            profileCollectionView.topAnchor.constraint(equalTo: participantsCapacityLabel.bottomAnchor),
            profileCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            profileCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            profileCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            profileCollectionView.heightAnchor.constraint(equalToConstant: 115)
        ])
        
        if entryPoint == .other {
            setupBottomButtonLayout()
        }
    }
    
    private func setupBottomButtonLayout() {
        view.addSubview(enterButton)
        NSLayoutConstraint.activate([
            enterButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -55),
            enterButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
    }
    
    @objc
    private func showActionSheet() {
        let actionSheet = UIAlertController(title: .none, message: .none, preferredStyle: .actionSheet)
        
        let firstAlertAction: UIAlertAction
        
        let secondAlertAction: UIAlertAction
        
        switch entryPoint {
            
        case .mine:
            firstAlertAction = UIAlertAction(title: "게시글 삭제", style: .destructive, handler: { action in
                // TODO: - 게시글 삭제 코드
            })
            secondAlertAction = UIAlertAction(title: "게시글 수정", style: .default, handler: { action in
                // TODO: - 게시글 수정
            })
        case .other:
            firstAlertAction = UIAlertAction(title: "게시글 신고", style: .default, handler: { action in
                // TODO: - 게시글 신고 코드
            })
            secondAlertAction = UIAlertAction(title: "작성자 차단", style: .default, handler: { action in
                // TODO: - 작성자 차단
            })
        }
        let cancelAlertAction = UIAlertAction(title: "취소", style: .cancel)
        
        [firstAlertAction, secondAlertAction, cancelAlertAction].forEach { action in
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCollectionViewCell.className, for: indexPath)
                as? ProfileCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(with: ParticipantsInfo(profileImage: UIImage(named: profileImages[indexPath.item]), participantsName: participantsNames[indexPath.item]))
        return cell
    }
}
