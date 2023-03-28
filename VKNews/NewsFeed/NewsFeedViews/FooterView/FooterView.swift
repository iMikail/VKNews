//
//  FooterView.swift
//  VKNews
//
//  Created by Misha Volkov on 28.03.23.
//

import UIKit

final class FooterView: UIView {

    // MARK: - Views
    private lazy var myLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .systemGray4
        label.textAlignment = .center

        return label
    }()

    private lazy var loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.hidesWhenStopped = true

        return loader
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupConstraints()
    }

    // MARK: - Functions
    func showLoader() {
        loader.startAnimating()
    }

    func setTitle(_ title: String?) {
        loader.stopAnimating()
        myLabel.text = title
    }

    private func setupViews() {
        addSubview(myLabel)
        addSubview(loader)
    }

    private func setupConstraints() {
        myLabel.anchor(top: topAnchor,
                       leading: leadingAnchor,
                       bottom: nil,
                       trailing: trailingAnchor,
                       padding: UIEdgeInsets(top: 8, left: 20, bottom: 666, right: 20))
        loader.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        loader.topAnchor.constraint(equalTo: myLabel.bottomAnchor, constant: 8).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
