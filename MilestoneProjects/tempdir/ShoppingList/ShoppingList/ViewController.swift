//
//  ViewController.swift
//  ShoppingList
//
//  Created by Gökhan on 7.07.2022.
//

import UIKit

class ViewController: UITableViewController {
    var listOfItems = [String]()

    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Shopping List"
  
        //navigation
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(buttonTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteList))
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return the number of rows
        return listOfItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listItem", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = listOfItems[indexPath.row]
        return cell
    }
    
    @objc func buttonTapped() {
        let ac = UIAlertController(title: "Add Product", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let addProduct = UIAlertAction(title: "Add", style: .default){_ in
            guard let product = ac.textFields?[0].text else {return}
            self.submit(product)
        }
        
        ac.addAction(addProduct)
        present(ac, animated: true)
    }
    
    @objc func deleteList() {
        listOfItems.removeAll()
        tableView.reloadData()
    }
    
    func submit(_ answer: String) {
        listOfItems.insert(answer, at: 0)
        
        let indexpath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexpath], with: .automatic)
        
    }
    
    
}
