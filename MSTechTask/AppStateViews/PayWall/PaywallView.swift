//
//  PaywallView.swift
//  MSTechTask
//
//  Created by Владислав Пермяков on 14.01.2026.
//

import Foundation
import SwiftUI

//Default init

extension PaywallView where ViewModel == PaywallViewModel {
    init() {
        self.init(vm: PaywallViewModel())
    }
}

struct PaywallView<ViewModel: PaywallViewModelProtocol>: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: ViewModel
    
    init(vm: ViewModel) {
        self._viewModel = .init(initialValue: vm)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                header
                options
                Spacer(minLength: 0)
                continueButton
                footerNote
            }
            .padding(.vertical)
        }
    }

    private var header: some View {
        VStack(spacing: 8) {
            Text("Unlock the Full Experience")
                .font(.largeTitle).bold()
                .multilineTextAlignment(.center)
            Text("Our app is blazing fast, privacy-first, and helps you get more done every day. Join thousands who already upgraded.")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.horizontal)
        }
    }

    private var options: some View {
        VStack(spacing: 12) {
            ForEach(viewModel.subscriptionOptions) { option in
                Button {
                    viewModel.select(option)
                } label: {
                    SubscriptionRow(
                        title: option.name,
                        subtitle: option.description,
                        price: option.price,
                        isSelected: viewModel.selectedOption == option
                    )
                }
            }
        }
        .padding(.horizontal)
    }

    private var continueButton: some View {
        Group {
            Button {
                Task {
                    await viewModel.buy()
                }
            } label: {
                Text("Continue")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(viewModel.selectedOption == nil ? Color.gray : Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .disabled(viewModel.selectedOption == nil)
            
        }
        .loadingIndicator(viewModel.loading)
        .padding(.horizontal)
        
    }

    private var footerNote: some View {
        Text("Cancel anytime. Subscription auto-renews until canceled.")
            .font(.footnote)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
    }
}

private struct SubscriptionRow: View {
    let title: String
    let subtitle: String?
    let price: String
    let isSelected: Bool

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                if let subtitle,
                   !subtitle.isEmpty {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .foregroundStyle(Color.primary)
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                Text(price)
                    .font(.headline)
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? .accentColor : .secondary)
                    .imageScale(.large)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.background)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isSelected ? Color.accentColor : Color.secondary.opacity(0.3), lineWidth: 2)
                )
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
    }
}

@Observable
fileprivate final class PreviewModel: PaywallViewModelProtocol {
    var subscriptionOptions: [SubscriptionOption] = []
    
    var selectedOption: SubscriptionOption? = nil
    
    var loading: Bool = false
    
    init() {
        loadOptions()
    }
    
    func loadOptions() {
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
        await MainActor.run {
            withAnimation {
                loading = true
            }
        }
        // Simulate async work
        try? await Task.sleep(for: .seconds(1.5))
        await MainActor.run {
            withAnimation {
                loading = false
            }
        }
    }
    
    
}

#Preview {
    PaywallView(vm: PreviewModel())
}
