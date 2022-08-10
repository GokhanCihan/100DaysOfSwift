//
//  ViewController.swift
//  Project7
//
//  Created by Gökhan on 8.07.2022.
//

import UIKit

class ViewController: UITableViewController {
    
    var petitions = [Petition]()
    var savedPetitions = [Petition]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let urlString: String
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(showCredits))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(askForPrompt))
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString){
            if let data = try? Data(contentsOf: url){
                parseData(json: data)
                return
            }
        }
        showError()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func showCredits(){
        let ac = UIAlertController(title: "Data Source", message: "This data loaded from We The People API of the Whitehouse", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    @objc func askForPrompt(){
        let ac = UIAlertController(title: "Type to Search", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let handleTypedText = UIAlertAction(title: "Search", style: .default)
        {[weak self, weak ac] action in
            guard let typedText = ac?.textFields?[0].text else {return}
            self?.searchTyped(typedText)
        }
        
        ac.addAction(handleTypedText)
        present(ac, animated: true)
    }
    
    func showError() {
        let ac = UIAlertController(title: "Load Error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func parseData(json: Data) {
        let dataDecoder = JSONDecoder()
        
        if let jsonPetitions = try? dataDecoder.decode(Petitions.self, from: json){
            petitions = jsonPetitions.results
            tableView.reloadData()
            print(jsonPetitions)
        }
    }
    
    func searchTyped(_ typedText: String) {
        savedPetitions = petitions
        DispatchQueue.global(qos: .background).async {
            self.petitions = self.petitions.filter{$0.title.contains(typedText)}
            DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.petitions = self.savedPetitions
                    }
        }
        
    }
}

