//
//  Game.swift
//  Apple Pie
//
//  Created by Андрей on 29.10.2021.
//
//import Foundation
struct Game {
    var word: String
    var incorrectMovesRemaining: Int    // количество оставшихся попыток
    fileprivate var guessedLetters = [Character].init()   // fileprivate - доступно только в этом файле
    
    init(word: String, incorrectMovesRemaining: Int) {
        self.word = word
        self.incorrectMovesRemaining = incorrectMovesRemaining
    }
    
    var guessedWord: String {
        var wordToShow = ""
        for letter in word {
            if guessedLetters.contains(Character(letter.lowercased())) || letter == "-" || letter == " "{
                wordToShow += String(letter)
            } else {
                wordToShow += "_"
            }
        }
        return wordToShow
    }
    
    mutating func playerGuest(letter: Character) {
        let lowercasedLatter = Character(letter.lowercased())
        guessedLetters.append(lowercasedLatter)
        if !word.lowercased().contains(lowercasedLatter) {
            incorrectMovesRemaining -= 1
        }
    }
}
