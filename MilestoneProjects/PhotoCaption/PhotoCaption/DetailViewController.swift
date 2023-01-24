//
//  DetailViewController.swift
//  milestone P10-12
//
//  Created by Gökhan on 28.07.2022.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var selectedImage: URL?
    var imageTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = imageTitle
        navigationItem.largeTitleDisplayMode = .never
        
        if let imageData = try? Data(contentsOf: selectedImage!) {
            if let imageToLoad = UIImage(data: imageData) {
                imageView.image = imageToLoad
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
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
