//
//  UITextField+Extensions.swift
//  NotesApp
//
//  Created by Tuna Demirci on 25.11.2024.
//

import UIKit

extension UITextField {
    // MARK: - Secure Entry Toggle
    func toggleSecureEntry() {
        guard let existingText = text else { return }
        
        isSecureTextEntry.toggle()
        
        if isSecureTextEntry {
            deleteBackward()
            
            if let textRange = textRange(from: beginningOfDocument, to: endOfDocument) {
                replace(textRange, withText: existingText)
            }
        }
        
        if let currentSelectedRange = selectedTextRange {
            selectedTextRange = nil
            selectedTextRange = currentSelectedRange
        }
    }
}










