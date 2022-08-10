//
//  ViewController.swift
//  milestone P13-15 (country details)
//
//  Created by Gökhan on 10.08.2022.
//

import UIKit

class ViewController: UIViewController {
    var countries = [Country]()
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
    
    func parseData(json: Data) {
        let dataDecoder = JSONDecoder()
        do {
            let jsonCountries = try dataDecoder.decode([Country].self, from: json)
            print(jsonCountries)
        } catch{
            print(error)
        }
        
    }
}

