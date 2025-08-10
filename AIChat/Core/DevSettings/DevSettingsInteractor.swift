//
//  DevSettingsInteractor.swift
//  AIChat
//
//  Created by Jan Koczuba on 10/08/2025.
//


@MainActor
protocol DevSettingsInteractor {
    var activeTests: ActiveABTests { get }
    var auth: UserAuthInfo? { get }
    var currentUser: UserModel? { get }
    
    func trackEvent(event: LoggableEvent)
    func override(updateTests: ActiveABTests) throws
}

extension CoreInteractor: DevSettingsInteractor { }
