//
//  WordGetter.swift
//  Hangman
//
//  Created by Ticia Chance on 2/15/17.
//  Copyright © 2017 Ticia Chance. All rights reserved.
//

import UIKit
import Alamofire

typealias WordCompletion = (WordsResponse) -> Void

enum WordsResponse {
    case success(response: WordsResponseData)
    case failure(error: Error)
}

struct WordsResponseData {
    public let results: [DisplayedWord]
}


class WordGetter: NSObject {
    
    let URLString = "http://linkedin-reach.hagbpyjegb.us-west-2.elasticbeanstalk.com/words"
    
    func getWords(completion: @escaping WordCompletion) {
        
        guard let url = URL(string: "\(URLString)") else {return}
        
        Alamofire.request(url).responseString { (response) in
            
            if let words = response.result.value {
                let arrayOfWords = words.components(separatedBy: .whitespacesAndNewlines)
                let randomWord = WordRandomizer.pickRandomWord(words: arrayOfWords)
                completion(.success(response: WordsResponseData(results: randomWord)))
            } else {
                completion(.failure(error: response.result.error ?? NSError()))
            }
            
        }
    }
}
