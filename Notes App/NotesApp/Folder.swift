//
//  Folder.swift
//  Notes App
//
//  Created by Gökhan on 20.09.2022.
//

import UIKit

class Folder: NSObject, Codable {
    var savedFolderName: String
    var savedNotes: [Note]
    
    init(savedFolderName: String, savedNotes: [Note]){
        self.savedFolderName = savedFolderName
        self.savedNotes = savedNotes        
    }
}
