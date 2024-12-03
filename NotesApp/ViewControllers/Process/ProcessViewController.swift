//
//  ProcessViewController.swift
//  NotesApp
//
//  Created by Tuna Demirci on 28.11.2024.
//

import UIKit
import SnapKit
import MobileCoreServices

class ProcessViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Properties
    let authManager = AuthManager()
    let processViewModel: ProcessViewModel! = nil
    var onKeyboardHide: (() -> Void)?
    
    // MARK: - UI Elements
    lazy var processSaveButton: UIButton = {
        let processSaveButton = UIButton(type: .system)
        processSaveButton.setTitle("Save", for: .normal)
        processSaveButton.setTitleColor(.white, for: .normal)
        processSaveButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        processSaveButton.addTarget(self, action: #selector(saveButtonClicked), for: .touchUpInside)
        processSaveButton.translatesAutoresizingMaskIntoConstraints = false
        return processSaveButton
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
    
    lazy var selectProfilImageView : UIImageView = {
        let selectProfilImageView = UIImageView()
        selectProfilImageView.image = UIImage(systemName: "person.fill")
        selectProfilImageView.tintColor = .white
        selectProfilImageView.clipsToBounds = true
        selectProfilImageView.layer.cornerRadius = 30
        selectProfilImageView.layer.borderWidth = 2.0
        selectProfilImageView.layer.borderColor = UIColor.black.cgColor
        selectProfilImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectProfileImageTapped))
        selectProfilImageView.addGestureRecognizer(tapGesture)
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
    
    lazy var logOutButton: UIButton = {
        let logOutButton = UIButton(type: .system)
        logOutButton.setTitle("Log Out", for: .normal)
        logOutButton.setTitleColor(.black, for: .normal)
        logOutButton.backgroundColor = .white
        logOutButton.clipsToBounds = true
        logOutButton.layer.cornerRadius = 25
        logOutButton.addTarget(self, action: #selector(signOutUser), for: .touchUpInside)
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        return logOutButton
    }()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupKeyboardObservers()
    }
    
    // MARK: - Actions
    @objc func saveButtonClicked() {
        guard let userName = userNameTextField.text, !userName.isEmpty else {
            makeAlert(titleInput: "Error", messageInput: "Please enter username")
            return
        }
        if let profileImage = selectProfilImageView.image {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            let processViewModel = ProcessViewModel(context: context)
            processViewModel.saveUserInfo(userName: userName, profileImage: profileImage)
        }
        let homeVC = HomeViewController()
        homeVC.modalPresentationStyle = .fullScreen
        self.present(homeVC, animated: false, completion: nil)
    }
    
    @objc func exitButtonClicked() {
        let homeVC = HomeViewController()
        homeVC.modalPresentationStyle = .fullScreen
        present(homeVC, animated: false, completion: nil)
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
    
    // MARK: - ImagePicker
    @objc func selectProfileImageTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.mediaTypes = [kUTTypeImage as String]
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.editedImage] as? UIImage {
            selectProfilImageView.image = selectedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Keyboard Management
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            let bottomInset: CGFloat = 540
            view.frame.origin.y = -(keyboardHeight - bottomInset)
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        onKeyboardHide?()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        let bounds = UIScreen.main.bounds
        let height = bounds.size.height
        let width = bounds.size.width
        
        view.backgroundColor = .black
        closeKeyboard()
        
        let uiElementsProcess : [UIView] = [
            processSaveButton,
            exitButton,
            selectProfilImageView,
            userNameTextField,
            logOutButton
        ]
        
        for element in uiElementsProcess {
            view.addSubview(element)
        }
        
        processSaveButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(height * 0.015)
            make.leading.equalToSuperview().inset(width * 0.02)
            make.height.equalTo(50)
            make.width.equalTo(100)
        }
        
        exitButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(height * 0.02)
            make.trailing.equalToSuperview().inset(width * 0.04)
            make.width.height.equalTo(40)
        }
        
        selectProfilImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(height * 0.06)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(60)
        }
        
        userNameTextField.snp.makeConstraints { make in
            make.top.equalTo(selectProfilImageView.snp.top).inset(height * 0.09)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(width * 0.70)
        }
        
        logOutButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(height * 0.05)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(100)
        }
    }
}
