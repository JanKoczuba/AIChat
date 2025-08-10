//
//  CreateAvatarRouter.swift
//  AIChat
//
//  Created by Jan Koczuba on 10/08/2025.
//


@MainActor
protocol CreateAvatarRouter {
    func dismissScreen()
    func showAlert(error: Error)
}

extension CoreRouter: CreateAvatarRouter { }
