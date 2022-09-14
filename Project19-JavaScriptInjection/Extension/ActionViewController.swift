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
        self.title = "Saved Scripts"
        navigationItem.largeTitleDisplayMode = .never
        
        loadData()
        
        //default scripts
        if savedScripts.count == 0 {
            let titleScript = Script(scriptName: "alert page title", scriptText: "alert(document.title);")
            let URLScript = Script(scriptName: "alert page URL", scriptText: "alert(document.URL);")
            let helloScript = Script(scriptName: "say hi", scriptText: "alert('hello');")
            
            
            savedScripts.append(titleScript)
            savedScripts.append(URLScript)
            savedScripts.append(helloScript)
            saveData()
        }
        
        //runs choosen script
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addScript))

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
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedScripts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScriptCell", for: indexPath)
        let script = savedScripts[indexPath.row]
        cell.textLabel?.text = script.scriptName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        scriptToInject = savedScripts[indexPath.row].scriptText
        
        done()
    }
    
    
    //send back data to Safari, and it will appear inside the finalize() function in Action.js
    @IBAction func done() {
        let item = NSExtensionItem() //hosts our items
        let argument: NSDictionary = ["customJavaScript": scriptToInject!]
        
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJavaScript]
        
        extensionContext?.completeRequest(returningItems: [item])
    }
    
    //called after tapping + button, loads detailview
    @objc func addScript() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
    //userdefaults
    func loadData() {
        let defaults = UserDefaults.standard
        
        if let savedData = defaults.object(forKey: "savedScripts") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                savedScripts = try jsonDecoder.decode([Script].self, from: savedData)
            } catch {
                print("failed to load data")
            }
        }
    }
    func saveData() {
        let jsonEncoder = JSONEncoder()
        
        if let saveData = try? jsonEncoder.encode(savedScripts) as Data {
            let defaults = UserDefaults.standard
            defaults.set(saveData, forKey: "savedScripts")
        }
    }
}
