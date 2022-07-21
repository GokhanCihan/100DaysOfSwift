//
//  ViewController.swift
//  Project5
//
//  Created by Gökhan on 2.07.2022.
//

import UIKit

class ViewController: UITableViewController {
    var allWords = [String]()
    var usedWords = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigation buttons
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startGame))
        
        //returns <URL?>
        if let startWordsUrl = Bundle.main.url(forResource: "start", withExtension: "txt") {
            //returns <String?>
            if let startWords = try? String(contentsOf: startWordsUrl) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
    
        startGame()
    }

    //creating table rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    //asking and holding answer(to use later on) when clicked on + button
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {[weak self, weak ac] action in
            guard let answer = ac?.textFields?[0].text else {return}
            self?.submit(answer)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    //functions checking text input
    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else {return false}
        
        for letter in word {
            if let letterPosition = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: letterPosition)
            } else {
                return false
            }
        }
        if word == title?.lowercased(){
            return false
        }
        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let rangeToCheck = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: rangeToCheck, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound && word.count >= 3
    }
    
    func isUnique(word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    //if all conditions are satisfied adds word to top of the table view or calls error func
    func submit(_ answer: String) {
        let loweredAnswer = answer.lowercased()
        
        if isPossible(word: loweredAnswer) {
            if isUnique(word: loweredAnswer) {
                if isReal(word: loweredAnswer) {
                    usedWords.insert(loweredAnswer, at: 0)
                    
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    return
                } else {
                    if loweredAnswer.count < 3 {
                        showErrorMessage("Word too short", "You should type at least three letters")

                    } else {
                        showErrorMessage("Word not recognized", "You can't just make them up, you know!")

                    }
                }
            } else {
                showErrorMessage("Word used already", "Be more original!")

            }
        } else {
            guard let title = title?.lowercased() else { return }
            showErrorMessage("Word not possible", "You can't spell that word from \"\(title)\" or it is the same word.")
        }

    }
    
    func showErrorMessage(_ errorTitle: String,_ errorMessage: String) {
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @objc func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }

}
