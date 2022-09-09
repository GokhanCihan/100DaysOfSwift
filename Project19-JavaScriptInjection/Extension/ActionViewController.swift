//
//  ActionViewController.swift
//  Extension
//
//  Created by Gökhan on 6.09.2022.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

class ActionViewController: UIViewController {
    @IBOutlet var script: UITextView!
    var pageTitle = ""
    var pageURL = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let notificationCenter = NotificationCenter.default
        //observer calls provided selector which takes specified notification as parameter from NSNotificationCenter
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
    
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
               if let itemProvider = inputItem.attachments?.first {
                   itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict, error) in
                       guard let itemDictionary = dict as? NSDictionary else { return }
                       guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
                       
                       self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                       self?.pageURL = javaScriptValues["URL"] as? String ?? ""
                       
                       DispatchQueue.main.async {
                           self?.title = self?.pageTitle
                       }
                   }
               }
           }
    }

    
    @IBAction func done() {
        //send back data to Safari, and it will appear inside the finalize() function in Action.js
        let item = NSExtensionItem() //hosts our items
        let argument: NSDictionary = ["customJavaScript": script.text!]
        
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJavaScript]
        
        print("\n \n \n \n \n \([item])")
        extensionContext?.completeRequest(returningItems: [item])
    }

    @objc func adjustForKeyboard(notification: Notification) {
        //Recieved function parameter is of type Notification
        
        //since arrays and dictionaries in Obj.-C can not contain CGRect it is stored as NSValue
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        //cgRectValue used to read NSValue as a CGRect object
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        //convert() flips CGRect object's frame width and height so that rotating the device would not cause any problem
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
                script.contentInset = .zero
            } else {
                script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
            }
        
        script.scrollIndicatorInsets = script.contentInset
        
        let selectedRange = script.selectedRange
        script.scrollRangeToVisible(selectedRange)
    }
}
