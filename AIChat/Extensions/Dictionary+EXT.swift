//
//  Dictionary+EXT.swift
//  AIChat
//
//  Created by Jan Koczuba on 22/07/2025.
//
import Foundation

extension Dictionary where Key == String, Value == Any {

    var asAlphabeticalArray: [(key: String, value: Any)] {
        self.map({ (key: $0, value: $1) }).sortedByKeyPath(keyPath: \.key)
    }
}
