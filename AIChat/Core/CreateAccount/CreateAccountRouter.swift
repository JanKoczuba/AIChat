//
//  CreateAccountRouter.swift
//  AIChat
//
//  Created by Jan Koczuba on 10/08/2025.
//


@MainActor
protocol CreateAccountRouter {
    func dismissScreen()
}

extension CoreRouter: CreateAccountRouter { }
