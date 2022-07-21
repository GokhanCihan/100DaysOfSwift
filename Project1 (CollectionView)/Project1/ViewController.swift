//
//  ViewController.swift
//  Project1
//
//  Created by Gökhan on 9.06.2022.
//

import UIKit

class ViewController: UICollectionViewController {
    var stormViewer = [Storm]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        performSelector(inBackground: #selector(loadPicturesFromBundle), with: nil)
    }
    
    @objc func loadPicturesFromBundle() {
        let fm = FileManager.default
                let path = Bundle.main.resourcePath!
                let items = try! fm.contentsOfDirectory(atPath: path)
                
                for item in items {
                    if item.hasPrefix("nssl") {
                        let storm = Storm(label: item, image: UIImage(named: item)!)
                        print(storm)
                        stormViewer.append(storm)
                    }
                }
        performSelector(onMainThread: #selector(pushIntoMain), with: nil, waitUntilDone: false)
        
        
    }
    
    @objc func pushIntoMain(){
        self.collectionView.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stormViewer.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Storm", for: indexPath) as? StormCell else {fatalError("Unable to dequeue StormCell")}
        
        let storm = stormViewer[indexPath.item]
        cell.label.text = storm.label
        cell.imageView.image = storm.image
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = stormViewer[indexPath.item].label
            vc.imagesTitle = "Picture \(indexPath.row+1) of \(stormViewer.count)"
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
