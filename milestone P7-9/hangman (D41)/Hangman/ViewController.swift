//
//  ViewController.swift
//  hangman (D41)
//
//  Created by Gökhan on 14.07.2022.
//

import UIKit

class ViewController: UIViewController {
    var wordView: UIView!
    var remainingLivesLabel: UILabel!
    var remainingLives = 7 {
        didSet{
            remainingLivesLabel.text = "Lives: \(remainingLives)"
        }
    }
    var instruction: UILabel!
    var keyboardView: UIView!
    var keyboardButtons = [UIButton]()
    var word = ""
    var letters = [String]()
    var wordViewLabels = [UILabel]()
    var lettersFound = 0
    
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        lettersFound = 0
        
        remainingLivesLabel = UILabel()
        remainingLivesLabel.translatesAutoresizingMaskIntoConstraints = false
        remainingLivesLabel.font = UIFont.systemFont(ofSize: 36)
        remainingLivesLabel.text = "Lives: \(remainingLives)"
        view.addSubview(remainingLivesLabel)
        
        
        instruction = UILabel()
        instruction.translatesAutoresizingMaskIntoConstraints = false
        instruction.font = UIFont.systemFont(ofSize: 36)
        instruction.textAlignment = .center
        instruction.text = "Tap to guess"
        view.addSubview(instruction)
        
        
        keyboardView = UIView()
        keyboardView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(keyboardView)
        
        NSLayoutConstraint.activate([
            remainingLivesLabel.heightAnchor.constraint(equalTo: instruction.heightAnchor),
            remainingLivesLabel.widthAnchor.constraint(equalToConstant: 200),
            remainingLivesLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            remainingLivesLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),
            instruction.widthAnchor.constraint(equalToConstant: 200),
            instruction.heightAnchor.constraint(equalToConstant: 80),
            instruction.centerXAnchor.constraint(equalTo: keyboardView.centerXAnchor),
            instruction.bottomAnchor.constraint(equalTo: keyboardView.topAnchor)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadLevel()
    }
    
