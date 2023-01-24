//
//  DetailViewController.swift
//  Notes App
//
//  Created by Gökhan on 19.09.2022.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var detailDate: UILabel!
    @IBOutlet var detailNoteTitle: UITextField!
    @IBOutlet var detailNoteBody: UITextView!
    
    var now = Date.now
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let detailedFormatter = DateFormatter()
        let clockFormatter = DateFormatter()
        detailedFormatter.dateFormat = "d MMMM y HH:mm"
        detailDate.text = detailedFormatter.string(from: now)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        
        self.navigationController?.isToolbarHidden = false
        
        var toolbar = [UIBarButtonItem]()
        
        toolbar.append(
            UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(remove))
        )
        toolbar.append(
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        )
        
        toolbarItems = toolbar

        // Do any additional setup after loading the view.
    }
    
    @objc func remove() {
        
    }
    
    @objc func done() {
        //save and exite
    }
}
