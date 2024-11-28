//
//  UIViewController+Keyboard.swift
//  NotesApp
//
//  Created by Tuna Demirci on 26.11.2024.
//

import UIKit

extension UIViewController {
    // MARK: - Keyboard Handling
    func closeKeyboard() {
        let closeKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(closeKeyboardGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
