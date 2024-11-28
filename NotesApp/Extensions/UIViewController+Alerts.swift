//
//  UIViewController+Alerts.swift
//  NotesApp
//
//  Created by Tuna Demirci on 26.11.2024.
//

import UIKit

// MARK: - UIViewController Extension for Alerts
extension UIViewController {
    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}
