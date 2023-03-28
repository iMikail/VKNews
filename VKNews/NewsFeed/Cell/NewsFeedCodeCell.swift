//
//  NewsFeedCodeCell.swift
//  VKNews
//
//  Created by Misha Volkov on 24.03.23.
//

import UIKit

// MARK: - Protocols
protocol NewsFeedCodeCellDelegate: AnyObject {
    func revealPost(for cell: NewsFeedCodeCell)
}

protocol FeedCellViewModel {
    var iconUrlImage: String { get }
    var name: String { get }
    var date: String { get }
    var text: String? { get }
    var likes: String? { get }
    var comments: String? { get }
    var shares: String? { get }
    var views: String? { get }
    var photoAttachments: [FeedCellPhotoAttachmentViewModel] { get }
    var sizes: FeedCellSizes { get }
}

protocol FeedCellPhotoAttachmentViewModel {
    var photoUrlString: String? { get }
    var width: Int { get }
    var height: Int { get }
}

protocol FeedCellSizes {
    var postLabelFrame: CGRect { get }
    var attachmentFrame: CGRect { get }
    var bottomViewFrame: CGRect { get }
    var totalHeigt: CGFloat { get }
    var noreTextButtonFrame: CGRect { get }
}

final class NewsFeedCodeCell: UITableViewCell {
    // MARK: - Constants/variables
    static let reuseId = "NewsFeedCodeCell"

    weak var delegate: NewsFeedCodeCellDelegate?

    // MARK: - Views
    // MARK: First Layer
    private lazy var cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white

