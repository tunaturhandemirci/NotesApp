//
//  SignUpViewController.swift
//  NotesApp
//
//  Created by Tuna Demirci on 26.11.2024.
//

import UIKit
import SnapKit

class SignUpViewController: UIViewController {
   
    // MARK: - Properties
    var signUpViewModel : SignUpViewModelProtocol!
    
    // MARK: - UI Elements
    lazy var signUpEmail: EmailTextField = {
        let signUpEmail = EmailTextField()
        return signUpEmail
    }()
    
    lazy var signUpPassword: PasswordTextField = {
        let signUpPassword = PasswordTextField()
        return signUpPassword
    }()
    
    lazy var signUpButton: UIButton = {
        let signUpButton = UIButton(type: .system)
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.backgroundColor = .blue
        signUpButton.layer.cornerRadius = 20
        signUpButton.addTarget(self, action: #selector(signUpButtonClicked), for: .touchUpInside)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        return signUpButton
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        signUpViewModel = SignUpViewModel()
    }
    
    // MARK: - Actions
    @objc func signUpButtonClicked() {
        guard let email = signUpEmail.text, !email.isEmpty,
              let password = signUpPassword.text, !password.isEmpty else {
            makeAlert(titleInput: "Error", messageInput: "Please enter email and password.")
            return
        }
        
        let user = User(email: email, password: password)
        
        signUpViewModel.signUpUser(user: user) { result in
            switch result {
            case .success:
                let logInVC = LogInViewController()
                logInVC.modalPresentationStyle = .fullScreen
                self.present(logInVC, animated: true, completion: nil)
            case .failure(let error):
                self.makeAlert(titleInput: "Error", messageInput: error.localizedDescription )
            }
        }
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        let bounds = UIScreen.main.bounds
        let height = bounds.size.height
        let width = bounds.size.width
        
        view.setupGradientBackground()
        closeKeyboard()
        
       let uiElementsSignUp : [UIView] = [
            signUpEmail,
            signUpPassword,
            signUpButton
        ]
        
        for element in uiElementsSignUp {
            view.addSubview(element)
        }
        
        signUpEmail.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(height * 0.32)
            make.leading.trailing.equalToSuperview().inset(width * 0.05)
            make.height.equalTo(50)
            make.width.equalTo(width * 0.80)
        }
        
        signUpPassword.snp.makeConstraints { make in
            make.top.equalTo(signUpEmail.snp.top).inset(height * 0.08)
            make.leading.trailing.equalToSuperview().inset(width * 0.05)
            make.height.equalTo(50)
            make.width.equalTo(width * 0.80)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(signUpPassword.snp.top).inset(height * 0.12)
            make.leading.trailing.equalToSuperview().inset(width * 0.10)
            make.height.equalTo(50)
        }
    }
}
