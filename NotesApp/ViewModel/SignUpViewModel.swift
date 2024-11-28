//
//  SignUpViewModel.swift
//  NotesApp
//
//  Created by Tuna Demirci on 26.11.2024.
//

import Foundation
import FirebaseAuth

// MARK: - Protocol
protocol SignUpViewModelProtocol {
    func signUpUser(user: User, completion: @escaping (Result<Void, Error>) -> Void)
}

// MARK: - ViewModel
class SignUpViewModel : SignUpViewModelProtocol {
    
    // MARK: - Firebase Signup
    func signUpUser(user: User, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().createUser(withEmail: user.email, password: user.password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}

