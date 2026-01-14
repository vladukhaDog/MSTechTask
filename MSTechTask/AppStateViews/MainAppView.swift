//
//  MainAppView.swift
//  MSTechTask
//
//  Created by Владислав Пермяков on 14.01.2026.
//

import SwiftUI

struct MainAppView: View {

    // MARK: - A 50-word lorem ipsum paragraph to demonstrate main content text.
    private var loremIpsumText: String {
        """
        Lorem ipsum dolor sit amet consectetur adipiscing elit sed do eiusmod tempor incididunt ut labore et dolore magna aliqua Ut enim ad minim veniam quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat
        """
    }

    // MARK: - A list of random SF Symbols to populate the horizontal image scroller.
    private var systemImages: [String] {
        [
            "star", "bolt.fill", "heart", "paperplane", "flame",
            "bookmark", "bell", "leaf", "globe", "moon",
            "sun.max", "cloud", "umbrella", "pawprint", "bicycle",
            "car.fill", "tram.fill", "bolt.circle", "wifi", "antenna.radiowaves.left.and.right"
        ]
    }

    // MARK: - A horizontal ScrollView of system images (SF Symbols).
    private var horizontalImagesScroll: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(systemImages, id: \.self) { name in
                    Image(systemName: name)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 48, height: 48)
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.secondarySystemBackground))
                        )
                }
            }
            .padding(.horizontal)
        }
    }

    var body: some View {
        VStack(spacing: 24) {
            subscriptionInfo
            // Horizontal image scroller
            horizontalImagesScroll

            // Text content
            bodyText

            // Reset button
            resetButton

            Spacer()
        }
        .padding(.top, 24)
    }
    
    @ViewBuilder
    private var subscriptionInfo: some View {
        // TODO: Replace with DI protocol, something like "Subscription Cache Manager" etc
        if let info = UserDefaultsService.shared.getSubscriptionID() {
            Text("SubscriptionID: \(info)")
                .font(.title)
        }
    }

    private var bodyText: some View {
        Text(loremIpsumText)
            .multilineTextAlignment(.leading)
            .font(.title3)
            .padding(.horizontal)
    }

    private var resetButton: some View {
        Button(role: .destructive) {
            // Can be moved to a ViewModel in the future, especially if any new logic is needed for the view
            // Clear saved subscription info
            UserDefaultsService.shared.clearSubscriptionID()
            UserDefaultsService.shared.clearOnboardingShown()
            // Post event to return to onboarding
            AppFlowEventPoster.post(.startOnboarding)
        } label: {
            Text("Reset: Start Onboarding")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red.opacity(0.9))
                .foregroundColor(.white)
                .cornerRadius(12)
        }
        .padding(.horizontal)
    }
}

#Preview {
    MainAppView()
}
