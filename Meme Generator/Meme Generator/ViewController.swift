//
//  ViewController.swift
//  Meme Generator
//
//  Created by Gökhan on 19.10.2022.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    var memeImages = [UIImage]()
    var rawMemeImage = UIImage()
    var toolbar = [UIBarButtonItem]()
    
    enum toolbarItem {
        case photo
        case topText
        case bottomText
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Meme Generator"
        
        navigationController?.isToolbarHidden = false
        
        toolbar.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: .none, action: .none))
        toolbar.append(UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importPicture)))
        toolbar.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: .none, action: .none))
        toolbarItems = toolbar
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memeImages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageView", for: indexPath)
        
        if let imageView = cell.viewWithTag(1000) as? UIImageView {
                imageView.image = memeImages[indexPath.item]
            }
        return cell
    }
    
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 300, height: 200))
        
        let scaledImage = renderer.image { ctx in
            image.draw(in: CGRect(x: 0, y: 0, width: 300, height: 200))
        }
        
        memeImages.insert(scaledImage, at: 0)
        self.collectionView.reloadData()
        changeToolbar(with: .topText)
        
        dismiss(animated: true)
    }
    
    @objc func promptTopText() {
        var topText = String()
        
        let ac = UIAlertController(title: nil, message: "This text will appear at the top of your meme", preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "OK", style: .default) {[weak ac] _ in
            if let typedText = ac?.textFields?[0].text {
                topText = typedText
                
                let renderer = UIGraphicsImageRenderer(size: CGSize(width: 300, height: 200))
                
                let imageWithTopText = renderer.image { ctx in
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.alignment = .center
                    
                    let attrs: [NSAttributedString.Key: Any] = [
                        .font: UIFont.boldSystemFont(ofSize: 18),
                        .strokeColor: UIColor.black.cgColor,
                        .strokeWidth: CGFloat(-2),
                        .foregroundColor: UIColor(white: 1, alpha: 1),
                        .paragraphStyle: paragraphStyle
                    ]
                    
                    let attributedTopText = NSAttributedString(string: topText, attributes: attrs)
                    
                    self.memeImages[0].draw(at: CGPoint(x: 0, y: 0))
                    attributedTopText.draw(with: CGRect(x: 10, y: 10, width: 280, height: 50), options: .usesLineFragmentOrigin, context: nil)
                }
                
                self.memeImages.remove(at: 0)
                self.memeImages.insert(imageWithTopText, at: 0)
                self.collectionView.reloadData()
            }
        })
        
        self.present(ac, animated: true)
        changeToolbar(with: .bottomText)
    }
    
    @objc func promptBottomText() {
        var bottomText = String()
        
        let ac = UIAlertController(title: nil, message: "This text will appear at the bottom of your meme", preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "OK", style: .default) {[weak ac] _ in
            if let typedText = ac?.textFields?[0].text {
                bottomText = typedText
                
                let renderer = UIGraphicsImageRenderer(size: CGSize(width: 300, height: 200))
                
                let imageWithBottomText = renderer.image { ctx in
                    
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.alignment = .center
                    
                    let attrs: [NSAttributedString.Key: Any] = [
                        .font: UIFont.boldSystemFont(ofSize: 18),
                        .strokeColor: UIColor.black.cgColor,
                        .strokeWidth: CGFloat(-2),
                        .foregroundColor: UIColor(white: 1, alpha: 1),
                        .paragraphStyle: paragraphStyle
                    ]
                    
                    let attributedBottomText = NSAttributedString(string: bottomText, attributes: attrs)
                    
                    self.memeImages[0].draw(at: CGPoint(x: 0, y: 0))
                    attributedBottomText.draw(with: CGRect(x: 10, y: 150, width: 280, height: 50), options: .usesLineFragmentOrigin, context: nil)
                }
                
                self.memeImages.remove(at: 0)
                self.memeImages.insert(imageWithBottomText, at: 0)
                self.collectionView.reloadData()
                
            }
        })
        self.present(ac, animated: true)
        changeToolbar(with: .photo)
    }
    
    func changeToolbar(with toolbarItem: toolbarItem) {
        toolbar.remove(at: 1)
        
        if toolbarItem == .photo {
            toolbar.insert((UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importPicture))), at: 1)
        }
        if toolbarItem == .topText {
            toolbar.insert(UIBarButtonItem(title: "Add top text", image: .none, target: self, action: #selector(promptTopText)), at: 1)
        }
        if toolbarItem == .bottomText {
            toolbar.insert(UIBarButtonItem(title: "Add bottom text", image: .none, target: self, action: #selector(promptBottomText)), at: 1)
            
        }
        
        toolbarItems = toolbar
    }

}

