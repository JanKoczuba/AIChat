//
//  CreateAvatarInteractor.swift
//  AIChat
//
//  Created by Jan Koczuba on 10/08/2025.
//


import UIKit

@MainActor
protocol CreateAvatarInteractor {
    func trackEvent(event: LoggableEvent)
    func getAuthId() throws -> String
    func generateImage(input: String) async throws -> UIImage
    func createAvatar(avatar: AvatarModel, image: UIImage) async throws
}

extension CoreInteractor: CreateAvatarInteractor { }
