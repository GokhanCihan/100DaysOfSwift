//
//  ViewController.swift
//  Project2
//
//  Created by Gökhan on 14.06.2022.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var questionCounter = 0
    var highScore = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "score", style: .done, target: self, action: #selector(showScore))
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        button1.imageView?.layer.borderWidth = 2
        button2.imageView?.layer.borderWidth = 2
        button3.imageView?.layer.borderWidth = 2
        
        button1.imageView?.layer.borderColor = UIColor.lightGray.cgColor
        button2.imageView?.layer.borderColor = UIColor.lightGray.cgColor
        button3.imageView?.layer.borderColor = UIColor.lightGray.cgColor
        
        askQuestion()
        
        let defaults = UserDefaults.standard
        
        if let dataSaved = defaults.object(forKey: "highScore") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                highScore = try jsonDecoder.decode(Int.self, from: dataSaved)
            } catch {
                print("Failed to load data.")
            }
        }
    }

    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        //button.setImage assigns an image to the button
        //UIimage(named:) loads an image from an app bundle
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        title = "\(countries[correctAnswer].uppercased())"
    }
    

    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        
        if sender.tag == correctAnswer {
            title = "correct"
            score += 1
            questionCounter += 1
        } else {
            title = "\u{2757} Wrong\n You selected\n \(countries[sender.tag].uppercased())"
            score -= 1
            questionCounter += 1
        }
 
        let ac = UIAlertController(title: title, message: "", preferredStyle: .alert)
            
        if questionCounter == 10 {
            if score > highScore {
                ac.message = "Conguratulations!! You beat the highest score"
                self.save()
            } else {
                ac.message = "Your final score is \(score)"
            }
            
            ac.addAction(UIAlertAction(title: "restart", style: .default, handler: askQuestion))
            questionCounter = 0
            score = 0
        } else {
            ac.message = "Your score is \(score)"
            ac.addAction(UIAlertAction(title: "continue", style: .default, handler: askQuestion))
        }
        present(ac, animated: true)
    }
    
    @objc func showScore(){
        let ac = UIAlertController(title: "Score", message: "\(score)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "close", style: .cancel))
        present(ac, animated: true)
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        
        if let dataSave = try? jsonEncoder.encode(highScore) {
            let defaults = UserDefaults.standard
            defaults.set(dataSave, forKey: "highScore")
        } else {
            print("Failed to save data.")
        }
    }
}

