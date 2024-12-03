//
//  HomeViewController.swift
//  NotesApp
//
//  Created by Tuna Demirci on 23.11.2024.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, NoteCellDelegate {
    
    // MARK: - Properties
    var homeCollectionView: UICollectionView!
    var viewModel: HomeViewModel!
    
    // MARK: - UI Elements
    lazy var profilImageView : UIImageView = {
        let profilImageView = UIImageView()
        profilImageView.image = UIImage(systemName: "person.fill")
        profilImageView.clipsToBounds = true
        profilImageView.layer.cornerRadius = 30
        profilImageView.layer.borderWidth = 2.0
        profilImageView.tintColor = .white
        profilImageView.backgroundColor = .black
        profilImageView.layer.borderColor = UIColor.black.cgColor
        profilImageView.translatesAutoresizingMaskIntoConstraints = false
        return profilImageView
    }()
    
    lazy var userNameLabel : UILabel = {
        let userNameLabel = UILabel()
        userNameLabel.text = "Hi, Username"
        userNameLabel.textColor = .black
        userNameLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        return userNameLabel
    }()
    
    lazy var processButton : UIButton = {
        let processButton = UIButton(type: .system)
        processButton.setImage(UIImage(systemName:"line.3.horizontal"), for: .normal)
        processButton.tintColor = .white
        processButton.backgroundColor = .black
        processButton.layer.cornerRadius = 20
        processButton.addTarget(self, action: #selector(processButtonClicked), for: .touchUpInside)
        processButton.translatesAutoresizingMaskIntoConstraints = false
        return processButton
    }()
    
    lazy var myNotesLabel : UILabel = {
        let myNotesLabel = UILabel()
        myNotesLabel.text = "My Notes"
        myNotesLabel.textColor = .black
        myNotesLabel.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        myNotesLabel.translatesAutoresizingMaskIntoConstraints = false
        return myNotesLabel
    }()
    
    lazy var plusButton: UIButton = {
        let plusButton = UIButton(type: .system)
        plusButton.setImage(UIImage(systemName:"plus"), for: .normal)
        plusButton.tintColor = .black
        plusButton.addTarget(self, action: #selector(plusButtonClicked), for: .touchUpInside)
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        return plusButton
    }()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHomeViewModel()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchNotes()
        loadUserInfo()
    }
    
    // MARK: - Actions
    @objc func processButtonClicked() {
        let processVC = ProcessViewController()
        processVC.modalPresentationStyle = .overCurrentContext
        processVC.onKeyboardHide = { [weak self] in
            guard let self = self else { return }
            processVC.view.frame = CGRect(
                x: 0,
                y: self.view.frame.height * 0.6,
                width: self.view.frame.width,
                height: self.view.frame.height * 0.4
            )
        }
        self.present(processVC, animated: false, completion: {
            processVC.view.frame = CGRect(
                x: 0,
                y: self.view.frame.height * 0.6,
                width: self.view.frame.width,
                height: self.view.frame.height * 0.4
            )
        })
    }
    
    @objc func plusButtonClicked() {
        let noteVC = NoteViewController()
        noteVC.modalPresentationStyle = .fullScreen
        self.present(noteVC, animated: true, completion: nil)
    }
    
    // MARK: - ViewModel
    private func configureHomeViewModel() {
        viewModel = HomeViewModel()
        
        viewModel.reloadData = { [weak self] in
            self?.homeCollectionView?.reloadData()
        }
        viewModel.fetchNotes()
    }
    
    private func loadUserInfo() {
        guard ((UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext) != nil else {
            print("Context is not available.")
            return
        }
        viewModel.fetchUserInfo { [weak self] userName, profileImage in
            DispatchQueue.main.async {
                self?.userNameLabel.text = userName != nil ? "Hi, \(userName!)" : "Hi, User"
                if let image = profileImage {
                    self?.profilImageView.image = image
                }
            }
        }
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        let bounds = UIScreen.main.bounds
        let height = bounds.size.height
        let width = bounds.size.width
        
        view.setupGradientBackground()
        
        let uiElementsHome : [UIView] = [
            profilImageView,
            userNameLabel,
            processButton,
            myNotesLabel,
            plusButton
        ]
        
        for element in uiElementsHome {
            view.addSubview(element)
        }
        
        profilImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(height * 0.07)
            make.leading.equalToSuperview().inset(width * 0.06)
            make.width.height.equalTo(60)
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(height * 0.085)
            make.leading.equalTo(profilImageView.snp.leading).inset(width * 0.18)
            make.height.equalTo(30)
            make.width.equalTo(200)
        }
        
        processButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(height * 0.08)
            make.trailing.equalToSuperview().inset(width * 0.06)
            make.width.height.equalTo(40)
        }
        
        myNotesLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(height * 0.18)
            make.leading.equalToSuperview().inset(width * 0.06)
            make.height.equalTo(50)
            make.width.equalTo(180)
        }
        
        plusButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(height * 0.178)
            make.trailing.equalToSuperview().inset(width * 0.06)
            make.width.height.equalTo(50)
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        
        homeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self
        homeCollectionView.backgroundColor = .clear
        homeCollectionView.register(NoteCell.self, forCellWithReuseIdentifier: NoteCell.identifier)
        
        view.addSubview(homeCollectionView)
        homeCollectionView.translatesAutoresizingMaskIntoConstraints = false
        homeCollectionView.snp.makeConstraints { make in
            make.top.equalTo(myNotesLabel.snp.top).inset(height * 0.08)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(height * 0.10)
        }
    }
}

// MARK: - CollectionView Extension
extension HomeViewController {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getNoteCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoteCell.identifier, for: indexPath) as! NoteCell
        let note = viewModel.getNote(at: indexPath.item)
        cell.titleLabel.text = note.title
        cell.descriptionLabel.text = note.content
        cell.delegate = self
        
        if let colorData = note.color,
           let color = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(colorData) as? UIColor {
            cell.cellBackgroundColor = color
        } else {
            cell.cellBackgroundColor = .green
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedNote = viewModel.getNote(at: indexPath.item)
        let noteVC = NoteViewController()
        noteVC.modalPresentationStyle = .fullScreen
        noteVC.configureWith(note: selectedNote)
        present(noteVC, animated: true, completion: nil)
    }
    
    func minusButtonClicked(cell: NoteCell) {
        guard let indexPath = homeCollectionView.indexPath(for: cell) else { return }
        
        let alertController = UIAlertController(title: "Are you sure?", message: "Are you sure you want to delete this note?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.viewModel.deleteNote(at: indexPath.item)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 16) / 2
        return CGSize(width: width, height: 200)
    }
}
