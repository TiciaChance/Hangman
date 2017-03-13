//
//  WordRandomizer.swift
//  Hangman
//
//  Created by Ticia Chance on 2/15/17.
//  Copyright © 2017 Ticia Chance. All rights reserved.
//

import UIKit

class WordRandomizer: NSObject {
    
    class func pickRandomWord(words: [String]) -> [DisplayedWord] {
        
        var displayedWord = [DisplayedWord]()
        
        let randomIndex = Int(arc4random_uniform(UInt32(words.count)))
        
        let randomWord = words[randomIndex]
        
        let stringLength = randomWord.characters.count
        displayedWord.append(DisplayedWord(word: randomWord, count: stringLength))
        
        return displayedWord
    }

}

struct DisplayedWord {
    let word : String
    let count : Int
}
