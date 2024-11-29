//
//  HomeViewController.swift
//  NotesApp
//
//  Created by Tuna Demirci on 23.11.2024.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    
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
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    @objc func processButtonClicked() {
        let processVC = ProcessViewController()
        processVC.modalPresentationStyle = .overCurrentContext
        self.present(processVC, animated: false, completion: {
            processVC.view.frame = CGRect(x: 0, y: self.view.frame.height * 0.6, width: self.view.frame.width, height: self.view.frame.height * 0.4 )
            processVC.view.layer.cornerRadius = 30
        })
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
            myNotesLabel
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
    }
}
