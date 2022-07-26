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
        load()
        //implement cell layout
        let nib = UINib(nibName: "FolderCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "FolderCell")
        
        //create toolbar
        self.navigationController?.isToolbarHidden = false
        
        var toolbar = [UIBarButtonItem]()
        
        toolbar.append(
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        )
        toolbar.append(
            UIBarButtonItem(image: UIImage(systemName: "folder.badge.plus"), style: .plain, target: self, action: #selector(askFolderName))
        )
        toolbarItems = toolbar
        
        if folders.count == 0 {
            let folder = Folder(savedFolderName: "All notes", savedNotes: [Note]())
            folders.append(folder)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //add number of rows
        return folders.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FolderCell", for: indexPath) as? FolderCell
        else {
            fatalError("Unable to dequeue FolderCell")
        }
        //title and other visuals for each cell
        cell.cellFolderTitle.text = folders[indexPath.row].savedFolderName
        cell.cellFolderImage.image = UIImage(systemName: "folder")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "NotesInFolder") as? NotesTableViewController {
            vc.thisFolder = folders.remove(at: indexPath.row)
            vc.folders = folders
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func askFolderName() {
        let ac = UIAlertController(title: "New Folder", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let askName = UIAlertAction(title: "Create", style: .default) { [weak self, weak ac] action in
            guard let input = ac?.textFields?[0].text else { return }
            self?.createNewFolder(withFolderName: input)
        }
        
        ac.addAction(askName)
        present(ac, animated: true)
    }
    
    func createNewFolder(withFolderName: String) {
        let newFolder = Folder(savedFolderName: withFolderName, savedNotes: [Note]())
        folders.append(newFolder)
        save()
        tableView.reloadData()
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(folders) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "folders")
        } else {
            print("save failed")
        }
    }
    
    func load() {
        let defaults = UserDefaults.standard
        
        if let savedData = defaults.object(forKey: "folders") as? Data {
            let jsonDecoder = JSONDecoder()
            do {
                folders = try jsonDecoder.decode([Folder].self, from: savedData)
            } catch {
                print("load failed")
            }
        }
    }
}

