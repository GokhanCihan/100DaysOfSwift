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
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypeIdentifierKey as String)
        item.attachments = [customJavaScript]
        
        print("\n \n \n \n \n \([item])")
        extensionContext?.completeRequest(returningItems: [item])
    }

}
