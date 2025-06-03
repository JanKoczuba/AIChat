//
//  Binding+EXT.swift
//  AIChat
//
//  Created by Jan Koczuba on 03/06/2025.
//

import Foundation
import SwiftUI

extension Binding where Value == Bool {

    init<T: Sendable>(ifNotNil value: Binding<T?>) {
        self.init {
            value.wrappedValue != nil
        } set: { newValue in
            if !newValue {
                value.wrappedValue = nil
            }
        }
    }
}
