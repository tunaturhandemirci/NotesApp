//
//  SignInViewModel.swift
//  NotesApp
//
//  Created by Tuna Demirci on 26.11.2024.
//

import UIKit
import FirebaseAuth

// MARK: - Protocol
protocol SignInViewModelProtocol {
    func signInUser(user: User, completion: @escaping (Result<Void, Error>) -> Void)
}

// MARK: - ViewModel
class SignInViewModel: SignInViewModelProtocol {
    
    // MARK: - SignIn Function
    func signInUser(user: User, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().signIn(withEmail: user.email, password: user.password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
