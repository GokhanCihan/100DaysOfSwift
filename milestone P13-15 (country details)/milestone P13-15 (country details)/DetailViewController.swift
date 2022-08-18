//
//  DetailViewController.swift
//  milestone P13-15 (country details)
//
//  Created by Gökhan on 14.08.2022.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var flag: UILabel!
    @IBOutlet var selectedCountryLabel: UILabel!
    var flagEmoji: String?
    var countryNameLabelText: String?
    var selectedCountryCapitals: Any?
    var selectedCountryCurrencies: Any?
    var selectedCountryLanguages: Any?
    var selectedCountryRegion: Any?
    var selectedCountrySubregion: Any?
    var selectedCountryLatLng: Any?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        flag.adjustsFontSizeToFitWidth = true
        flag.text = flagEmoji
        selectedCountryLabel.text = countryNameLabelText
        
        // Do any additional setup after loading the view.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
