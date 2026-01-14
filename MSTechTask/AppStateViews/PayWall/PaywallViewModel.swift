//
//  PaywallViewModel.swift
//  MSTechTask
//
//  Created by Владислав Пермяков on 14.01.2026.
//
import SwiftUI

@Observable
final class PaywallViewModel: PaywallViewModelProtocol {
    private(set) var subscriptionOptions: [SubscriptionOption] = []
    private(set) var selectedOption: SubscriptionOption?
    
    private(set) var loading: Bool = false

    init() {
        loadOptions()
    }

    private func loadOptions() {
        // In a real app, fetch from StoreKit/remote config. Here we provide sample data.
        subscriptionOptions = [
            SubscriptionOption(
                id: "monthly",
                name: "Monthly",
                description: "Flexible, cancel anytime",
                duration: "1 month",
                price: "$4.99/month"
            ),
            SubscriptionOption(
                id: "yearly",
                name: "Yearly",
                description: "Best value, save 33%",
                duration: "1 year",
                price: "$39.99/year"
            )
        ]
        // Preselect best value if desired
        selectedOption = subscriptionOptions.last
    }
    
    @MainActor
    func select(_ option: SubscriptionOption) {
        withAnimation {
            self.selectedOption = option
        }
    }

    func buy() async {
        guard let option = selectedOption else { return }
        await MainActor.run {
            loading = true
        }
        UserDefaultsService.shared.setSubscriptionID(option.id)
        // Simulate async work
        try? await Task.sleep(for: .seconds(1.5))
        // On success, you might update state, post notifications, etc.
        AppFlowEventPoster.post(.paywallDismissed)
        await MainActor.run {
            loading = false
        }
        // Handle errors and show alerts using external Alert Controllers(Maybe in the future, classical feature)
    }
}
