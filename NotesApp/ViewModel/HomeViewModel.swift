//
//  HomeViewModel.swift
//  NotesApp
//
//  Created by Tuna Demirci on 2.12.2024.
//

import UIKit
import CoreData

class HomeViewModel {
    var notes : [Notes] = []
    var reloadData : (() -> Void)?
    
    func fetchNotes() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest : NSFetchRequest<Notes> = Notes.fetchRequest()
        
        do {
            let fetchedNotes = try context.fetch(fetchRequest)
            self.notes = fetchedNotes
            reloadData?()
        } catch {
            print("Core Data fetch error: \(error)")
        }
    }
    
    func getNoteCount() -> Int {
        return notes.count
    }
    
    func getNote(at index: Int) -> Notes {
        return notes[index]
    }
}
