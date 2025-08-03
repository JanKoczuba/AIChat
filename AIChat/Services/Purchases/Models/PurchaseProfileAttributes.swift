//
//  PurchaseProfileAttributes.swift
//  AIChat
//
//  Created by Jan Koczuba on 03/08/2025.
//

struct PurchaseProfileAttributes {
    let email: String?
    let firebaseAppInstanceId: String?
    let mixpanelDistinctId: String?
    
    init(
        email: String? = nil,
        firebaseAppInstanceId: String? = nil,
        mixpanelDistinctId: String? = nil
    ) {
        self.email = email
        self.firebaseAppInstanceId = firebaseAppInstanceId
        self.mixpanelDistinctId = mixpanelDistinctId
    }
}
