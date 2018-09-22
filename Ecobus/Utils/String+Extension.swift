//
//  String+Extension.swift
//  Ecobus
//
//  Created by Anh Son Le on 9/18/18.
//  Copyright © 2018 asstudio. All rights reserved.
//

import Foundation

extension String {
    var unescaped: String {
        let entities = ["\0", "\t", "\n", "\r", "\"", "\'", "\\"]
        var current = self
        for entity in entities {
            let descriptionCharacters = entity.debugDescription.dropFirst().dropLast()
            let description = String(descriptionCharacters)
            current = current.replacingOccurrences(of: description, with: entity)
        }
        return current
    }
    
    func findNumberAndReplace(replaceBy: String) -> String {
        do {
            let regex = try NSRegularExpression.init(pattern: "[0-9]+", options: [])
            let res = regex.matches(in: self, options: [], range: NSRange.init(location: 0, length: self.count))
            if let range = res.first?.range, let rangeStr = Range.init(range, in: self) {
                return self.replacingCharacters(in: rangeStr, with: replaceBy)
            }
        } catch {
            print(error)
        }
        return self
    }
    
}
