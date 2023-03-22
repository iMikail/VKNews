//
//  NewsFeedCell.swift
//  VKNews
//
//  Created by Misha Volkov on 22.03.23.
//

import UIKit

protocol FeedCellViewModel {
    var iconUrlImage: String { get }
    var name: String { get }
    var date: String { get }
    var text: String? { get }
    var likes: String? { get }
    var comments: String? { get }
    var shares: String? { get }
    var views: String? { get }
    var photoAttachment: FeedCellPhotoAttachmentViewModel? { get }
}

protocol FeedCellPhotoAttachmentViewModel {
    var photoUrlString: String? { get }
    var width: Int { get }
    var height: Int { get }
}

final class NewsFeedCell: UITableViewCell {
    static let reuseId = "NewsFeedCell"

    // MARK: - Views
    @IBOutlet weak var cardView: UIView!

    @IBOutlet weak var iconImageView: WebImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var postImageView: WebImageView!

    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var sharesLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        iconImageView.layer.cornerRadius = iconImageView.frame.height / 2
        iconImageView.clipsToBounds = true

        cardView.layer.cornerRadius = 10
        cardView.clipsToBounds = true
        backgroundColor = .clear
        selectionStyle = .none
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

        if let photoAttachment = viewModel.photoAttachment {
            postImageView.set(imageUrl: photoAttachment.photoUrlString)
            postImageView.isHidden = false
        } else {
            postImageView.isHidden = true
        }
    }
}
