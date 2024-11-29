//
//  LogInViewController.swift
//  NotesApp
//
//  Created by Tuna Demirci on 23.11.2024.
//

import UIKit
import SnapKit

class LogInViewController: UIViewController {
    
    // MARK: - Properties
    let authManager = AuthManager()
    
    // MARK: - UI Elements
    lazy var notesAppLabel: UILabel = {
        let notesAppLabel = UILabel()
        notesAppLabel.text = "NotesApp"
        notesAppLabel.textColor = UIColor.white
        notesAppLabel.textAlignment = .center
        notesAppLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        notesAppLabel.translatesAutoresizingMaskIntoConstraints = false
        return notesAppLabel
    }()
    
    lazy var notesImageView: UIImageView = {
        let notesImageView = UIImageView()
        notesImageView.image = UIImage(named: "NotesApp.png")
        notesImageView.clipsToBounds = true
        notesImageView.translatesAutoresizingMaskIntoConstraints = false
        return notesImageView
    }()
    
    lazy var signInEmail: EmailTextField = {
        let signInEmail = EmailTextField()
        return signInEmail
    }()
    
    lazy var signInPassword: PasswordTextField = {
        let signInPassword = PasswordTextField()
        return signInPassword
    }()
    
    lazy var signInButton: UIButton = {
        let signInButton = UIButton(type: .system)
        signInButton.setTitle("Sign In", for: .normal)
        signInButton.setTitleColor(.white, for: .normal)
        signInButton.backgroundColor = .green
        signInButton.clipsToBounds = true
        signInButton.layer.cornerRadius = 20
        signInButton.addTarget(self, action: #selector(signInClicked), for: .touchUpInside)
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        return signInButton
    }()
    
    lazy var signUpLabel: UILabel = {
        let signUpLabel = UILabel()
        signUpLabel.text = "Don't have an account?"
        signUpLabel.textColor = .white
        signUpLabel.font = UIFont.systemFont(ofSize: 16)
        signUpLabel.translatesAutoresizingMaskIntoConstraints = false
        return signUpLabel
    }()
    
    lazy var goToSignUpVCButton: UIButton = {
        let goToSignUpVCButton = UIButton(type: .system)
        goToSignUpVCButton.setTitle("Sign Up", for: .normal)
        goToSignUpVCButton.setTitleColor(.white, for: .normal)
        goToSignUpVCButton.addTarget(self, action: #selector(goToSignUpVCButtonClicked), for: .touchUpInside)
        goToSignUpVCButton.translatesAutoresizingMaskIntoConstraints = false
        return goToSignUpVCButton
    }()
    
    // MARK: - Lifecycle Methods
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        notesImageView.layer.cornerRadius = notesImageView.frame.height / 2
        notesImageView.layer.borderWidth = 2.0
        notesImageView.layer.borderColor = UIColor.white.cgColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Actions
    @objc func signInClicked() {
        guard let email = signInEmail.text, !email.isEmpty,
              let password = signInPassword.text, !password.isEmpty else {
            makeAlert(titleInput: "Error", messageInput: "Please enter email and password.")
            return
        }
        
        let user = User(email: email, password: password)

        authManager.signInUser(user: user) { result in
            switch result {
            case .success:
                let homeVC = HomeViewController()
                homeVC.modalPresentationStyle = .fullScreen
                self.present(homeVC, animated: true, completion: nil)
            case .failure(let error):
                self.makeAlert(titleInput: "Error", messageInput: error.localizedDescription)
            }
        }
    }
    
    @objc func goToSignUpVCButtonClicked() {
        let SignUpVC = SignUpViewController()
        self.present(SignUpVC, animated: true, completion: nil)
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        let bounds = UIScreen.main.bounds
        let height = bounds.size.height
        let width = bounds.size.width
        
        view.setupGradientBackground()
        closeKeyboard()
        
        let uiElementsLogIn : [UIView] = [
            notesAppLabel,
            notesImageView,
            signInEmail,
            signInPassword,
            signInButton,
            signUpLabel,
            goToSignUpVCButton
        ]
        
        for element in uiElementsLogIn {
            view.addSubview(element)
        }
        
        notesAppLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(height * 0.12)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(width * 0.05)
        }
        
        notesImageView.snp.makeConstraints { make in
            make.top.equalTo(notesAppLabel.snp.top).inset(height * 0.08)
            make.centerX.equalToSuperview()
            make.height.equalTo(height * 0.27)
            make.width.equalTo(width * 0.60)
        }
        
        signInEmail.snp.makeConstraints { make in
            make.top.equalTo(notesImageView.snp.top).inset(height * 0.32)
            make.leading.trailing.equalToSuperview().inset(width * 0.05)
            make.height.equalTo(50)
            make.width.equalTo(width * 0.80)
        }
        
        signInPassword.snp.makeConstraints { make in
            make.top.equalTo(signInEmail.snp.top).inset(height * 0.08)
            make.leading.trailing.equalToSuperview().inset(width * 0.05)
            make.height.equalTo(50)
            make.width.equalTo(width * 0.80)
        }
        
        signInButton.snp.makeConstraints { make in
            make.top.equalTo(signInPassword.snp.top).inset(height * 0.12)
            make.leading.trailing.equalToSuperview().inset(width * 0.10)
            make.height.equalTo(50)
        }
        
        signUpLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(height * 0.05)
            make.leading.equalToSuperview().inset(width * 0.20)
        }
        
        goToSignUpVCButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(height * 0.045)
            make.leading.equalTo(signUpLabel.snp.leading).inset(width * 0.45)
        }
    }
}




