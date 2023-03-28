//
//  RowLayout.swift
//  VKNews
//
//  Created by Misha Volkov on 27.03.23.
//

import UIKit

protocol RowLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, photoAtIndexPath indexPath: IndexPath) -> CGSize
}

final class RowLayout: UICollectionViewLayout {
    // MARK: - Constants/variables
    weak var delegate: RowLayoutDelegate?

    static private var numberOfRows = 2
    private var cellPadding: CGFloat = 8

    private var cache = [UICollectionViewLayoutAttributes]()

    private var contentWidth: CGFloat = 0
    private var contentHeight: CGFloat {
        guard let collectionView = collectionView else { return 0 }

        let insets = collectionView.contentInset

        return collectionView.bounds.height - (insets.left + insets.right)
    }

    override var collectionViewContentSize: CGSize {
        CGSize(width: contentWidth, height: contentHeight)
    }

    // MARK: - Functions
    override func prepare() {
        contentWidth = 0
        cache = []
        guard let collectionView = collectionView else { return }

        var photos = [CGSize]()
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            if let photoSize = delegate?.collectionView(collectionView, photoAtIndexPath: indexPath) {
                photos.append(photoSize)
            }
        }
        let superViewWidth = collectionView.frame.width
        guard var rowHeight = RowLayout.rowHeightCounter(superViewWidth: superViewWidth,
                                                         photosArray: photos) else { return }

        rowHeight /= CGFloat(RowLayout.numberOfRows)
        let photosRatios = photos.map { $0.height / $0.width }

        var yOffset = [CGFloat]()
        for row in 0..<RowLayout.numberOfRows {
            yOffset.append(CGFloat(row) * rowHeight)
        }

        var xOffset = [CGFloat](repeating: 0, count: RowLayout.numberOfRows)
        var row = 0
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)

            let ratio = photosRatios[indexPath.row]
            let width = rowHeight / ratio
            let frame = CGRect(x: xOffset[row], y: yOffset[row], width: width, height: rowHeight)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)

            let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attribute.frame = insetFrame
            cache.append(attribute)

            contentWidth = max(contentWidth, frame.maxX)
            xOffset[row] += width
            row = row < (RowLayout.numberOfRows - 1) ? (row + 1) : 0
        }
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()

        for attribute in cache where attribute.frame.intersects(rect) {
            visibleLayoutAttributes.append(attribute)
        }

        return visibleLayoutAttributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        cache[indexPath.row]
    }

    static func rowHeightCounter(superViewWidth: CGFloat, photosArray: [CGSize]) -> CGFloat? {
        var rowHeight: CGFloat

        let photoWithMinRatio = photosArray.min { (first, second) in
            (first.height / first.width) < (second.height / second.width)
        }

        guard let myPhotoWithMinRatio = photoWithMinRatio else { return nil }

        let difference = superViewWidth / myPhotoWithMinRatio.width
        rowHeight = myPhotoWithMinRatio.height * difference
        rowHeight *= CGFloat(RowLayout.numberOfRows)

        return rowHeight
    }
}
