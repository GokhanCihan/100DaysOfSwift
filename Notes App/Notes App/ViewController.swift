//
//  ViewController.swift
//  Notes App
//
//  Created by Gökhan on 19.09.2022.
//

import UIKit

class ViewController: UITableViewController {
    var folders = [Folder]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let note = Note(savedNoteTitle: "Note Title", savedDateEdited: "20.09.2022", savedBodyText: "Lorem ipsum lorem vsvs and vsvssvs for vs")
        
        let folder = Folder(savedFolderName: "First Note Folder", savedNotes: [Note]())
        
        folder.savedNotes.append(note)
        folders.append(folder)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //add number of rows to be shown
        return folders.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FolderCell", for: indexPath) as? FolderCell else {
            fatalError("Unable to dequeue FolderCell")
        }
        //title and other visuals for each cell
        cell.cellFolderTitle.text = folders[indexPath.row].savedFolderName
        cell.cellFolderImage.image = nil
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "NotesInFolder") as? NotesTableViewController {
            vc.notes = folders[indexPath.row].savedNotes
            navigationController?.pushViewController(vc, animated: true)
        }
    }


}

