//
//  GradientView.swift
//  VKNews
//
//  Created by Misha Volkov on 28.03.23.
//

import UIKit

final class GradientView: UIView {
    // MARK: - Constants/variables
    @IBInspectable private var startColor: UIColor? {
        didSet {
            setupGradientColors()
        }
    }

    @IBInspectable private var endColor: UIColor? {
        didSet {
            setupGradientColors()
        }
    }

    private let gradientLayer = CAGradientLayer()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradient()
    }

    // MARK: - Functions
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    private func setupGradient() {
        layer.addSublayer(gradientLayer)
        setupGradientColors()
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.15)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.85)
    }

    private func setupGradientColors() {
        if let startColor = startColor, let endColor = endColor {
            gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        }
    }
}
