//
//  ViewController.swift
//  Project1
//
//  Created by Gökhan on 9.06.2022.
//

import UIKit

class ViewController: UITableViewController {
    var pictures = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        performSelector(inBackground: #selector(loadPicturesFromBundle), with: nil)
    }
    
    @objc func loadPicturesFromBundle() {
        let fm = FileManager.default
                let path = Bundle.main.resourcePath!
                let items = try! fm.contentsOfDirectory(atPath: path)
                
                for item in items {
                    if item.hasPrefix("nssl") {
                        pictures.append(item)
                    }
                }
        pictures = pictures.sorted()
        performSelector(onMainThread: #selector(pushIntoMain), with: nil, waitUntilDone: false)
    }
    
    @objc func pushIntoMain(){
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row]
            vc.imagesTitle = "Picture \(indexPath.row+1) of \(pictures.count)"
            navigationController?.pushViewController(vc, animated: true)
            
        }
    }

}
