//
//  UIView+Gradient.swift
//  NotesApp
//
//  Created by Tuna Demirci on 26.11.2024.
//

import UIKit

extension UIView {
    // MARK: - Setup Gradient Background
    func setupGradientBackground(colors: [CGColor] = [UIColor.brown.cgColor, UIColor.black.cgColor]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
