//
//  NoteTextView.swift
//  NotesApp
//
//  Created by Tuna Demirci on 29.11.2024.
//

import UIKit
import SnapKit

class NoteTextView : UITextView {
    
    // MARK: - Properties
    var placeholder: String? {
        didSet {
            self.setPlaceholder()
        }
    }
    private let placeholderLabel = UILabel()
    
    // MARK: - Initializers
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupTextView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTextView()
    }
    
    // MARK: - Setup Custom TextView
    private func setupTextView() {
        self.isScrollEnabled = true
        self.textContainer.lineBreakMode = .byWordWrapping
        self.font = UIFont.boldSystemFont(ofSize: 24)
        self.layer.cornerRadius = 20
        self.backgroundColor = .clear
        self.textContainerInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        placeholderLabel.font = UIFont.systemFont(ofSize: 18)
        placeholderLabel.textColor = .lightGray
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(placeholderLabel)
        self.delegate = self
    }
    
    // MARK: - Set Placeholder Text
    private func setPlaceholder() {
        placeholderLabel.text = placeholder
        placeholderLabel.isHidden = !self.text.isEmpty
        
        placeholderLabel.snp.makeConstraints { make in
            make.top.equalTo(self).inset(14)
            make.leading.equalTo(self).inset(18)
        }
    }
}

extension NoteTextView : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}
