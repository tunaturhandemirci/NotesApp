//
//  HomeViewController.swift
//  NotesApp
//
//  Created by Tuna Demirci on 23.11.2024.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {
    
    lazy var logOutButton: UIButton = {
        let logOutButton = UIButton(type: .system)
        logOutButton.setTitle("log out", for: .normal)
        logOutButton.setTitleColor(.white, for: .normal)
        logOutButton.backgroundColor = .green
        logOutButton.layer.cornerRadius = 20
        logOutButton.addTarget(self, action: #selector(signOutUser), for: .touchUpInside)
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        return logOutButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .orange
        setupUI()
    }
    
    @objc func signOutUser() {
        do {
            try Auth.auth().signOut()
            let logInVC = LogInViewController()
            logInVC.modalPresentationStyle = .fullScreen
            self.present(logInVC, animated: true, completion: nil)
        } catch let error {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
    
    private func setupUI() {
        
        view.addSubview(logOutButton)
        
        logOutButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(100)
            make.top.bottom.equalToSuperview().inset(300)
        }
    }
}
