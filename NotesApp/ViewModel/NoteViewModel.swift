//
//  NoteViewModel.swift
//  NotesApp
//
//  Created by Tuna Demirci on 2.12.2024.
//

import UIKit
import CoreData
import FirebaseAuth

class NoteViewModel {
    private var context: NSManagedObjectContext
    var onSaveNote: (() -> Void)?
    var onError: ((String) -> Void)?
    
    // MARK: - Initializer
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: - Save Note
    func saveNote(title: String, content: String, color: UIColor) {
        //
        guard let userID = Auth.auth().currentUser?.uid else {
              print("User is not logged in")
              return
          }
        //
        guard !title.isEmpty else {
            onError?("Title cannot be empty.")
            return
        }
        
        guard !content.isEmpty else {
            onError?("Content cannot be empty.")
            return
        }
        
        let newNote = NSEntityDescription.insertNewObject(forEntityName: "Notes", into: context)
        newNote.setValue(title, forKey: "title")
        newNote.setValue(content, forKey: "content")
        newNote.setValue(Date(), forKey: "date")
        newNote.setValue(UUID(), forKey: "id")
        //
        newNote.setValue(userID, forKey: "userID")
        
        if let colorData = try? NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false) {
            newNote.setValue(colorData, forKey: "color")
        }
        
        do {
            try context.save()
            onSaveNote?()
        } catch {
            onError?("Failed to save note.")
        }
    }
}

