//
//  TitleView.swift
//  VKNews
//
//  Created by Misha Volkov on 28.03.23.
//

import UIKit

protocol TitleViewViewModel {
    var photoUrlString: String? { get }
}

final class TitleView: UIView {
    // MARK: - Constants/variables
    override var intrinsicContentSize: CGSize {
        return UIView.layoutFittingExpandedSize
    }

    // MARK: - Views
    private lazy var myTextField = InsetableTextField()
    private lazy var myAvatarView: WebImageView = {
        let imageView = WebImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true

        return imageView
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        translatesAutoresizingMaskIntoConstraints = false
        setupViews()
        setupConstraints()
    }

    // MARK: - Functions
    override func layoutSubviews() {
        super.layoutSubviews()

        myAvatarView.layer.masksToBounds = true
        myAvatarView.layer.cornerRadius = myAvatarView.frame.width / 2
    }

    func set(userViewModel: TitleViewViewModel) {
        myAvatarView.set(imageUrl: userViewModel.photoUrlString)
    }

    private func setupViews() {
        addSubview(myTextField)
        addSubview(myAvatarView)
    }

    private func setupConstraints() {
        myAvatarView.anchor(top: topAnchor,
                            leading: nil,
                            bottom: nil,
                            trailing: trailingAnchor,
                            padding: UIEdgeInsets(top: 4, left: 666, bottom: 666, right: 4))
        myAvatarView.heightAnchor.constraint(equalTo: myTextField.heightAnchor, multiplier: 1).isActive = true
        myAvatarView.widthAnchor.constraint(equalTo: myTextField.heightAnchor, multiplier: 1).isActive = true

        myTextField.anchor(top: topAnchor,
                           leading: leadingAnchor,
                           bottom: bottomAnchor,
                           trailing: myAvatarView.leadingAnchor,
                           padding: UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 12))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
