//
//  LogService.swift
//  AIChat
//
//  Created by Jan Koczuba on 23/07/2025.
//
import SwiftUI

protocol LogService {
    func identifyUser(userId: String, name: String?, email: String?)
    func addUserProperties(dict: [String: Any], isHighPriority: Bool)
    func deleteUserProfile()

    func trackEvent(event: LoggableEvent)
    func trackScreenEvent(event: LoggableEvent)
}
