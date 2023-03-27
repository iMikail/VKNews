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
        let layot = UICollectionViewFlowLayout()
        layot.scrollDirection = .horizontal
        super.init(frame: .zero, collectionViewLayout: layot)

        dataSource = self
        delegate = self
        backgroundColor = .gray//-
        register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: GalleryCollectionViewCell.reuseId)
    }

    // MARK: - Functions
    func set(photos: [FeedCellPhotoAttachmentViewModel]) {
        self.photos = photos
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
