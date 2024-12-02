//
//  NoteViewController.swift
//  NotesApp
//
//  Created by Tuna Demirci on 29.11.2024.
//

import UIKit
import SnapKit

class NoteViewController: UIViewController {
    
    var note: Notes?
    
    func configureWith(note: Notes) {
        self.note = note
    }
    
    private var viewModel: NoteViewModel!
    private var selectedColor: UIColor = .green
    
    lazy var backButton : UIButton = {
        let backButton = UIButton(type: .system)
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(.white, for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        backButton.addTarget(self, action: #selector(backButtonClicked) , for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        return backButton
    }()
    
    lazy var noteSaveButton : UIButton = {
        let noteSaveButton = UIButton(type: .system)
        noteSaveButton.setTitle("Save", for: .normal)
        noteSaveButton.setTitleColor(.white, for: .normal)
        noteSaveButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        noteSaveButton.addTarget(self, action: #selector(noteSaveButtonClicked) , for: .touchUpInside)
        noteSaveButton.translatesAutoresizingMaskIntoConstraints = false
        return noteSaveButton
    }()
    
    lazy var newNoteLabel : UILabel = {
        let newNoteLabel = UILabel()
        newNoteLabel.text = "New Note"
        newNoteLabel.textColor = .white
        newNoteLabel.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        newNoteLabel.translatesAutoresizingMaskIntoConstraints = false
        return newNoteLabel
    }()
    
    lazy var whiteLine : UIView = {
        let whiteLine = UIView()
        whiteLine.backgroundColor = .white
        whiteLine.translatesAutoresizingMaskIntoConstraints = false
        return whiteLine
    }()
    
    lazy var titleTextView : NoteTextView = {
        let titleTextView = NoteTextView()
        titleTextView.placeholder = "Type your title"
        return titleTextView
    }()
    
    lazy var descriptionTextView : NoteTextView = {
        let descriptionTextView = NoteTextView()
        descriptionTextView.placeholder = "Type your description "
        descriptionTextView.font = UIFont.systemFont(ofSize: 16)
        return descriptionTextView
    }()
    
    lazy var paintbrushButton: UIButton = {
        let paintbrushButton = UIButton(type: .system)
        paintbrushButton.setImage(UIImage(systemName: "paintbrush.pointed"), for: .normal)
        paintbrushButton.tintColor = .white
        paintbrushButton.backgroundColor = .darkGray
        paintbrushButton.clipsToBounds = true
        paintbrushButton.layer.cornerRadius = 30
        paintbrushButton.addTarget(self, action: #selector(paintbrushButtonClicked), for: .touchUpInside)
        paintbrushButton.translatesAutoresizingMaskIntoConstraints = false
        return paintbrushButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        closeKeyboard()
        configureNoteViewModel()
        displayNoteDetails()
    }
    
    private func displayNoteDetails() {
        guard let note = note else { return }
        titleTextView.text = note.title
        descriptionTextView.text = note.content
        
        titleTextView.isEditable = false
        descriptionTextView.isEditable = false
        titleTextView.placeholder = ""
        descriptionTextView.placeholder = ""
        paintbrushButton.isHidden = true
        noteSaveButton.isHidden = true
        newNoteLabel.isHidden = true
        whiteLine.isHidden = true
        
        titleTextView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(120)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(titleTextView.snp.top).inset(80)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(120)
        }
    }
    
    @objc func backButtonClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func noteSaveButtonClicked() {
        viewModel.saveNote(title: titleTextView.text ?? "", content: descriptionTextView.text ?? "", color: selectedColor)
    }
    
    @objc func paintbrushButtonClicked() {
        let alertController = UIAlertController(title: "Choose a Color", message: nil, preferredStyle: .actionSheet)
        
        let colors: [(String, UIColor)] = [
            ("Red", .red),
            ("Yellow", .yellow),
            ("Green", .green)
        ]
        
        for color in colors {
            let action = UIAlertAction(title: color.0, style: .default) { _ in
                self.selectedColor = color.1
            }
            alertController.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    private func configureNoteViewModel() {
        viewModel = NoteViewModel(context: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
        
        viewModel.onSaveNote = { [weak self] in
            self?.dismiss(animated: true)
            print("Success")
        }
        
        viewModel.onError = { [weak self] errorMessage in
            self?.makeAlert(titleInput: "Error", messageInput: errorMessage)
        }
    }
    
    private func setupUI() {
        let bounds = UIScreen.main.bounds
        let height = bounds.size.height
        let width = bounds.size.width
        
        view.setupGradientBackground()
        
        let uiElementsNoteVC : [UIView] = [
            backButton,
            noteSaveButton,
            newNoteLabel,
            whiteLine,
            titleTextView,
            descriptionTextView,
            paintbrushButton
        ]
        
        for element in uiElementsNoteVC {
            view.addSubview(element)
        }
        
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(height * 0.06)
            make.leading.equalToSuperview().inset(width * 0.06)
            make.width.height.equalTo(40)
        }
        
        noteSaveButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(height * 0.06)
            make.trailing.equalToSuperview().inset(width * 0.06)
            make.width.height.equalTo(40)
        }
        
        newNoteLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(height * 0.14)
            make.leading.equalToSuperview().inset(width * 0.06)
            make.height.equalTo(50)
            make.width.equalTo(250)
        }
        
        whiteLine.snp.makeConstraints { make in
            make.top.equalTo(newNoteLabel.snp.top).inset(50)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        titleTextView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(height * 0.21)
            make.leading.trailing.equalToSuperview().inset(width * 0.06)
            make.height.equalTo(50)
        }
        
        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(titleTextView.snp.top).inset(height * 0.08)
            make.leading.trailing.equalToSuperview().inset(width * 0.06)
            make.bottom.equalToSuperview().inset(height * 0.15)
        }
        
        paintbrushButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(height * 0.05)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(60)
        }
    }
}

