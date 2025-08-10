//
//  CategoryListInteractor.swift
//  AIChat
//
//  Created by Jan Koczuba on 10/08/2025.
//


@MainActor
protocol CategoryListInteractor {
    func trackEvent(event: LoggableEvent)
    func getAvatarsForCategory(category: CharacterOption) async throws -> [AvatarModel]
}

extension CoreInteractor: CategoryListInteractor { }
