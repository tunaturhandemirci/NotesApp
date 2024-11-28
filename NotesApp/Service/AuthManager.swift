//
//  AuthManager.swift
//  NotesApp
//
//  Created by Tuna Demirci on 28.11.2024.
//

import Foundation
import FirebaseAuth

class AuthManager {
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
    // MARK: - Firebase SignIn
    func signInUser(user: User, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().signIn(withEmail: user.email, password: user.password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    // MARK: - Firebase SignOut
    func signOut(completion: @escaping (Result<Bool, Error>) -> Void) {
           do {
               try Auth.auth().signOut()
               completion(.success(true))
           } catch {
               completion(.failure(error))
           }
       }
    // MARK: - Firebase CurrentUser
    func checkUserAuthentication(completion: @escaping (Bool) -> Void) {
        if Auth.auth().currentUser != nil {
            completion(true)
        } else {
            completion(false)
        }
    }
}

