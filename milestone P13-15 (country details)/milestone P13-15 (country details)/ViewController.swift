//
//  ViewController.swift
//  milestone P13-15 (country details)
//
//  Created by Gökhan on 10.08.2022.
//

import UIKit

class ViewController: UITableViewController {
    var countries = [String: Dictionary<String, Any>]()
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            let selectedCountry = countryNames[indexPath.row]
            vc.flagEmoji = countries[selectedCountry]!["flag"] as? String
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    func parseData(json: Data) {
        let dataDecoder = JSONDecoder()
        do {
            let jsonCountries = try dataDecoder.decode([Country].self, from: json)
            
            for i in 0..<jsonCountries.count {
                var tempCountryDict = [String: Any]()
                tempCountryDict["unMember"] = jsonCountries[i].unMember
                
                var currencies = [String]()
                for currency in jsonCountries[i].currencies.values.enumerated() {
                    currencies.append(currency.element["name"]!)
                }
                
                tempCountryDict["currencies"] = jsonCountries[i].currencies.values
                tempCountryDict["capital"] = jsonCountries[i].capital
                tempCountryDict["region"] = jsonCountries[i].region
                tempCountryDict["subregion"] = jsonCountries[i].subregion
                tempCountryDict["language"] = jsonCountries[i].languages.values
                tempCountryDict["latlng"] = jsonCountries[i].latlng
                tempCountryDict["area"] = jsonCountries[i] .area
                tempCountryDict["flag"] = jsonCountries[i].flag
                
                countries[jsonCountries[i].name.common] = tempCountryDict
                countryNames.append(jsonCountries[i].name.common)
            }
        } catch{
            print(error)
        }
    }
}

