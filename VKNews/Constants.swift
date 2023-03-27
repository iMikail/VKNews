//
//  Constants.swift
//  VKNews
//
//  Created by Misha Volkov on 24.03.23.
//

import UIKit

struct Constants {
    struct CellSize {
        static let defaultSpace: CGFloat = 8

        static let topViewHeight: CGFloat = 36
        static let bottomViewHeight: CGFloat = 44
        static let cardInsets = UIEdgeInsets(top: 0, left: defaultSpace, bottom: 12, right: defaultSpace)
        static let postLabelInsets = UIEdgeInsets(top: defaultSpace * 2 + topViewHeight,
                                                  left: defaultSpace,
                                                  bottom: defaultSpace,
                                                  right: defaultSpace)
        static let postLabelFont = UIFont.systemFont(ofSize: 15)

        static let bottomSubViewHeight: CGFloat = 44
        static let bottomSubViewWidth: CGFloat = 80
        static let bottomSubViewIconSize: CGFloat = 24

        static let minifiedPostLimintLines: CGFloat = 8
        static let minifiedPostLines: CGFloat = 6

        static let moreTextButtonSize = CGSize(width: 170, height: 30)
        static let moreTextButtonInsets = UIEdgeInsets(top: 0, left: defaultSpace, bottom: 0, right: defaultSpace)
    }

    enum ImageKey: String {
        case like
        case comment
        case share
        case eye
    }
}
