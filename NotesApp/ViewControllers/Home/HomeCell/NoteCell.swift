//
//  NoteCell.swift
//  NotesApp
//
//  Created by Tuna Demirci on 29.11.2024.
//

import UIKit

class NoteCell : UICollectionViewCell {
    static let identifier = "NoteCell"
    
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
    
    var cellBackgroundColor: UIColor? {
            didSet {
                contentView.backgroundColor = cellBackgroundColor
            }
        }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = true
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(10)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.top).inset(30)
            make.leading.trailing.equalToSuperview().inset(10)
        }
    }
}
