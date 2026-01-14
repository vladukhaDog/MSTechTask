//
//  for.swift
//  MSTechTask
//
//  Created by Владислав Пермяков on 14.01.2026.
//
import SwiftUI

/// Root view that switches on the current app flow state.
/// Could be fixed in the future to not use th switch for every single state
/// • View factory registry (state -> View builder)
/// • Keep your AppFlow enum for clarity, but register a View factory for each case in a dictionary at startup.
/// • RootFlowView looks up flow.state in the registry and renders the resulting AnyView. Adding a new state /// requires only registering a new factory; RootFlowView doesn’t change.
///
struct RootFlowView: View {
    @Environment(AppFlowController.self) private var flow

    var body: some View {
        ZStack {
            // Onboarding
            if flow.state == .onboarding {
                Group {
                    OnboardingView()
                }
                .transition(transitionForFlowChange)
            }

            // Paywall
            if flow.state == .paywall {
                Group {
                    PaywallView()
                }
                .transition(transitionForFlowChange)
            }

            // Main App
            if flow.state == .mainApp {
                Group {
                    MainAppView()
                }
                .transition(transitionForFlowChange)
            }
        }
        // Drive animation off the state change
        .animation(.spring(response: 0.4, dampingFraction: 0.85, blendDuration: 0.25), value: flow.state)
    }

    // Centralize the transition so it stays consistent across cases
    private var transitionForFlowChange: AnyTransition {
        // Strong slide + fade so it’s clearly not just opacity
        .asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .move(edge: .leading).combined(with: .opacity)
        )
    }
}


#Preview {
    @Previewable @State  var flowController = AppFlowController()
    RootFlowView()
        .environment(flowController)
}
