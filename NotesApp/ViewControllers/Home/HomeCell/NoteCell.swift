//
//  NoteCell.swift
//  NotesApp
//
//  Created by Tuna Demirci on 29.11.2024.
//

import UIKit
import SnapKit

// MARK: - NoteCellDelegate Protocol
protocol NoteCellDelegate: AnyObject {
    func minusButtonClicked(cell: NoteCell)
}

class NoteCell : UICollectionViewCell {
    static let identifier = "NoteCell"
    weak var delegate: NoteCellDelegate?
  
    // MARK: - UI Elements
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.numberOfLines = 8
        label.lineBreakMode = .byTruncatingTail 
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let minusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "minus"), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Properties
    var cellBackgroundColor: UIColor? {
            didSet {
                contentView.backgroundColor = cellBackgroundColor
            }
        }
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    @objc func deleteButtonClicked() {
        delegate?.minusButtonClicked(cell: self)
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = true
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(minusButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(10)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.top).inset(30)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        minusButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().inset(10)
        }
        minusButton.addTarget(self, action: #selector(deleteButtonClicked), for: .touchUpInside)
    }
}
