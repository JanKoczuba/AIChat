//
//  DevSettingsRouter.swift
//  AIChat
//
//  Created by Jan Koczuba on 10/08/2025.
//

@MainActor
protocol DevSettingsRouter {
    func dismissScreen()
}

extension CoreRouter: DevSettingsRouter { }
