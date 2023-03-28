//
//  GalleryCollectionView.swift
//  VKNews
//
//  Created by Misha Volkov on 27.03.23.
//

import UIKit

final class GalleryCollectionView: UICollectionView {
    // MARK: - Constants/variables
    var photos = [FeedCellPhotoAttachmentViewModel]()

    // MARK: - Init
    init() {
        let rowLayout = RowLayout()
        super.init(frame: .zero, collectionViewLayout: rowLayout)

        dataSource = self
        delegate = self
        register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: GalleryCollectionViewCell.reuseId)

        if let rowLayout = collectionViewLayout as? RowLayout {
            rowLayout.delegate = self
        }
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
    }

    // MARK: - Functions
    func set(photos: [FeedCellPhotoAttachmentViewModel]) {
        self.photos = photos
        contentOffset = .zero
        reloadData()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extension
// MARK: UICollectionViewDataSource
extension GalleryCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: GalleryCollectionViewCell.reuseId,
                        for: indexPath) as? GalleryCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.set(imageUrl: photos[indexPath.row].photoUrlString)

        return cell
    }
}

// MARK: UICollectionViewDelegate
extension GalleryCollectionView: UICollectionViewDelegate {

}

extension GalleryCollectionView: RowLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, photoAtIndexPath indexPath: IndexPath) -> CGSize {
        let width = photos[indexPath.row].width
        let height = photos[indexPath.row].height

        return CGSize(width: width, height: height)
    }
}
