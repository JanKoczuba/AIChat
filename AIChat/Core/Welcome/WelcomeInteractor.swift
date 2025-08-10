//
//  WelcomeInteractor.swift
//  AIChat
//
//  Created by Jan Koczuba on 10/08/2025.
//



@MainActor
protocol WelcomeInteractor {
    func trackEvent(event: LoggableEvent)
    func updateAppState(showTabBarView: Bool)
}

extension CoreInteractor: WelcomeInteractor { }
