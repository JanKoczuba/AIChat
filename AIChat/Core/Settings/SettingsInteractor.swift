//
//  SettingsInteractor.swift
//  AIChat
//
//  Created by Jan Koczuba on 10/08/2025.
//


@MainActor
protocol SettingsInteractor {
    var auth: UserAuthInfo? { get }
    
    func trackEvent(event: LoggableEvent)
    func signOut() async throws
    func deleteAccount() async throws
    func updateAppState(showTabBarView: Bool)
}

extension CoreInteractor: SettingsInteractor { }
