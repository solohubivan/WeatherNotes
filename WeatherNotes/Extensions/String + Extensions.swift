//
//  String + Extensions.swift
//  WeatherNotes
//
//  Created by Ivan Solohub on 30.04.2026.
//

import Foundation

extension String {
    
    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func sanitizedNote(maxLength: Int = 100) -> String {
        var result = ""
        var previousWasSpace = false
        
        for char in self where result.count < maxLength {
            let isSpace = char.isWhitespace
            if isSpace && previousWasSpace { continue }
            previousWasSpace = isSpace
            result.append(char)
        }
        
        return result
    }
}
