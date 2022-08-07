//
//  ViewController.swift
//  Project13
//
//  Created by Gökhan on 29.07.2022.
//

import CoreImage
import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var intensity: UISlider!
    @IBOutlet var radius: UISlider!
    @IBOutlet var scale: UISlider!
    @IBOutlet var center: UISlider!
    @IBOutlet var filterButton: UIButton!
    
    
    var currentImage: UIImage!
    
    var context: CIContext!
    var currentFilter: CIFilter!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "Image Filter"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
        
        context = CIContext()
        currentFilter = CIFilter(name: "CISepiaTone")
    }

    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        
        dismiss(animated: true)
        
        imageView.alpha = 0
        currentImage = image
        
        UIView.animate(withDuration: 2, delay: 0, options: [],
                       animations: {
            self.imageView.alpha = 1
        })
        
        let imageToFilter = CIImage(image: currentImage)
        currentFilter.setValue(imageToFilter, forKey: kCIInputImageKey)
        applyProcessing()
    }
    
    @IBAction func changeFilter(_ sender: Any) {
        let ac = UIAlertController(title: "Choose filter", message: nil, preferredStyle: .actionSheet)
            ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
            ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
            ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
            ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
            ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
            ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
            ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        center.maximumValue = Float(currentImage.size.width)
        center.minimumValue = Float(0)
        
            present(ac, animated: true)
    }
    
    func setFilter(action: UIAlertAction) {
        
        filterButton.setTitle(action.title, for: .normal)
        
        guard currentImage != nil else {return}
        
        guard let actionTitle = action.title else {return}
        
        currentFilter = CIFilter(name: actionTitle)
        
        let imageToFilter = CIImage(image: currentImage)
        currentFilter.setValue(imageToFilter, forKey: kCIInputImageKey)
        
        applyProcessing()
    }
    
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey)
            intensity.isHidden = false
        } else {
            intensity.isHidden = true
        }
        if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(radius.value * 200, forKey: kCIInputRadiusKey )
            radius.isHidden = false
        } else {
            radius.isHidden = true
        }
        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(scale.value * 10, forKey: kCIInputScaleKey )
            scale.isHidden = false
        } else {
            scale.isHidden = true
        }
        if inputKeys.contains(kCIInputCenterKey) { currentFilter.setValue(CIVector(x: currentImage.size.width - CGFloat(center.value), y: currentImage.size.height / 2), forKey: kCIInputCenterKey )
            center.isHidden = false
        } else {
            center.isHidden = true
        }
        if let cgImage = context.createCGImage(currentFilter.outputImage!, from: currentFilter.outputImage!.extent) {
        let processedImage = UIImage(cgImage: cgImage)
        self.imageView.image = processedImage
        }
        
    }
    
    @IBAction func Save(_ sender: Any) {
        guard let image = imageView.image else {
            let ac = UIAlertController(title: "Can not save!", message: "There is no image to save. Please choose an image.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            return}
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    @IBAction func intensityChanged(_ sender: Any) {
        applyProcessing()
    }
    
    @IBAction func radiusChanged(_ sender: Any) {
        applyProcessing()
    }
    
    @IBAction func scaleChanged(_ sender: Any) {
        applyProcessing()
    }
    
    @IBAction func centerChanged(_ sender: Any) {
        applyProcessing()
    }
    
}

