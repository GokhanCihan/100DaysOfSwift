//
//  ViewController.swift
//  Project28-Secret-Swift
//
//  Created by Gökhan on 22.10.2022.
//

import LocalAuthentication
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var secret: UITextView!
    var password: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if KeychainWrapper.standard.string(forKey: "SecretMessagePassword") == nil {
            createPassword()
        }else {
            while true {
                verifyPassword()
            }
        }
        
        title = "Nothing to see here"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveSecretMessage))
        navigationItem.rightBarButtonItem?.isHidden = true
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        //adds an observer for running app on the background or switching to another app
        notificationCenter.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)
        
    }

    func unlockSecretMessage() {
        secret.isHidden = false
        navigationItem.rightBarButtonItem?.isHidden = false
        
        title = "Secret Text!"

        if let text = KeychainWrapper.standard.string(forKey: "SecretMessage") {
            secret.text = text
        }
        
    }
    
    @objc func saveSecretMessage() {
        guard secret.isHidden == false else { return }
        
        navigationItem.rightBarButtonItem?.isHidden = true

        KeychainWrapper.standard.set(secret.text, forKey: "SecretMessage")
        secret.resignFirstResponder()
        secret.isHidden = true
        title = "Nothing to see here"
    }
    
    @IBAction func authenticateTapped(_ sender: Any) {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Your idendity must be verified before reading this content."

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [weak self] success, authenticationError in

                DispatchQueue.main.async {
                    if success {
                        self?.unlockSecretMessage()
                    } else {
                        let ac = UIAlertController(title: "Authentication failed", message: "You could not be verified; please continue with password.", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self?.present(ac, animated: true)
                        
                        if ((self?.verifyPassword()) != nil) {
                            self?.unlockSecretMessage()
                        }
                    }
                }
            }
        } else {
            let ac = UIAlertController(title: "Biometry unavailable", message: "Your device is not configured for biometric authentication.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
    }
    
    func createPassword() {
        let ac = UIAlertController(title: "Create password", message: "This app asks you a password for each time it is started.", preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "OK", style: .default) {
            [weak ac] _ in
            if let newPassword = ac?.textFields?[0].text {
                KeychainWrapper.standard.set(newPassword, forKey: "SecretMessagePassword")
            }
        })
        
        self.present(ac, animated: true)
    }
    
    func verifyPassword() -> Bool {
        var isVerified = Bool()
        
        let ac = UIAlertController(title: "Password", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "OK", style: .default) {
            [weak ac] _ in
            if let input = ac?.textFields?[0].text {
                if input == KeychainWrapper.standard.string(forKey: "SecretMessagePassword") {
                    isVerified = true
                } else{
                    isVerified = false
                }
            }
        })
        self.present(ac, animated: true)
        
        return isVerified
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            secret.contentInset = .zero
        } else {
            secret.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        secret.scrollIndicatorInsets = secret.contentInset

        let selectedRange = secret.selectedRange
        secret.scrollRangeToVisible(selectedRange)
    }

}

