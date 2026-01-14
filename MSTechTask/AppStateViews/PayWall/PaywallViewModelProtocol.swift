//
//  PaywallViewModelProtocol.swift
//  MSTechTask
//
//  Created by Владислав Пермяков on 14.01.2026.
//

import Foundation
import SwiftUI

// proper DI for view model, will be just here as example for future View Models
protocol PaywallViewModelProtocol: AnyObject {
    var subscriptionOptions: [SubscriptionOption] { get }
    var selectedOption: SubscriptionOption? { get }
    var loading: Bool { get }

    @MainActor func select(_ option: SubscriptionOption)
    func buy() async
}

