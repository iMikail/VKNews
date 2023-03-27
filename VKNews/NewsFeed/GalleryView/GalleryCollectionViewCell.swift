//
//  GalleryCollectionViewCell.swift
//  VKNews
//
//  Created by Misha Volkov on 27.03.23.
//

import UIKit

final class GalleryCollectionViewCell: UICollectionViewCell {
    // MARK: - Constants/variables
    static let reuseId = "GalleryCollectionViewCell"

    // MARK: - Views
    lazy var myImageView: WebImageView = {
        let imageView = WebImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .cyan//-
        return imageView
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .green//-
        setupViews()
        setupConstraints()
    }

    // MARK: - Functions
    override func prepareForReuse() {
        myImageView.image = nil
    }

    func set(imageUrl: String?) {
        myImageView.set(imageUrl: imageUrl)
    }

    // MARK: Setup functions
    private func setupViews() {
        addSubview(myImageView)
    }

    private func setupConstraints() {
        myImageView.fillSuperview()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
