//
//  Array+Extensions.swift
//  FR24Challenge
//
//  Created by Robin Hellgren on 23/03/2024.
//

import Foundation

/// Source: https://byby.dev/swift-array-unique
extension Array where Element: Hashable {
    func unique() -> [Element] {
        var dict = [Element: Bool]()
        self.forEach {
            dict[$0] = true
        }
        return Array(dict.keys)
    }
}
