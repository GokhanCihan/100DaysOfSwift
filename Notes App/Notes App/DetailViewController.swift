//
//  DetailViewController.swift
//  Notes App
//
//  Created by Gökhan on 19.09.2022.
//

import UIKit

class DetailViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
