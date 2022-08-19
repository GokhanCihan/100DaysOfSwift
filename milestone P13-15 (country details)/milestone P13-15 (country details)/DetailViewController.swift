//
//  DetailViewController.swift
//  milestone P13-15 (country details)
//
//  Created by Gökhan on 14.08.2022.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var flag: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var capitalsLabel: UILabel!
    @IBOutlet var currenciesLabel: UILabel!
    @IBOutlet var languagesLabel: UILabel!
    
    var flagEmoji: String?
    var countryNameLabelText: String?
    var selectedCountryCapitals: [String]?
    var selectedCountryCurrencies: [String]?
    var selectedCountryLanguages: [String]?
    var selectedCountryRegion: String?
    var selectedCountrySubregion: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        flag.adjustsFontSizeToFitWidth = true
        flag.text = flagEmoji
        title = countryNameLabelText
        locationLabel.text = "\(selectedCountrySubregion!)/\(selectedCountryRegion!)"
        capitalsLabel.text = enumerateArray(selectedCountryCapitals!)
        currenciesLabel.text = enumerateArray(selectedCountryCurrencies!)
        languagesLabel.text = enumerateArray(selectedCountryLanguages!)
        }
    
    func enumerateArray(_ items: Array<String>) -> String {
        var resultingString = ""
        for item in items.enumerated() {
            resultingString += "\(item.element)   "
        }
        return resultingString
    }
}

