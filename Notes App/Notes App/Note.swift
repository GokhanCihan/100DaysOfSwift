//
//  Note.swift
//  Notes App
//
//  Created by Gökhan on 20.09.2022.
//

import UIKit

class Note: NSObject, Codable {
    var savedNoteTitle: String
    var savedDateEdited: String
    var savedBodyText: String
    var isSavedOnFolder: String
    
    init(savedNoteTitle: String, savedDateEdited: String, savedBodyText: String, isSavedOnFolder: String) {
        self.savedNoteTitle = savedNoteTitle
        self.savedDateEdited = savedDateEdited
        self.savedBodyText = savedBodyText
        self.isSavedOnFolder = isSavedOnFolder
    }
}
