//
//  MSTechTaskApp.swift
//  MSTechTask
//
//  Created by Владислав Пермяков on 14.01.2026.
//

import SwiftUI

// MVP Is Ready, last test
@main
struct MSTechTaskApp: App {
    // App-wide flow controller using @Observable macro (iOS 17+)
    @State private var flowController = AppFlowController()

    init() {
        registerListenersToFlowController(flowController)
    }
    
    var body: some Scene {
        WindowGroup {
            RootFlowView()
                .environment(flowController)
        }
    }
}

// Can be moved anywhere in the future or make a registration controlled by each Controller separatly
fileprivate func registerListenersToFlowController(_ flowController: AppFlowController) {
    // Start onboarding
    flowController.registerHandler(for: .startOnboarding) { [weak flowController] _ in
        guard let flowController else { return }
        flowController.setState(.onboarding)
    }

    // Onboarding completed -> show paywall (or main app if no paywall)
    flowController.registerHandler(for: .onboardingCompleted) { [weak flowController] _ in
        guard let flowController else { return }
        flowController.setState(.paywall)
    }

    // Explicitly show paywall
    flowController.registerHandler(for: .showPaywall) { [weak flowController] _ in
        guard let flowController else { return }
        flowController.setState(.paywall)
    }

    // Proceed from paywall -> main app
    flowController.registerHandler(for: .proceedFromPaywall) { [weak flowController] _ in
        guard let flowController else { return }
        flowController.setState(.mainApp)
    }

    // Paywall dismissed (without purchasing) -> you decide, here we return to onboarding
    flowController.registerHandler(for: .paywallDismissed) { [weak flowController] _ in
        guard let flowController else { return }
        flowController.setState(.mainApp)
    }

    // Enter main app directly
    flowController.registerHandler(for: .enterMainApp) { [weak flowController] _ in
        guard let flowController else { return }
        flowController.setState(.mainApp)
    }

    // Reset to initial flow
    flowController.registerHandler(for: .resetToInitial) { [weak flowController] _ in
        guard let flowController else { return }
        flowController.setState(.onboarding)
    }
}
