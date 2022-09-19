//
//  ViewController.swift
//  Notes App
//
//  Created by Gökhan on 19.09.2022.
//

import UIKit

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //add number of rows to be shown
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as? NoteCell else {
            fatalError("Unable to dequeue NoteCell")
        }
        //title and other visuals for each cell
        cell.cellNoteTitle.text = "Title"
        cell.cellBodyText.text = "Text Body"
        cell.cellDateEdited.text = "Date"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            //add properties that must be passed into detail view
            navigationController?.pushViewController(vc, animated: true)
        }
    }


}

