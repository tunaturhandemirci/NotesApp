//
//  EmailTextField.swift
//  NotesApp
//
//  Created by Tuna Demirci on 26.11.2024.
//

import UIKit

class EmailTextField : UITextField {
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupEmailTextField()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupEmailTextField()
    }
    
    // MARK: - Setup Email TextField
    private func setupEmailTextField() {
        self.backgroundColor = .white
        self.textColor = .black
        self.clipsToBounds = true
        self.layer.cornerRadius = 20
        self.autocapitalizationType = .none
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.attributedPlaceholder = NSAttributedString(
            string: "Type your email",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.gray,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .medium)
            ]
        )
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
