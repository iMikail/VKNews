//
//  NewsFeedCellLayoutCalculator.swift
//  VKNews
//
//  Created by Misha Volkov on 24.03.23.
//

import UIKit

// MARK: - Protocols
protocol FeedCellLayoutCalculatorProtocol {
    func sizes(postText: String?,
               photoAttachments: [FeedCellPhotoAttachmentViewModel],
               isFullSizedPost: Bool) -> FeedCellSizes
}

struct Sizes: FeedCellSizes {
    var postLabelFrame: CGRect
    var attachmentFrame: CGRect
    var bottomViewFrame: CGRect
    var totalHeigt: CGFloat
    var noreTextButtonFrame: CGRect
}

final class NewsFeedCellLayoutCalculator: FeedCellLayoutCalculatorProtocol {
    private let screenWidth: CGFloat

    init(screenWidth: CGFloat = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)) {
        self.screenWidth = screenWidth
    }

    // MARK: - Functions
    func sizes(postText: String?,
               photoAttachments: [FeedCellPhotoAttachmentViewModel],
               isFullSizedPost: Bool) -> FeedCellSizes {
        var showMoreTextButton = false
        let cardViewWidth = screenWidth - Constants.CellSize.cardInsets.left - Constants.CellSize.cardInsets.right

        // work with postLabelFrame
        var postLabelFrame = CGRect(origin: CGPoint(x: Constants.CellSize.postLabelInsets.left,
                                                    y: Constants.CellSize.postLabelInsets.top),
                                    size: .zero)
        if let text = postText, !text.isEmpty {
            let width = cardViewWidth - Constants.CellSize.postLabelInsets.left -
                        Constants.CellSize.postLabelInsets.right
            var height = text.height(width: width, font: Constants.CellSize.postLabelFont)
            let limitHeight = Constants.CellSize.postLabelFont.lineHeight * Constants.CellSize.minifiedPostLimintLines

            if !isFullSizedPost && height > limitHeight {
                height = Constants.CellSize.postLabelFont.lineHeight * Constants.CellSize.minifiedPostLines
                showMoreTextButton = true
            }
            postLabelFrame.size = CGSize(width: width, height: height)
        }

        // work with moreButtonFrame
        var moreButtonSize = CGSize.zero

        if showMoreTextButton {
            moreButtonSize = Constants.CellSize.moreTextButtonSize
        }
        let moreTextButtonOrigin = CGPoint(x: Constants.CellSize.moreTextButtonInsets.left, y: postLabelFrame.maxY)
        let moreButtonFrame = CGRect(origin: moreTextButtonOrigin, size: moreButtonSize)

        // work with attachmentFrame
        let attachmentTop = postLabelFrame.size == .zero ?
            Constants.CellSize.postLabelInsets.top : moreButtonFrame.maxY + Constants.CellSize.postLabelInsets.bottom
        var attachmentFrame = CGRect(origin: CGPoint(x: 0, y: attachmentTop),
                                     size: .zero)

        if let attachment = photoAttachments.first {
            let ration = Float(attachment.height) / Float(attachment.width)
            if photoAttachments.count == 1 {
                attachmentFrame.size = CGSize(width: cardViewWidth, height: cardViewWidth * CGFloat(ration))
            } else if photoAttachments.count > 1 {
                attachmentFrame.size = CGSize(width: cardViewWidth, height: cardViewWidth * CGFloat(ration))
            }
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
                     totalHeigt: totalHeight,
                     noreTextButtonFrame: moreButtonFrame)
    }
}
