//
//  ViewController.swift
//  Project8
//
//  Created by Gökhan on 10.07.2022.
//

import UIKit

class ViewController: UIViewController {
    var cluesLabel: UILabel!
    var answersLabel: UILabel!
    var scoreLabel: UILabel!
    var currentAnswer: UITextField!
    var letterButtons = [UIButton]()
    var activatedButtons = [UIButton]()
    var solutions = [String]()
    var wordsFound = 0
    var score = 0 {
        didSet{
            scoreLabel.text = "Score: \(score)"
        }
    }
    var level = 1
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        //MARK: - Labels
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.font = UIFont.systemFont(ofSize: 20)
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: 0"
        view.addSubview(scoreLabel)
        
        cluesLabel = UILabel()
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        cluesLabel.text = "CLUES"
        cluesLabel.numberOfLines = 0
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(cluesLabel)
        
        answersLabel = UILabel()
        answersLabel.translatesAutoresizingMaskIntoConstraints = false
        answersLabel.font = UIFont.systemFont(ofSize: 24)
        answersLabel.text = "ANSWERS"
        answersLabel.numberOfLines = 0
        answersLabel.textAlignment = .right
        answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(answersLabel)
        
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        currentAnswer.isUserInteractionEnabled = false
        currentAnswer.placeholder = "Tap letters to answer"
        view.addSubview(currentAnswer)
        
        let submitButton = UIButton(type: .system)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.setTitle("SUBMIT", for: .normal)
        submitButton.layer.borderColor = UIColor.lightGray.cgColor
        submitButton.layer.borderWidth = 1
        view.addSubview(submitButton)
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        
        let clearButton = UIButton(type: .system)
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        clearButton.setTitle("CLEAR", for: .normal)
        clearButton.layer.borderColor = UIColor.lightGray.cgColor
        clearButton.layer.borderWidth = 1
        view.addSubview(clearButton)
        clearButton.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        
        //MARK: - Button Container
        let buttonsContainer = UIView()
        buttonsContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsContainer)
        NSLayoutConstraint.activate(
            [buttonsContainer.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 20),
             buttonsContainer.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20),
             buttonsContainer.widthAnchor.constraint(equalToConstant: 750),
             buttonsContainer.heightAnchor.constraint(equalToConstant: 320),
             buttonsContainer.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor)
        ]
        )
        //constrains for buttons inside container
        let width = 150
        let height = 80
        
        // create 20 buttons as a 4x5 grid
        for row in 0..<4 {
            for col in 0..<5 {
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                letterButton.setTitle("XXX", for: .normal)
                
                let frame = CGRect(x: width * col, y: height * row, width: width, height: height)
                letterButton.frame = frame
//                letterButton.layer.borderColor = UIColor.lightGray.cgColor
//                letterButton.layer.borderWidth = 1
                
                buttonsContainer.addSubview(letterButton)
                letterButtons.append(letterButton)
                letterButton.addTarget(self, action: #selector(letterButtonTapped), for: .touchUpInside)
            }
            
        }
        
        //MARK: - Constraints
        NSLayoutConstraint.activate(
            [scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
             scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
             cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
             cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
             cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),
             answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
             answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
             answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
             answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
             currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
             currentAnswer.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.5),
             currentAnswer.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
             submitButton.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor, constant: 30),
             submitButton.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor, constant: -100),
             submitButton.heightAnchor.constraint(equalToConstant: 44),
             submitButton.widthAnchor.constraint(equalToConstant: 100),
             clearButton.centerYAnchor.constraint(equalTo: submitButton.centerYAnchor),
             clearButton.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor, constant: 100),
             clearButton.heightAnchor.constraint(equalToConstant: 44),
             clearButton.widthAnchor.constraint(equalToConstant: 100)
        ]
        )
        
    }
    
    //MARK: -Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        DispatchQueue.global(qos: .background).async {
            self.loadLevel()
        }
    }
    
    @objc func letterButtonTapped(_ sender: UIButton){
        guard let buttonTitle = sender.titleLabel?.text else {return}
        currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
        activatedButtons.append(sender)
        sender.isHidden = true
    }
    
    @objc func submitButtonTapped(){
        guard let answerText = currentAnswer.text else {return}
        
        if let solutionPosition = solutions.firstIndex(of: answerText) {
            activatedButtons.removeAll()
            
            var splitAnswers = answersLabel.text?.components(separatedBy: "\n")
            splitAnswers?[solutionPosition] = answerText
            answersLabel.text = splitAnswers?.joined(separator: "\n")
            
            currentAnswer.text = ""
            wordsFound += 1
            score += 1
            
            if wordsFound % 7 == 0 {
                let ac = UIAlertController(title: "You've made it!", message: "Are you ready for the next level?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Let's Go!", style: .default, handler: levelUp))
                present(ac,animated: true)
            }
        } else {
            let ac = UIAlertController(title: "Wrong!", message: "Guess Again.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            
            score -= 1
        }
        
    }
    
    @objc func clearButtonTapped(_ sender: UIButton){
        currentAnswer.text = ""
        
        for btn in activatedButtons {
            btn.isHidden = false
        }
        
        activatedButtons.removeAll()
    }
    
    func loadLevel(){
        var clueString = ""
        var solutionString = ""
        var letterBits = [String]()
        
        if let levelFileURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") {
            if let levelContents = try? String(contentsOf: levelFileURL) {
                var lines = levelContents.components(separatedBy: "\n")
                lines.shuffle()
                
                for (index, line) in lines.enumerated() {
                    let parts = line.components(separatedBy: ":")
                    let answer = parts[0]
                    let clue = parts[1]
                    
                    clueString += "\(index+1). \(clue)\n"
                    
                    let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                    solutionString += "\(solutionWord.count) letters\n"
                    solutions.append(solutionWord)
                    
                    let bits = answer.components(separatedBy: "|")
                    letterBits += bits
                }
            }
        }
        DispatchQueue.main.async {
            self.cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
            self.answersLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
        }        
            
        letterBits.shuffle()
        
        if letterBits.count == letterButtons.count {
            for i in 0 ..< letterButtons.count {
                DispatchQueue.main.async {
                    self.letterButtons[i].setTitle(letterBits[i], for: .normal)
                }
            }
        }
        
    }
    
    func levelUp(action: UIAlertAction) {
        level += 1
        solutions.removeAll(keepingCapacity: true)
        
        DispatchQueue.global(qos: .background).async {
            self.loadLevel()
        }
        
        
        for btn in letterButtons {
            btn.isHidden = false
        }
    }
}