        return view
    }()

    // MARK: Second Layer
    private lazy var topView = createView()
    private lazy var postLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = Constants.CellSize.postLabelFont

        return label
    }()
    private lazy var moreTextButtom: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        button.setTitleColor(.systemIndigo, for: .normal)
        button.contentHorizontalAlignment = .left
        button.contentVerticalAlignment = .center
        button.setTitle("Показать полностью...", for: .normal)

        return button
    }()
    private lazy var galleryCollectionView = GalleryCollectionView()
    private lazy var postImageView: WebImageView = {
        let imageView = WebImageView()

        return imageView
    }()
    private lazy var bottomView = UIView()

    // MARK: Third Layer
    // TopViews
    private lazy var iconImageView: WebImageView = {
        let imageView = WebImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 0
        label.textColor = UIColor(red: 44/255, green: 45/255, blue: 46/255, alpha: 1)

        return label
    }()
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.textColor = UIColor(red: 129/255, green: 140/255, blue: 153/255, alpha: 1)

        return label
    }()
    // Bottom views
    private lazy var likesView = createView()
    private lazy var commentsView = createView()
    private lazy var sharesView = createView()
    private lazy var viewsView = createView()

    // MARK: Fourth Layer
    private lazy var likesImageView = createImageView(image: Constants.ImageKey.like.rawValue)
    private lazy var likesLabel = createLabel()
    private lazy var commentsImageView = createImageView(image: Constants.ImageKey.comment.rawValue)
    private lazy var commentsLabel = createLabel()
    private lazy var sharesImageView = createImageView(image: Constants.ImageKey.share.rawValue)
    private lazy var sharesLabel = createLabel()
    private lazy var viewsImageView = createImageView(image: Constants.ImageKey.eye.rawValue)
    private lazy var viewsLabel = createLabel()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear
        selectionStyle = .none

        iconImageView.layer.cornerRadius = Constants.CellSize.topViewHeight / 2
        iconImageView.clipsToBounds = true
        moreTextButtom.addTarget(self, action: #selector(moreTextButtonTouch), for: .touchUpInside)

        cardView.layer.cornerRadius = 10
        cardView.clipsToBounds = true
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Functions
    override func prepareForReuse() {
        iconImageView.set(imageUrl: nil)
        postImageView.set(imageUrl: nil)
    }

    @objc private func moreTextButtonTouch() {
        delegate?.revealPost(for: self)
    }

    func set(viewModel: FeedCellViewModel) {
        iconImageView.set(imageUrl: viewModel.iconUrlImage)
        nameLabel.text = viewModel.name
        dateLabel.text = viewModel.date
        postLabel.text = viewModel.text
        likesLabel.text = viewModel.likes
        commentsLabel.text = viewModel.comments
        sharesLabel.text = viewModel.shares
        viewsLabel.text = viewModel.views

        postLabel.frame = viewModel.sizes.postLabelFrame
        moreTextButtom.frame = viewModel.sizes.noreTextButtonFrame
        bottomView.frame = viewModel.sizes.bottomViewFrame

        if let photoAttachment = viewModel.photoAttachments.first, viewModel.photoAttachments.count == 1 {
            postImageView.set(imageUrl: photoAttachment.photoUrlString)
            postImageView.frame = viewModel.sizes.attachmentFrame
            postImageView.isHidden = false
            galleryCollectionView.isHidden = true
        } else if viewModel.photoAttachments.count > 1 {
            galleryCollectionView.set(photos: viewModel.photoAttachments)
            galleryCollectionView.frame = viewModel.sizes.attachmentFrame
            postImageView.isHidden = true
            galleryCollectionView.isHidden = false
        } else {
            postImageView.isHidden = true
            galleryCollectionView.isHidden = true
        }
    }

    // MARK: - Setup func
    private func setupViews() {
        // firsl Layer
        contentView.addSubview(cardView)
        // second Layer
        cardView.addSubview(topView)
        cardView.addSubview(postLabel)
        cardView.addSubview(moreTextButtom)
        cardView.addSubview(postImageView)
        cardView.addSubview(galleryCollectionView)
        cardView.addSubview(bottomView)
        // third Layer
        topView.addSubview(iconImageView)
        topView.addSubview(nameLabel)
        topView.addSubview(dateLabel)
        bottomView.addSubview(likesView)
        bottomView.addSubview(commentsView)
        bottomView.addSubview(sharesView)
        bottomView.addSubview(viewsView)
        // Fourth layer
        likesView.addSubview(likesImageView)
        likesView.addSubview(likesLabel)
        commentsView.addSubview(commentsImageView)
        commentsView.addSubview(commentsLabel)
        sharesView.addSubview(sharesImageView)
        sharesView.addSubview(sharesLabel)
        viewsView.addSubview(viewsImageView)
        viewsView.addSubview(viewsLabel)
    }

    private func setupConstraints() {
        // First layer
        cardView.fillSuperview(padding: Constants.CellSize.cardInsets)
        // Second Layer
        topView.anchor(top: cardView.topAnchor,
                       leading: cardView.leadingAnchor,
                       bottom: nil,
                       trailing: cardView.trailingAnchor,
                       padding: UIEdgeInsets(top: 8, left: 8, bottom: 666, right: -8),
                       size: CGSize(width: 0, height: Constants.CellSize.topViewHeight))
        // Third Layer
        setupThirdLayerConstraints()
        // Fourth Layer
        helpInFourthLayer(view: likesView, imageView: likesImageView, label: likesLabel)
        helpInFourthLayer(view: commentsView, imageView: commentsImageView, label: commentsLabel)
        helpInFourthLayer(view: sharesView, imageView: sharesImageView, label: sharesLabel)
        helpInFourthLayer(view: viewsView, imageView: viewsImageView, label: viewsLabel)
    }

    private func setupThirdLayerConstraints() {
        // TopView
        iconImageView.anchor(top: topView.topAnchor,
                             leading: topView.leadingAnchor,
                             bottom: nil,
                             trailing: nil,
                             size: CGSize(width: Constants.CellSize.topViewHeight,
                                          height: Constants.CellSize.topViewHeight))
        nameLabel.anchor(top: topView.topAnchor,
                         leading: iconImageView.trailingAnchor,
                         bottom: nil,
                         trailing: topView.trailingAnchor,
                         padding: UIEdgeInsets(top: 2, left: 8, bottom: 666, right: -8),
                         size: CGSize(width: 0, height: Constants.CellSize.topViewHeight / 2 - 2))
        dateLabel.anchor(top: nil,
                         leading: iconImageView.trailingAnchor,
                         bottom: topView.bottomAnchor,
                         trailing: topView.trailingAnchor,
                         padding: UIEdgeInsets(top: 666, left: 8, bottom: -2, right: -8),
                         size: CGSize(width: 0, height: 14))
        // BottomView
        likesView.anchor(top: bottomView.topAnchor,
                         leading: bottomView.leadingAnchor,
                         bottom: nil,
                         trailing: nil,
                         size: CGSize(width: Constants.CellSize.bottomSubViewWidth,
                                      height: Constants.CellSize.bottomSubViewHeight))
        commentsView.anchor(top: likesView.topAnchor,
                            leading: likesView.trailingAnchor,
                            bottom: nil,
                            trailing: nil,
                            size: CGSize(width: Constants.CellSize.bottomSubViewWidth,
                                         height: Constants.CellSize.bottomSubViewHeight))
        sharesView.anchor(top: bottomView.topAnchor,
                          leading: commentsView.trailingAnchor,
                          bottom: nil,
                          trailing: nil,
                          size: CGSize(width: Constants.CellSize.bottomSubViewWidth,
                                       height: Constants.CellSize.bottomSubViewHeight))
        viewsView.anchor(top: bottomView.topAnchor,
                         leading: nil,
                         bottom: nil,
                         trailing: bottomView.trailingAnchor,
                         size: CGSize(width: Constants.CellSize.bottomSubViewWidth,
                                      height: Constants.CellSize.bottomSubViewHeight))

    }

    private func helpInFourthLayer(view: UIView, imageView: UIImageView, label: UILabel) {
        var consts = [NSLayoutConstraint]()

        consts.append(imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor))
        consts.append(imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10))
        consts.append(imageView.widthAnchor.constraint(equalToConstant: Constants.CellSize.bottomSubViewIconSize))
        consts.append(imageView.heightAnchor.constraint(equalToConstant: Constants.CellSize.bottomSubViewIconSize))

        consts.append(label.centerYAnchor.constraint(equalTo: view.centerYAnchor))
        consts.append(label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 4))
        consts.append(label.trailingAnchor.constraint(equalTo: view.trailingAnchor))

        NSLayoutConstraint.activate(consts)
    }

    // MARK: - Create funcs
    private func createView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }

    private func createImageView(image: String) -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: image)

        return imageView
    }

    private func createLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red: 129/255, green: 140/255, blue: 153/255, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.lineBreakMode = .byClipping

        return label
    }
}
