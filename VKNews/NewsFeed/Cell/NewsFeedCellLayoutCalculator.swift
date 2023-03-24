//
//  NewsFeedCellLayoutCalculator.swift
//  VKNews
//
//  Created by Misha Volkov on 24.03.23.
//

import UIKit

protocol FeedCellLayoutCalculatorProtocol {
    func sizes(postText: String?, photoAttachment: FeedCellPhotoAttachmentViewModel?) -> FeedCellSizes
}

struct Sizes: FeedCellSizes {
    var postLabelFrame: CGRect
    var attachmentFrame: CGRect
    var bottomViewFrame: CGRect
    var totalHeigt: CGFloat
}

final class NewsFeedCellLayoutCalculator: FeedCellLayoutCalculatorProtocol {
    private let screenWidth: CGFloat

    init(screenWidth: CGFloat = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)) {
        self.screenWidth = screenWidth
    }

    func sizes(postText: String?, photoAttachment: FeedCellPhotoAttachmentViewModel?) -> FeedCellSizes {
        let cardViewWidth = screenWidth - Constants.CellSize.cardInsets.left - Constants.CellSize.cardInsets.right

        // work with postLabelFrame
        var postLabelFrame = CGRect(origin: CGPoint(x: Constants.CellSize.postLabelInsets.left,
                                                    y: Constants.CellSize.postLabelInsets.top),
                                    size: .zero)
        if let text = postText, !text.isEmpty {
            let width = cardViewWidth - Constants.CellSize.postLabelInsets.left -
                        Constants.CellSize.postLabelInsets.right
            let height = text.height(width: width, font: Constants.CellSize.postLabelFont)
            postLabelFrame.size = CGSize(width: width, height: height)
        }

        // work with postLabelFrame
        let attachmentTop = postLabelFrame.size == .zero ?
            Constants.CellSize.postLabelInsets.top : postLabelFrame.maxY + Constants.CellSize.postLabelInsets.bottom
        var attachmentFrame = CGRect(origin: CGPoint(x: 0, y: attachmentTop),
                                     size: .zero)
        if let attachment = photoAttachment {
            let ration = Float(attachment.height) / Float(attachment.width)
            attachmentFrame.size = CGSize(width: cardViewWidth, height: cardViewWidth * CGFloat(ration))
        }

        // work with bottomViewFrame
        let bottomViewTop = max(postLabelFrame.maxY, attachmentFrame.maxY)
        let bottomViewFrame = CGRect(origin: CGPoint(x: 0, y: bottomViewTop),
                                     size: CGSize(width: cardViewWidth, height: Constants.CellSize.bottomViewHeight))

        // work with totalHeight
        let totalHeight = bottomViewFrame.maxY + Constants.CellSize.cardInsets.bottom

        return Sizes(postLabelFrame: postLabelFrame,
                     attachmentFrame: attachmentFrame,
                     bottomViewFrame: bottomViewFrame,
                     totalHeigt: totalHeight)
    }
}
