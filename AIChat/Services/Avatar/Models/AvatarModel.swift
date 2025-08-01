//
//  AvatarModel.swift
//  AIChat
//
//  Created by Jan Koczuba on 22/05/2025.
//

import Foundation
import IdentifiableByString

struct AvatarModel: Hashable, Codable, StringIdentifiable {
    var id: String {
        avatarId
    }

    let avatarId: String
    let name: String?
    let characterOption: CharacterOption?
    let characterAction: CharacterAction?
    let characterLocation: CharacterLocation?
    private(set) var profileImageName: String?
    let authorId: String?
    let dateCreated: Date?
    let clickCount: Int?

    init(
        avatarId: String,
        name: String? = nil,
        characterOption: CharacterOption? = nil,
        characterAction: CharacterAction? = nil,
        characterLocation: CharacterLocation? = nil,
        profileImageName: String? = nil,
        authorId: String? = nil,
        dateCreated: Date? = nil,
        clickCount: Int? = nil
    ) {
        self.avatarId = avatarId
        self.name = name
        self.characterOption = characterOption
        self.characterAction = characterAction
        self.characterLocation = characterLocation
        self.profileImageName = profileImageName
        self.authorId = authorId
        self.dateCreated = dateCreated
        self.clickCount = clickCount
    }

    var characterDescription: String {
        AvatarDescriptionBuilder(avatar: self).characterDescription
    }

    mutating func updateProfileImage(imageName: String) {
        profileImageName = imageName
    }

    enum CodingKeys: String, CodingKey {
        case avatarId = "avatar_id"
        case name
        case characterOption = "character_option"
        case characterAction = "character_action"
        case characterLocation = "character_location"
        case profileImageName = "profile_image_name"
        case authorId = "author_id"
        case dateCreated = "date_created"
        case clickCount = "click_count"
    }
    
    var eventParameters: [String: Any] {
        let dict: [String: Any?] = [
            "avatar_\(CodingKeys.avatarId.rawValue)": avatarId,
            "avatar_\(CodingKeys.name.rawValue)": name,
            "avatar_\(CodingKeys.characterOption.rawValue)": characterOption?.rawValue,
            "avatar_\(CodingKeys.characterAction.rawValue)": characterAction?.rawValue,
            "avatar_\(CodingKeys.characterLocation.rawValue)": characterLocation?.rawValue,
            "avatar_\(CodingKeys.profileImageName.rawValue)": profileImageName,
            "avatar_\(CodingKeys.authorId.rawValue)": authorId,
            "avatar_\(CodingKeys.dateCreated.rawValue)": dateCreated,
            "avatar_\(CodingKeys.clickCount.rawValue)": clickCount
        ]
        return dict.compactMapValues({ $0 })
    }

    static func newAvatar(name: String, option: CharacterOption, action: CharacterAction, location: CharacterLocation, authorId: String) -> Self {
        AvatarModel(
            avatarId: UUID().uuidString,
            name: name,
            characterOption: option,
            characterAction: action,
            characterLocation: location,
            profileImageName: nil,
            authorId: authorId,
            dateCreated: .now,
            clickCount: 0
        )
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
            )
        ]
    }
}
