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
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "coverImage")
        return imageView
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .vfYellow2
        label.layer.cornerRadius = 15.5
        label.font = .preferredFont(forTextStyle: .subheadline, compatibleWith: .init(legibilityWeight: .bold))
        label.textColor = .vfGray1
        label.textAlignment = .center
        label.layer.masksToBounds = true
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "남미플랜트랩하고 거북이 먹으러 가요"
        label.font = .preferredFont(forTextStyle: .title3)
        return label
    }()
    
    private let informationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 3
        stackView.distribution = .fill
        return stackView
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.text = "서울시 동대문구"
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .gray
        return label
    }()
    
    private let dividerDot: UILabel = {
        let label = UILabel()
        label.text = "·"
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .gray
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "12월 19일"
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .gray
        return label
    }()
    
    private let contentTextLabel: VerticalAlignLabel = {
        let label = VerticalAlignLabel()
        label.numberOfLines = 0
        label.text = "저번에 너무 가고싶엇는데~~ 긴급휴무로 못 가서 너무 아쉬웠어여. 유명 맛집이라던데 갔다가 옆에 있는 거북이까지 갔다 오면 좋을 것 같아요!! 날짜는 10월 내에 토요일 중에 가능한 날짜 맞춰서 다녀오려고 해요~ㅎㅎ 같이 맛난 점심먹어용! 나머지는 긴내용을 채우귀 위함위하다다다다 로렌아킬리나 짱~!!!! 너무너무 좋아요. 한국에서도 콘서트 열어주세요,,,,"
        label.font = .preferredFont(forTextStyle: .callout)
        return label
    }()
    
    private let participantsCapacityLabel: UILabel = {
        let label = UILabel()
        label.text = "참여하는 회원 5/6"
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    
    let profileImages = ["profile1.jpg", "profile2.jpg", "profile3.jpg", "profile4.jpg", "profile5.jpg"]
    let participantsNames = ["거북짱", "내가 올해 수영왕", "양송이좋아", "베프", "고수러버"]
    
    private let profileCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height: 80)
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
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
    
    private var club: Club? = nil {
        didSet {
            DispatchQueue.main.async {
                self.setupLayout()
            }
        }
    }
    
    // MARK: - lifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        configureAddSubviews()
        configureUI()
        configureNavBar()
//        setupLayout()
    }
    
    // MARK: - func
    
    func configure(with data: Club) {
        titleLabel.text = data.clubTitle
        categoryLabel.text = data.clubCategory
        locationLabel.text = data.clubLocation
        contentTextLabel.text = data.clubContent
        participantsCapacityLabel.text = "참여하는 회원" + String(data.participants?.count ?? 0) + "/" + String(data.maxNumberOfPeople)
        
        self.club = data
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        scrollView.showsVerticalScrollIndicator = false
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
        contentView.addSubviews(coverImageView, categoryLabel, titleLabel,
                                 informationStackView, contentTextLabel, participantsCapacityLabel,
                                profileCollectionView, enterButton)
        informationStackView.addArrangedSubviews(locationLabel, dividerDot, dateLabel)
    }
    
    private func setupLayout() {
        
        // MARK: - ScrollView
        
        scrollView.constraint(top: view.safeAreaLayoutGuide.topAnchor,
                              leading: view.safeAreaLayoutGuide.leadingAnchor,
                              bottom: view.bottomAnchor,
                              trailing: view.safeAreaLayoutGuide.trailingAnchor)
        
        contentView.constraint(top: scrollView.contentLayoutGuide.topAnchor,
                               leading: scrollView.contentLayoutGuide.leadingAnchor,
                               bottom: scrollView.contentLayoutGuide.bottomAnchor,
                               trailing: scrollView.contentLayoutGuide.trailingAnchor)
        
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        // MARK: - PostDetail
        
        NSLayoutConstraint.activate([
            coverImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            coverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            coverImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        let width = (categoryLabel.text?.size(withAttributes: [.font : UIFont.preferredFont(forTextStyle: .subheadline)]).width ?? 0) + 40
        
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
            informationStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            informationStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
        ])

        NSLayoutConstraint.activate([
            contentTextLabel.topAnchor.constraint(equalTo: informationStackView.bottomAnchor, constant: 19),
            contentTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            contentTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        ])
        
        NSLayoutConstraint.activate([
            participantsCapacityLabel.topAnchor.constraint(equalTo: contentTextLabel.bottomAnchor, constant: 15),
            participantsCapacityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            profileCollectionView.topAnchor.constraint(equalTo: participantsCapacityLabel.bottomAnchor),
            profileCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            profileCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            profileCollectionView.heightAnchor.constraint(equalToConstant: 115)
        ])
        
        NSLayoutConstraint.activate([
            enterButton.topAnchor.constraint(equalTo: profileCollectionView.bottomAnchor, constant: 15),
            enterButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            enterButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
        ])
    }
    
    @objc
    private func showActionSheet() {
        let actionSheet = UIAlertController(title: .none, message: .none, preferredStyle: .actionSheet)
        
        let deletePostAlertAction = UIAlertAction(title: "게시글 삭제", style: .default) { action in
            //TODO: 게시글 삭제 action 연결
        }
        
        let modifyPostAlertAction = UIAlertAction(title: "게시글 수정", style: .default) { action in
            //TODO: 게시글 수정 action 연결
        }
        
        let cancelAlertAction = UIAlertAction(title: "취소", style: .cancel) { action in
            //TODO: 액션시트 취소 action 연결
        }
        
        [deletePostAlertAction, modifyPostAlertAction, cancelAlertAction].forEach { action in
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
