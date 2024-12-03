//
//  HomeViewModel.swift
//  NotesApp
//
//  Created by Tuna Demirci on 2.12.2024.
//

import UIKit
import CoreData
import FirebaseAuth

class HomeViewModel {
   
    // MARK: - Properties
    var notes: [Notes] = []
    var reloadData: (() -> Void)?
    
    private var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    // MARK: - Fetch Notes
    func fetchNotes() {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("User is not logged in")
            return
        }
        let fetchRequest: NSFetchRequest<Notes> = Notes.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchRequest.predicate = NSPredicate(format: "userID == %@", userID)
        
        do {
            let fetchedNotes = try context.fetch(fetchRequest)
            self.notes = fetchedNotes
            reloadData?()
        } catch {
            print("Core Data fetch error: \(error)")
        }
    }
    
    // MARK: - Fetch User Info
    func fetchUserInfo(completion: @escaping (String?, UIImage?) -> Void) {
          guard let userID = Auth.auth().currentUser?.uid else {
              print("User is not logged in")
              completion(nil, nil)
              return
          }
          let fetchRequest: NSFetchRequest<UserInfo> = UserInfo.fetchRequest()
          fetchRequest.predicate = NSPredicate(format: "userID == %@", userID)

          do {
              let userInfo = try context.fetch(fetchRequest)
              if let user = userInfo.last {
                  let userName = user.userName ?? "No name"
                  var profileImage: UIImage? = nil
                  if let imageData = user.profileImage {
                      profileImage = UIImage(data: imageData)
                  }
                  completion(userName, profileImage)
              } else {
                  completion(nil, nil)
              }
          } catch {
              print("Failed to fetch user info: \(error)")
              completion(nil, nil)
          }
      }
    
    // MARK: - Delete Note
    func deleteNote(at index: Int) {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("User is not logged in")
            return
        }
        let noteToDelete = notes[index]
        
        if noteToDelete.userID == userID {
            context.delete(noteToDelete)
            do {
                try context.save()
                fetchNotes()
            } catch {
                print("Error deleting note: \(error)")
            }
        } else {
            print("Unauthorized attempt to delete another user's data.")
        }
    }
    
    // MARK: - Get Notes
    func getNoteCount() -> Int {
        return notes.count
    }
    
    func getNote(at index: Int) -> Notes {
        return notes[index]
    }
}
