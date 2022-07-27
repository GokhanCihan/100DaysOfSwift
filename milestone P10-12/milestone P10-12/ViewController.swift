//
//  ViewController.swift
//  milestone P10-12
//
//  Created by Gökhan on 27.07.2022.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(addNewPhoto))
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Caption", for: indexPath)
        cell.textLabel?.text = "caption"
        return cell
    }

    @objc func addNewPhoto() {
        let picker = UIImagePickerController()
        let camCheck = UIImagePickerController.isSourceTypeAvailable(.camera)
        if camCheck {
            picker.sourceType = .camera
        }
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
}

