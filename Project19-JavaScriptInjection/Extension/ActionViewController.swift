//
//  ActionViewController.swift
//  Extension
//
//  Created by Gökhan on 6.09.2022.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

// calls actionView when extension is choosen
class ActionViewController: UITableViewController {
    var savedScripts = [Script]()
    var pageTitle = ""
    var pageURL = ""
    var scriptToInject: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Run Script to"
        
        //default scripts
        if savedScripts.count == 0 {
            var titleScript = Script()
            var URLScript = Script()
            
            titleScript.action = "alert site title"
            titleScript.text = "alert(document.title);"
            URLScript.action = "alert site URL"
            URLScript.text = "alert(document.URL);"
            
            savedScripts.append(titleScript)
            savedScripts.append(URLScript)
        }
        
        //runs typed script
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        
        //runs choosen script
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createScript))

        //pulls information from website JS
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first {
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict, error) in
                    guard let itemDictionary = dict as? NSDictionary else { return }
                    guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
                       
                    self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                    self?.pageURL = javaScriptValues["URL"] as? String ?? ""
            
                }
            }
        }
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedScripts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScriptCell", for: indexPath)
        let script = savedScripts[indexPath.row]
        cell.textLabel?.text = script.action
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        scriptToInject = savedScripts[indexPath.row].text
        done()
    }
    
    @IBAction func done() {
        //send back data to Safari, and it will appear inside the finalize() function in Action.js
        let item = NSExtensionItem() //hosts our items
        let argument: NSDictionary = ["customJavaScript": scriptToInject!]
        
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJavaScript]
        
        extensionContext?.completeRequest(returningItems: [item])
    }
    
    @objc func createScript() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
