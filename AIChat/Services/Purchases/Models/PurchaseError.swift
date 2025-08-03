//
//  PurchaseError.swift
//  AIChat
//
//  Created by Jan Koczuba on 03/08/2025.
//
import SwiftUI

enum PurchaseError: LocalizedError {
    case productNotFound, userCancelledPurchase, failedToPurchase
}
