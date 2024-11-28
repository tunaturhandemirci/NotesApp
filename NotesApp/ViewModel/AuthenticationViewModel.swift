//
//  AuthenticationViewModel.swift
//  NotesApp
//
//  Created by Tuna Demirci on 26.11.2024.
//

import Foundation
import FirebaseAuth

class AuthenticationViewModel {
    
    func checkUserAuthentication(completion: @escaping (Bool) -> Void) {
        if Auth.auth().currentUser != nil {
            completion(true)
        } else {
            completion(false)
        }
    }
}
