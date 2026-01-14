//
//  SubscriptionOption.swift
//  MSTechTask
//
//  Created by Владислав Пермяков on 14.01.2026.
//

import Foundation

struct SubscriptionOption: Codable, Identifiable, Equatable {
    let id: String
    let name: String
    let description: String?
    let duration: String
    let price: String
}
