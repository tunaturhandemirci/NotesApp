//
//  ProcessViewController.swift
//  NotesApp
//
//  Created by Tuna Demirci on 28.11.2024.
//

import UIKit

class ProcessViewController: UIViewController {

    let authManager = AuthManager()
    
    lazy var selectProfilImageView : UIImageView = {
        let selectProfilImageView = UIImageView()
        selectProfilImageView.image = UIImage(systemName: "person.fill")
        selectProfilImageView.clipsToBounds = true
        selectProfilImageView.layer.cornerRadius = 30
        selectProfilImageView.layer.borderWidth = 2.0
        selectProfilImageView.layer.borderColor = UIColor.white.cgColor
        selectProfilImageView.tintColor = .white
        selectProfilImageView.translatesAutoresizingMaskIntoConstraints = false
        return selectProfilImageView
    }()
    
    lazy var userNameTextField: UITextField = {
        let userNameTextField = UITextField()
        userNameTextField.backgroundColor = .white
        userNameTextField.textColor = .black
        userNameTextField.clipsToBounds = true
        userNameTextField.layer.cornerRadius = 20
        userNameTextField.autocapitalizationType = .none
        userNameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        userNameTextField.attributedPlaceholder = NSAttributedString(
            string: "Type your username",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.gray,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .medium)
            ]
        )
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: userNameTextField.frame.height))
        userNameTextField.leftView = paddingView
        userNameTextField.leftViewMode = .always
        
        return userNameTextField
    }()
    
    lazy var exitButton: UIButton = {
        let exitButton = UIButton(type: .system)
        exitButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        exitButton.setTitleColor(.black, for: .normal)
        exitButton.tintColor = .white
        exitButton.addTarget(self, action: #selector(exitButtonClicked), for: .touchUpInside)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        return exitButton
    }()
    
    lazy var processSaveButton: UIButton = {
        let processSaveButton = UIButton(type: .system)
        processSaveButton.setTitle("Save", for: .normal)
        processSaveButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        processSaveButton.setTitleColor(.white, for: .normal)
        processSaveButton.layer.cornerRadius = 25
        processSaveButton.addTarget(self, action: #selector(saveButtonClicked), for: .touchUpInside)
        processSaveButton.translatesAutoresizingMaskIntoConstraints = false
        return processSaveButton
    }()
    
    
    lazy var logOutButton: UIButton = {
        let logOutButton = UIButton(type: .system)
        logOutButton.setTitle("Log Out", for: .normal)
        logOutButton.setTitleColor(.black, for: .normal)
        logOutButton.backgroundColor = .white
        logOutButton.layer.cornerRadius = 25
        logOutButton.addTarget(self, action: #selector(signOutUser), for: .touchUpInside)
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        return logOutButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
       
    }
    
    @objc func exitButtonClicked() {
        let homeVC = HomeViewController()
        homeVC.modalPresentationStyle = .fullScreen
        present(homeVC, animated: false, completion: nil)
    }
    
    @objc func saveButtonClicked() {
        print("Save")
    }
    
    @objc func signOutUser() {
        
        authManager.signOut { result in
            switch result {
            case .success(_):
                let logInVC = LogInViewController()
                logInVC.modalPresentationStyle = .fullScreen
                self.present(logInVC, animated: true, completion: nil)
            case .failure(let error):
                print("Error signing out: \(error.localizedDescription)")
            }
        }
    }
        
    private func setupUI() {
        let bounds = UIScreen.main.bounds
        let height = bounds.size.height
        let width = bounds.size.width
        
        view.backgroundColor = .black
        
        view.addSubview(logOutButton)
        view.addSubview(userNameTextField)
        view.addSubview(exitButton)
        view.addSubview(processSaveButton)
        view.addSubview(selectProfilImageView)
        
        selectProfilImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(height * 0.12)
            make.leading.equalToSuperview().inset(width * 0.06)
            make.width.height.equalTo(60)
        }
        
        userNameTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(height * 0.125)
            make.leading.equalTo(selectProfilImageView.snp.leading).inset(width * 0.18)
            make.height.equalTo(50)
            make.width.equalTo(width * 0.70)
           
        }
        
        exitButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(height * 0.02)
            make.trailing.equalToSuperview().inset(width * 0.04)
            make.width.height.equalTo(40)
        }
        
        processSaveButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(height * 0.015)
            make.leading.equalToSuperview().inset(width * 0.02)
            make.height.equalTo(50)
            make.width.equalTo(100)
        }
        
        logOutButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(height * 0.05)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(100)
        }
    }
}