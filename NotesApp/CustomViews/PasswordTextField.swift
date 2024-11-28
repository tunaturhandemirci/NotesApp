//
//  PasswordTextField.swift
//  NotesApp
//
//  Created by Tuna Demirci on 26.11.2024.
//

import UIKit

class PasswordTextField : UITextField {
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPasswordTextField()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupPasswordTextField()
    }
    
    // MARK: - Setup Password TextField
    private func setupPasswordTextField() {
        self.backgroundColor = .white
        self.textColor = .black
        self.clipsToBounds = true
        self.layer.cornerRadius = 20
        self.isSecureTextEntry = true
        self.autocapitalizationType = .none
        self.translatesAutoresizingMaskIntoConstraints = false
        self.textContentType = .oneTimeCode
        self.autocorrectionType = .no
        
        self.attributedPlaceholder = NSAttributedString(
            string: "Type your password",
            attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray,
                         NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .medium)
                        ])
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
        
        let eyeButton = UIButton(type: .custom)
        eyeButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        eyeButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        eyeButton.frame = CGRect(x: 0, y: 0, width: 30, height: 40)
        
        let eyeButtonView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        eyeButtonView.addSubview(eyeButton)
        
        self.rightView = eyeButtonView
        self.rightViewMode = .always
    }
    
    // MARK: - Password Visibility Toggle
    @objc private func togglePasswordVisibility() {
        self.toggleSecureEntry()
        
        let eyeImage = self.isSecureTextEntry ? UIImage(systemName: "eye.slash") : UIImage(systemName: "eye")
        if let eyeButton = self.rightView?.subviews.first as? UIButton {
            eyeButton.setImage(eyeImage, for: .normal)
        }
    }
}
