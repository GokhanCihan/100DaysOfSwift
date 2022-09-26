c//
//  ViewController.swift
//  Project1
//
//  Created by Gökhan on 9.06.2022.
//

import UIKit

class ViewController: UITableViewController {
    var pictures = [String]()
    var viewsCount = [Int]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let fm = FileManager.default
                let path = Bundle.main.resourcePath!
                let items = try! fm.contentsOfDirectory(atPath: path)
                
                for item in items {
                    if item.hasPrefix("nssl") {
                        pictures.append(item)
                    }
                }
        for _ in 0..<pictures.count{
            viewsCount.append(0)
        }
        
        let defaults = UserDefaults.standard
        
        if let loadData = defaults.object(forKey: "viewsCount") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                viewsCount = try jsonDecoder.decode([Int].self, from: loadData)
            } catch {
                print("Load failed")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = "\(pictures[indexPath.row]): viewed \(viewsCount[indexPath.row]) times"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let removedCount = viewsCount.remove(at: indexPath.row)
        viewsCount.insert(removedCount + 1, at: indexPath.row)
        self.save()
        self.tableView.reloadData()
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row]
            vc.imagesTitle = "Picture \(indexPath.row+1) of \(pictures.count)"
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(viewsCount) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "viewsCount")
        } else {
            print("Save Failed")
        }
    }
}
