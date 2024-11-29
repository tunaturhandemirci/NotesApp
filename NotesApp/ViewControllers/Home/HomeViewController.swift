//
//  HomeViewController.swift
//  NotesApp
//
//  Created by Tuna Demirci on 23.11.2024.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    /*
     */
    private var collectionView: UICollectionView!
    private let notes = [
        Note(title: "Buy honey 100% original", description: "Buy the new brand honey for my family, here's the pic.", color: .black, image: UIImage(systemName: "")),
        Note(title: "Plan for the today", description: "Buy food, GYN, Meeting", color: .black, image: nil),
        Note(title: "Tax payment before end of March", description: "Don't forget to pay taxes. List of assets must be reported.", color: .black, image: nil)
    ]
    /*
     */
    lazy var profilImageView : UIImageView = {
        let profilImageView = UIImageView()
        profilImageView.image = UIImage(systemName: "person.fill")
        profilImageView.clipsToBounds = true
        profilImageView.layer.cornerRadius = 30
        profilImageView.layer.borderWidth = 2.0
        profilImageView.tintColor = .white
        profilImageView.backgroundColor = .black
        profilImageView.layer.borderColor = UIColor.white.cgColor
        profilImageView.translatesAutoresizingMaskIntoConstraints = false
        return profilImageView
    }()
    
    lazy var userNameLabel : UILabel = {
        let userNameLabel = UILabel()
        userNameLabel.text = "Hi, Username"
        userNameLabel.textColor = .white
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
        myNotesLabel.textColor = .white
        myNotesLabel.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        myNotesLabel.translatesAutoresizingMaskIntoConstraints = false
        return myNotesLabel
    }()
    
    lazy var plusButton: UIButton = {
        let plusButton = UIButton(type: .system)
        plusButton.setImage(UIImage(systemName:"plus"), for: .normal)
        plusButton.tintColor = .white
        plusButton.addTarget(self, action: #selector(plusButtonClicked), for: .touchUpInside)
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        return plusButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        /*
         */
        setupCollectionView()
        /*
         */
        
    }
    
    @objc func processButtonClicked() {
        let processVC = ProcessViewController()
        processVC.modalPresentationStyle = .overCurrentContext
        self.present(processVC, animated: false, completion: {
            processVC.view.frame = CGRect(x: 0, y: self.view.frame.height * 0.6, width: self.view.frame.width, height: self.view.frame.height * 0.4 )
            processVC.view.layer.cornerRadius = 30
        })
    }
    
    @objc func plusButtonClicked() {
        let noteVC = NoteViewController()
        noteVC.modalPresentationStyle = .fullScreen
        self.present(noteVC, animated: true, completion: nil)
    }
    
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
    }
    
    /*
     */
    private func setupCollectionView() {
        let bounds = UIScreen.main.bounds
        let height = bounds.size.height
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.register(NoteCell.self, forCellWithReuseIdentifier: NoteCell.identifier)
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(myNotesLabel.snp.top).inset(height * 0.08)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(height * 0.08)
        }
    }
    
    // MARK: - Collection View Data Source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoteCell.identifier, for: indexPath) as! NoteCell
        let note = notes[indexPath.item]
        cell.configure(with: note)
        return cell
    }
    
    // MARK: - Collection View Delegate FlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 16) / 2 // İki sütunlu düzen
        return CGSize(width: width, height: 200) // Kartların yüksekliği sabit
    }
    /*
     */
}
