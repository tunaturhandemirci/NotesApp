//
//  ProcessViewModel.swift
//  NotesApp
//
//  Created by Tuna Demirci on 2.12.2024.
//

import UIKit
import CoreData
import FirebaseAuth

class ProcessViewModel {
    private var context: NSManagedObjectContext
    var onSaveNote: (() -> Void)?
    var onError: ((String) -> Void)?
    
    // MARK: - Initializer
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: - Save User Info
    func saveUserInfo(userName: String, profileImage: UIImage) {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("User is not logged in")
            return
        }
        guard !userName.isEmpty else {
            onError?("User name cannot be empty.")
            return
        }
        guard let imageData = profileImage.jpegData(compressionQuality: 1.0) else {
            onError?("Failed to convert image.")
            return
        }
        
        let newUserInfo = NSEntityDescription.insertNewObject(forEntityName: "UserInfo", into: context)
        
        newUserInfo.setValue(userName, forKey: "userName")
        newUserInfo.setValue(imageData, forKey: "profileImage")
        newUserInfo.setValue(userID, forKey: "userID")
        
        do {
            try context.save()
            print("User information saved successfully.")
        } catch {
            onError?("Failed to save user information.")
        }
    }
}
