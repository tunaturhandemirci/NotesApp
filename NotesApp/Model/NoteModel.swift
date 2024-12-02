//
//  NoteModel.swift
//  NotesApp
//
//  Created by Tuna Demirci on 2.12.2024.
//

import UIKit

class NoteModel {
    var title: String
    var content: String
    var date: Date
    var color: UIColor
    
    init(title: String, content: String, date: Date, color: UIColor) {
        self.title = title
        self.content = content
        self.date = date
        self.color = color
    }
}

