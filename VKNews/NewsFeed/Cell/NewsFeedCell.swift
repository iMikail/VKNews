//
//  NewsFeedCell.swift
//  VKNews
//
//  Created by Misha Volkov on 22.03.23.
//

import UIKit

final class NewsFeedCell: UITableViewCell {
    static let reuseId = "NewsFeedCell"

    // MARK: - Views
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    @IBOutlet weak var postLabel: UILabel!

    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var sharesLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!

    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
