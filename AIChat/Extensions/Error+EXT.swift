//
//  Error+EXT.swift
//  AIChat
//
//  Created by Jan Koczuba on 24/07/2025.
//
import Foundation

extension Error {

    var eventParameters: [String: Any] {
        [
            "error_description": localizedDescription
        ]
    }
}
