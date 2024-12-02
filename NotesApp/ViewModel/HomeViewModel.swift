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
    var notes: [Notes] = []
    var reloadData: (() -> Void)?
    
    // Core Data context tanımlaması
    private var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    // Notları çekme fonksiyonu
    func fetchNotes() {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("User is not logged in")
            return
        }
        
        let fetchRequest: NSFetchRequest<Notes> = Notes.fetchRequest()
        
        // Tarihe göre sıralama
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Kullanıcıya ait notları çekmek için predicate ekleyelim
        fetchRequest.predicate = NSPredicate(format: "userID == %@", userID)
        
        do {
            let fetchedNotes = try context.fetch(fetchRequest)
            self.notes = fetchedNotes
            reloadData?()
        } catch {
            print("Core Data fetch error: \(error)")
        }
    }
    
    // Kullanıcı bilgilerini çekme fonksiyonu
    func fetchUserInfo() {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("User is not logged in")
            return
        }
        
        let fetchRequest: NSFetchRequest<UserInfo> = UserInfo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userID == %@", userID)
        
        do {
            let userInfo = try context.fetch(fetchRequest)
            if let user = userInfo.first {
                // Kullanıcı bilgileri burada
                print("User name: \(user.userName ?? "No name")")
                if let imageData = user.profileImage, let image = UIImage(data: imageData) {
                    // Profil resmini kullanabilirsiniz
                    print("Profile image: \(image)")
                }
            }
        } catch {
            print("Failed to fetch user info: \(error)")
        }
    }
    
    // Not sayısını döndüren fonksiyon
    func getNoteCount() -> Int {
        return notes.count
    }
    
    // Belirli bir notu döndüren fonksiyon
    func getNote(at index: Int) -> Notes {
        return notes[index]
    }
    
    // Not silme fonksiyonu
    func deleteNote(at index: Int) {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("User is not logged in")
            return
        }
        
        let noteToDelete = notes[index]
        
        // Silinecek notun userID'si ile karşılaştırma yapın
        if noteToDelete.userID == userID {
            context.delete(noteToDelete)
            do {
                try context.save()
                // Silme işleminden sonra verileri tekrar çek
                fetchNotes()
            } catch {
                print("Error deleting note: \(error)")
            }
        } else {
            print("Unauthorized attempt to delete another user's data.")
        }
    }
}
