//
//  ViewController.swift
//  milestone P10-12
//
//  Created by Gökhan on 27.07.2022.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var photos = [Photo]()
    var ac = UIAlertController()

    override func viewDidLoad() {
        super.viewDidLoad()
        // load defaults here
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(addNewPhoto))
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Caption", for: indexPath)
        cell.textLabel?.text = photos[indexPath.row].caption
        return cell
    }
    
    //rename or show detail view
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if photos[indexPath.row].caption == "Unknown" {
            let ac = UIAlertController(title: "Rename photo as:", message: nil, preferredStyle: .alert)
            ac.addTextField()
            
            ac.addAction(UIAlertAction(title: "Save", style: .default) {[weak ac, weak self] _ in
                guard let newCaption = ac?.textFields?[0].text else {return}
                self?.photos[indexPath.row].caption = newCaption
                //call save()
                self?.tableView.reloadData()
            }
            )
            present(ac, animated: true)
        } else {
            if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
                vc.selectedImage = photos[indexPath.row].path
                vc.imageTitle = photos[indexPath.row].caption
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }

    @objc func addNewPhoto() {
        let picker = UIImagePickerController()
        print(picker)
        let camCheck = UIImagePickerController.isSourceTypeAvailable(.camera)
        if camCheck {
            picker.sourceType = .camera
        }
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else {return}
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let photo = Photo(path: imagePath, caption: "Unknown")

        //call save()
        self.photos.append(photo)
        dismiss(animated: true)
        self.tableView.reloadData()
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    //create save() function
}