    func loadLevel() {
        var words: [String]
        var numberOfLetters: Int
        letters = [""]
        letters.removeAll()
        
        wordView = UIView()
        wordView.translatesAutoresizingMaskIntoConstraints = false
        wordView.layer.borderColor = UIColor.lightGray.cgColor
        wordView.layer.borderWidth = 1
        view.addSubview(wordView)
        
        keyboardView = UIView()
        keyboardView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(keyboardView)
        
        NSLayoutConstraint.activate([
            wordView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.centerYAnchor, constant: -300),
            wordView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 175),
            keyboardView.heightAnchor.constraint(equalToConstant: 240),
            keyboardView.widthAnchor.constraint(equalToConstant: 1000),
            keyboardView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 175),
            keyboardView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -265)])
        
        if let fileURL = Bundle.main.url(forResource: "words", withExtension: "txt") {
            
            //MARK: -Load wordView
            //Get words from the file
            if let fileContent = try? String(contentsOf: fileURL) {
                words = fileContent.components(separatedBy: "\n")
                words.shuffle()
                word = words[0]
                print(word)
                numberOfLetters = word.count
                
                let wordViewLabelHeight = 80
                let wordViewLabelWidth = 1000 / numberOfLetters
              
                //wordView frame
                for col in 0..<numberOfLetters {
                    let wordViewLabel = UILabel()
                    wordViewLabel.font = UIFont.systemFont(ofSize: 44)
                    wordViewLabel.text = "_"
                    wordViewLabel.textAlignment = .center
                    wordViewLabel.layer.borderWidth = 1
                    wordViewLabel.layer.borderColor = UIColor.lightGray.cgColor
                    
                    
                    let frame = CGRect(x: wordViewLabelWidth * col, y: wordViewLabelHeight, width: wordViewLabelWidth, height: wordViewLabelHeight)
                    wordViewLabel.frame = frame
                    wordViewLabels.append(wordViewLabel)
                    wordView.addSubview(wordViewLabel)
                }
                
                for char in words[0] {
                    let letter = String(char)
                    letters.append(letter)
                }
            }
        }
        
        
        var keyboardLetters = [String]()
        for char in "QWERTYUIOPASDFGHJKLZXCVBNM"{
            let letter = String(char)
            keyboardLetters.append(letter)
        }
        
        let keyboardButtonsHeight = 80
        let keyboardButtonsWidth = 100
        //MARK: -Load keyboardView
        for col in 0..<10{
            let keyboardButton1 = UIButton(type: .system)
            keyboardButton1.titleLabel?.font = UIFont.systemFont(ofSize: 44)
            keyboardButton1.setTitle(keyboardLetters[col], for: .normal)
                
            let frame1 = CGRect(x: keyboardButtonsWidth * col, y: keyboardButtonsHeight * 0, width: keyboardButtonsWidth, height: keyboardButtonsHeight)
            keyboardButton1.frame = frame1
            keyboardButton1.layer.borderColor = UIColor.lightGray.cgColor
            keyboardButton1.layer.borderWidth = 1
            keyboardButtons.append(keyboardButton1)
            keyboardView.addSubview(keyboardButton1)
            keyboardButton1.addTarget(self, action: #selector(keyboardButtonTapped), for: .touchUpInside)
        }
        
        for col in 0..<9{
            let keyboardButton2 = UIButton(type: .system)
            keyboardButton2.setTitle(keyboardLetters[col+10], for: .normal)
            
            let frame2 = CGRect(x: (keyboardButtonsWidth * col) + 1 * keyboardButtonsWidth / 4, y: keyboardButtonsHeight * 1, width: keyboardButtonsWidth, height: keyboardButtonsHeight)
            keyboardButton2.frame = frame2
            keyboardButton2.titleLabel?.font = UIFont.systemFont(ofSize: 44)
            keyboardButton2.layer.borderColor = UIColor.lightGray.cgColor
            keyboardButton2.layer.borderWidth = 1
            keyboardButtons.append(keyboardButton2)
            keyboardView.addSubview(keyboardButton2)
            keyboardButton2.addTarget(self, action: #selector(keyboardButtonTapped), for: .touchUpInside)
        }
        
        for col in 0..<7{
            let keyboardButton3 = UIButton(type: .system)
            keyboardButton3.setTitle(keyboardLetters[col+19], for: .normal)
            
            let frame3 = CGRect(x: (keyboardButtonsWidth * col) + keyboardButtonsWidth, y: keyboardButtonsHeight * 2, width: keyboardButtonsWidth, height: keyboardButtonsHeight)
            keyboardButton3.frame = frame3
            keyboardButton3.titleLabel?.font = UIFont.systemFont(ofSize: 44)
            keyboardButton3.layer.borderColor = UIColor.lightGray.cgColor
            keyboardButton3.layer.borderWidth = 1
            keyboardButtons.append(keyboardButton3)
            keyboardView.addSubview(keyboardButton3)
            keyboardButton3.addTarget(self, action: #selector(keyboardButtonTapped), for: .touchUpInside)
        }
        
    }
    
    //MARK: -Functions
    
    
    @objc func keyboardButtonTapped (_ sender: UIButton){
        guard let buttonTitle = sender.titleLabel?.text else {return}
        
        if letters.contains(buttonTitle.lowercased()) {
            for (index, letter) in letters.enumerated() {
                if buttonTitle == letter.uppercased() {
                    wordViewLabels[index].text = letter.uppercased()
                    wordViewLabels[index].backgroundColor = .green
                    lettersFound += 1
                    if lettersFound == letters.count {
                        let ac = UIAlertController(title: "You Win!!!", message: nil, preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .cancel))
                        present(ac, animated: true)
                    }
                    sender.isHidden = true
                }
            }
        } else {
            sender.isHidden = true
            remainingLives -= 1
            if remainingLives == 0{
                let ac = UIAlertController(title: "You Died!", message: nil, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Play Again", style: .cancel, handler: {_ in
                    self.wordViewLabels.removeAll()
                    self.wordView.removeFromSuperview()
                    self.keyboardView.removeFromSuperview()
                    self.loadLevel()
                    self.remainingLives = 7
                }))
                present(ac, animated: true)
            }
        }
        
    }
    
    
    
}
        

