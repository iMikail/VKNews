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

struct CellSizeConstants {
    private static let defaultSpace: CGFloat = 8

    static let topViewHeight: CGFloat = 36
    static let bottomViewHeight: CGFloat = 44
    static let cardInsets = UIEdgeInsets(top: 0, left: defaultSpace, bottom: 12, right: defaultSpace)
    static let postLabelInsets = UIEdgeInsets(top: defaultSpace * 2 + topViewHeight,
                                              left: defaultSpace,
                                              bottom: defaultSpace,
                                              right: defaultSpace)
    static let postLabelFont = UIFont.systemFont(ofSize: 15)
}

final class NewsFeedCellLayoutCalculator: FeedCellLayoutCalculatorProtocol {
    private let screenWidth: CGFloat

    init(screenWidth: CGFloat = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)) {
        self.screenWidth = screenWidth
    }

    func sizes(postText: String?, photoAttachment: FeedCellPhotoAttachmentViewModel?) -> FeedCellSizes {
        let cardViewWidth = screenWidth - CellSizeConstants.cardInsets.left - CellSizeConstants.cardInsets.right

        // work with postLabelFrame
        var postLabelFrame = CGRect(origin: CGPoint(x: CellSizeConstants.postLabelInsets.left,
                                                    y: CellSizeConstants.postLabelInsets.top),
                                    size: .zero)
        if let text = postText, !text.isEmpty {
            let width = cardViewWidth - CellSizeConstants.postLabelInsets.left - CellSizeConstants.postLabelInsets.right
            let height = text.height(width: width, font: CellSizeConstants.postLabelFont)
            postLabelFrame.size = CGSize(width: width, height: height)
        }

        // work with postLabelFrame
        let attachmentTop = postLabelFrame.size == .zero ?
        CellSizeConstants.postLabelInsets.top : postLabelFrame.maxY + CellSizeConstants.postLabelInsets.bottom
        var attachmentFrame = CGRect(origin: CGPoint(x: 0, y: attachmentTop),
                                     size: .zero)
        if let attachment = photoAttachment {
            let ration = Float(attachment.height) / Float(attachment.width)
            attachmentFrame.size = CGSize(width: cardViewWidth, height: cardViewWidth * CGFloat(ration))
        }

        // work with bottomViewFrame
        let bottomViewTop = max(postLabelFrame.maxY, attachmentFrame.maxY)
        let bottomViewFrame = CGRect(origin: CGPoint(x: 0, y: bottomViewTop),
                                     size: CGSize(width: cardViewWidth, height: CellSizeConstants.bottomViewHeight))

        // work with totalHeight
        let totalHeight = bottomViewFrame.maxY + CellSizeConstants.cardInsets.bottom

        return Sizes(postLabelFrame: postLabelFrame,
                     attachmentFrame: attachmentFrame,
                     bottomViewFrame: bottomViewFrame,
                     totalHeigt: totalHeight)
    }
}
