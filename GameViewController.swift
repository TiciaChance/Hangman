//
//  ViewController.swift
//  Hangman
//
//  Created by Ticia Chance on 2/15/17.
//  Copyright © 2017 Ticia Chance. All rights reserved.
//

import UIKit
import LTMorphingLabel

class GameViewController: UIViewController, UITextFieldDelegate, LTMorphingLabelDelegate {
    
    
    @IBOutlet weak var wordLabel: LTMorphingLabel!
    @IBOutlet weak var letterGuessTextField: UITextField!
    @IBOutlet weak var guessFullWordButton: UIButton!
    @IBOutlet weak var remainingGuessesLabel: UILabel!
    @IBOutlet weak var usersScoreLabel: UILabel!
    @IBOutlet weak var incorrectGuessesLabel: LTMorphingLabel!
    @IBOutlet weak var hangmanImage: UIImageView!
    @IBOutlet weak var tryAgainButton: UIButton!
    @IBOutlet weak var letterCountLabel: LTMorphingLabel!
    
    @IBOutlet weak var hintButton: UIButton!
    
    @IBOutlet weak var difficultyLabel: UILabel!
    
    
    
    let wordGettter = WordGetter()
    var displayedWord = [DisplayedWord]()
    let gradientView = GradientView()
    
    var guesses: Int = 6
    var userScore: Int = 0
    var incorrectGuesses = String()
    var counter  = 0
    var difficultyLevelsCount = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        letterGuessTextField.delegate = self
        incorrectGuessesLabel.delegate = self
        tryAgainButton.isHidden = true
        
        difficultyLabel.text = "Difficulty Level: 1"
        getWord()
        
        view.insertSubview(gradientView, at: 0)
    }
    
    
    func getWord() {
        remainingGuessesLabel.text = "Remaining guesses: 6"
        self.wordGettter.getWords(difficultyLevel: difficultyLevelsCount) { (response) in
            switch response {
            case .success(let responseData):
                self.displayedWord = responseData.results
                let word = self.displayedWord[0]
                print(word)
                let underscores = String(repeating: "_", count: word.count)
                
                self.wordLabel.morphingEffect = .pixelate
                self.wordLabel.text = underscores
                self.letterCountLabel.text = "\(word.count) letters"
                self.letterCountLabel.morphingEffect = .evaporate
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func guessFullWordBtnTapped(_ sender: Any) {
        guessFullWordAlert()
    }
    
    @IBAction func tryAgainBtnTapped(_ sender: Any) {
        restartGame()
        tryAgainButton.isHidden = true
    }
    
    @IBAction func hintButtonTapped(_ sender: Any) {
        
        counter += 1
        
        if counter >= 1 {
            hintButton.isEnabled = false
        }
        hintForUser()
        if wordLabel.text == displayedWord[0].word {
            userHasWon()
        }
        
    }
    
    
    //MARK: UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let lengthLimit = 1
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= lengthLimit
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        checkAnswer()
        letterGuessTextField.text? = ""
        letterGuessTextField.resignFirstResponder()
        return true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


//MARK: GAME LOGIC
extension GameViewController {
    
    func checkAnswer() {
        let word = self.displayedWord[0].word
        guard let userInput = letterGuessTextField.text?.lowercased() else {return}
        guard let labelWord = wordLabel.text else {return}
        
        if word.contains(userInput) {
            updateLabel(with: displayedWord[0].word, userInput: userInput)
        } else if !word.contains(userInput) && guesses > 0 {
            incorrectGuess(userInput: userInput)
        }
        
        if !word.contains(userInput) && guesses == 0 {
            gameOver()
            tryAgainButton.isHidden = false
        }
        if labelWord.contains(userInput) {
            repeatedLetterAlert()
        }
        
        if wordLabel.text == word {
            userHasWon()
        }
    }
    
    func incorrectGuess(userInput: String) {
        
        if !incorrectGuesses.contains(userInput) && userInput != "" && userInput.isEmpty == false {
            incorrectGuesses.append(" \(userInput)")
            incorrectGuessesLabel.morphingEffect = .evaporate
            incorrectGuessesLabel.text = incorrectGuesses
            guesses -= 1
            updateImage()
            remainingGuessesLabel.text = "Remaining guesses: \(guesses)"
        } else {
            repeatedLetterAlert()
        }
    }
    
    
    func updateLabel(with retievedWord: String, userInput: String) {
        guard var labelText = wordLabel.text else {return}
        var startIndex = labelText.characters.startIndex
        while let range = retievedWord.range(of: userInput, options: .caseInsensitive, range: startIndex..<labelText.characters.endIndex) {
            labelText.replaceSubrange(range, with: userInput)
            startIndex = labelText.characters.index(after: range.lowerBound)
        }
        self.wordLabel.text = labelText
    }
    
    func repeatedLetterAlert() {
        let alertController = UIAlertController(title: "Nice Try!", message: "You've already guessed this letter, try another.", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Okay", style: .default) { (_) in }
        alertController.addAction(confirmAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func guessFullWordAlert() {
        
        let wordCount = displayedWord[0].count
        let word = displayedWord[0].word
        
        let alertController = UIAlertController(title: "Guess Word", message: "This word has \(wordCount) letters, what's your guess?", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Okay", style: .default) { (_) in
            guard let field = alertController.textFields?[0].text?.lowercased() else {return}
            
            if field == word {
                self.userScore += 1
                self.wordLabel.text = field
                self.usersScoreLabel.text = "Score: \(self.userScore)"
                self.userHasWon()
            } else if field != word {
                self.guesses -= 1
                self.updateImage()
                self.remainingGuessesLabel.text = "Remaining guesses: \(self.guesses)"
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Your Guess"
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func userHasWon() {
        userScore += 1
        usersScoreLabel.text = "Score: \(userScore)"
        
        difficultyLevelsCount += 1
        difficultyLabel.text = "Difficulty Level: \(difficultyLevelsCount)"
        
        restartGame()
    }
    //get characters of the letter
    // randomly select from the chars
    //update label with letter
    
    func hintForUser() {
        
        let word = displayedWord[0].word
        
        var letter = randomLetter(gameDisplayWord: word)
        while wordLabel.text.contains(letter) {
            letter = randomLetter(gameDisplayWord: word)
        }
        
        updateLabel(with: word, userInput: letter)
        
    }
    
    func randomLetter(gameDisplayWord: String) -> String {
        let char = Array(gameDisplayWord.characters)
        let randomIndex = Int(arc4random_uniform(UInt32(char.count)))
        let randomLetter = String(char[randomIndex])
        
        return randomLetter
    }
    
    
    func restartGame() {
        getWord()
        incorrectGuesses.removeAll()
        incorrectGuessesLabel.text = incorrectGuesses
        guesses = 6
        DispatchQueue.main.async {
            self.hangmanImage.image = UIImage(named: "Hangman6")
        }
        letterGuessTextField.isEnabled = true
    }
    
    func gameOver() {
        letterGuessTextField.isEnabled = false
        wordLabel.text = "Game Over"
    }
    
    func updateImage() {
        
        for i in 0...6 {
            if guesses == i {
                DispatchQueue.main.async {
                    self.hangmanImage.image = UIImage(named: "Hangman\(i)")
                }
            }
        }
    }
}

