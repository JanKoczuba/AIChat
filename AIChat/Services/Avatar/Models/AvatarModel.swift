//
//  AvatarModel.swift
//  AIChat
//
//  Created by Jan Koczuba on 22/05/2025.
//

import Foundation

struct AvatarModel: Hashable {

    let avatarId: String
    let name: String?
    let characterOption: CharacterOption?
    let characterAction: CharacterAction?
    let characterLocation: CharacterLocation?
    let profileImageName: String?
    let authorId: String?
    let dateCreated: Date?

    init(
        avatarId: String,
        name: String? = nil,
        characterOption: CharacterOption? = nil,
        characterAction: CharacterAction? = nil,
        characterLocation: CharacterLocation? = nil,
        profileImageName: String? = nil,
        authorId: String? = nil,
        dateCreated: Date? = nil,
    ) {
        self.avatarId = avatarId
        self.name = name
        self.characterOption = characterOption
        self.characterAction = characterAction
        self.characterLocation = characterLocation
        self.profileImageName = profileImageName
        self.authorId = authorId
        self.dateCreated = dateCreated
    }

    var characterDescription: String {
        AvatarDescriptionBuilder(avatar: self).characterDescription

    }

    static var mock: Self {
        mocks[0]

    }

    static var mocks: [Self] {
        [
            AvatarModel(
                avatarId: UUID().uuidString,
                name: "Alpha",
                characterOption: .alien,
                characterAction: .smiling,
                characterLocation: .park,
                profileImageName: Constants.randomImage,
                authorId: UUID().uuidString,
                dateCreated: .now
            ),
            AvatarModel(
                avatarId: UUID().uuidString,
                name: "Beta",
                characterOption: .dog,
                characterAction: .eating,
                characterLocation: .forest,
                profileImageName: Constants.randomImage,
                authorId: UUID().uuidString,
                dateCreated: .now
            ),
            AvatarModel(
                avatarId: UUID().uuidString,
                name: "Gamma",
                characterOption: .cat,
                characterAction: .drinking,
                characterLocation: .museum,
                profileImageName: Constants.randomImage,
                authorId: UUID().uuidString,
                dateCreated: .now
            ),
            AvatarModel(
                avatarId: UUID().uuidString,
                name: "Delta",
                characterOption: .woman,
                characterAction: .shopping,
                characterLocation: .mall,
                profileImageName: Constants.randomImage,
                authorId: UUID().uuidString,
                dateCreated: .now
            ),
        ]
    }

}

struct AvatarDescriptionBuilder {
    let characterOption: CharacterOption
    let characterAction: CharacterAction
    let characterLocation: CharacterLocation

    init(
        characterOption: CharacterOption,
        characterAction: CharacterAction,
        characterLocation: CharacterLocation
    ) {
        self.characterOption = characterOption
        self.characterAction = characterAction
        self.characterLocation = characterLocation
    }

    init(avatar: AvatarModel) {
        self.characterOption = avatar.characterOption ?? .default
        self.characterAction = avatar.characterAction ?? .default
        self.characterLocation = avatar.characterLocation ?? .default
    }

    var characterDescription: String {
        let prefix = characterOption.startsWithVowel ? "An" : "A"
        return
            "\(prefix) \(characterOption.rawValue) that is \(characterAction.rawValue) in the \(characterLocation.rawValue)"
    }
}

enum CharacterOption: String, CaseIterable, Hashable {
    case man, woman, alien, cat, dog

    static var `default`: Self {
        .man
    }

    var startsWithVowel: Bool {
        switch self {
        case .alien:
            return true
        default:
            return false
        }
    }
}

enum CharacterAction: String {
    case smiling, sitting, eating, drinking, walking, shopping, studying,
        working, relaxing, fighting, crying

    static var `default`: Self {
        .relaxing
    }
}

enum CharacterLocation: String {
    case park, mall, museum, city, desert, forest, space

    static var `default`: Self {
        .park
    }
}
