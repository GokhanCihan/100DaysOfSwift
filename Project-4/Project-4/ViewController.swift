//
//  ViewController.swift
//  Project-4
//
//  Created by Gökhan on 28.06.2022.
//

import UIKit

class ViewController: UITableViewController {
    var webSites = ["apple.com", "hackingwithswift.com", "twitter.com"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Websites"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        webSites.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Website", for: indexPath)
        cell.textLabel?.text = webSites[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedWebsite = webSites[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}


