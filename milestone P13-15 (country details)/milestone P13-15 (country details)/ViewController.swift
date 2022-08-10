//
//  ViewController.swift
//  milestone P13-15 (country details)
//
//  Created by Gökhan on 10.08.2022.
//

import UIKit

class ViewController: UITableViewController {
    var countries = [Country]()
    var countryNames = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
            if let bundlePath = Bundle.main.path(forResource: "countries", ofType: "json") {
                do {
                    let jsonData = try Data(contentsOf: URL(fileURLWithPath: bundlePath))
                    parseData(json: jsonData)
                } catch {
                    print("error")
                }
                
            }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "\(countryNames[indexPath.row])"
        return cell
    }

    func parseData(json: Data) {
        let dataDecoder = JSONDecoder()
        do {
            let jsonCountries = try dataDecoder.decode([Country].self, from: json)
            countries = jsonCountries
            
            for i in 0..<countries.count {
                countryNames.append(countries[i].name.common)
            }
            
            print(jsonCountries.count)
        } catch{
            print(error)
        }
    }
}

