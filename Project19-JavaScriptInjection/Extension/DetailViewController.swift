//
//  DetailViewController.swift
//  Extension
//
//  Created by Gökhan on 9.09.2022.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var customScript: UITextView!
    var savedScripts = [Script]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "New Script"
        navigationItem.largeTitleDisplayMode = .never
        
        loadData()
        
        let notificationCenter = NotificationCenter.default
        
        //observer calls provided selector which takes specified notification as parameter from NSNotificationCenter
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveScript))

    }
    
    @objc func saveScript() {
        let ac = UIAlertController(title: "Name this script:", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak ac, weak self] _ in
            guard let createdName = ac?.textFields?[0].text else { return }
            
            let script = Script(scriptName: createdName, scriptText: (self?.customScript.text)!)
    
            print((self?.customScript.text)!)
            self?.savedScripts.append(script)
            self?.saveData()
        })
        present(ac, animated: true)
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
                customScript.contentInset = .zero
            } else {
                customScript.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
            }
    
        customScript.scrollIndicatorInsets = customScript.contentInset
    
        let selectedRange = customScript.selectedRange
        customScript.scrollRangeToVisible(selectedRange)
    }
    
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
