//
//  Game.swift
//  Hangman
//
//  Created by Ticia Chance on 3/24/17.
//  Copyright © 2017 Ticia Chance. All rights reserved.
//

import Foundation

struct Game {
    
    let wordGettter = WordGetter()

    func getWord() {
        self.wordGettter.getWords() { (response) in
            switch response {
            case .success(let responseData):
                //self.displayedWord = responseData.results
                //let word = self.displayedWord[0]
                //let underscores = String(repeating: "_", count: word.count)
                
                case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}
