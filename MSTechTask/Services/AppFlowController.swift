import Foundation
import Observation

// MARK: - High-level App Flow (expandable)
enum AppFlow: Equatable, Sendable {
    case onboarding
    case paywall
    case mainApp
    // Add more cases here in future, e.g. .maintenance, .auth, etc.
}

// MARK: - App Flow Events (expandable)
enum AppFlowEvent: Equatable, Sendable {
    // Onboarding related
    case startOnboarding
    case onboardingCompleted

    // Paywall related
    case showPaywall
    case proceedFromPaywall
    case paywallDismissed

    // Main app related
    case enterMainApp
    case resetToInitial

    // You can add more cases later and handle them via the handler registry.
}

// MARK: - Notification Name
extension Notification.Name {
    static let appFlowEvent = Notification.Name("AppFlowEventNotification")
}

// MARK: - Event Poster
enum AppFlowEventPoster {
    static func post(_ event: AppFlowEvent, userInfo: [AnyHashable: Any]? = nil) {
        var info = userInfo ?? [:]
        info["event"] = event
        NotificationCenter.default.post(
            name: .appFlowEvent,
            object: nil,
            userInfo: info
        )
    }
}

// MARK: - AppFlowController
@Observable
final class AppFlowController {

    // The current app flow state
    private(set) var state: AppFlow

    // Registry mapping events to actions (handlers can be registered/unregistered)
    typealias EventHandler = @MainActor (_ event: AppFlowEvent) -> Void
    private var handlers: [AppFlowEvent: EventHandler] = [:]

    // Notification token
    private var observer: NSObjectProtocol?

    // Initializer allows custom initial state
    init() {
        // TODO: Replace with DI protocol, something like "Subscription Cache Manager", "Onboarding Cache Manager" etc
        if UserDefaultsService.shared.hasSubscription {
            self.state = .mainApp
        } else if UserDefaultsService.shared.isOnboardingShown,
                  !UserDefaultsService.shared.hasSubscription{
            self.state = .paywall
        } else {
            self.state = .onboarding
        }
        startObservingEvents()
    }

    deinit {
        stopObservingEvents()
    }

    // MARK: - Public API

    func setState(_ newState: AppFlow, animated: Bool = true) {
        // Place to add animations or transitions if the UI binds to this.
        state = newState
    }

    // Register a custom handler for a specific event
    func registerHandler(for event: AppFlowEvent, handler: @escaping EventHandler) {
        handlers[event] = handler
    }

    // Remove a custom handler
    func unregisterHandler(for event: AppFlowEvent) {
        handlers.removeValue(forKey: event)
    }

    // Clear all handlers and optionally re-register defaults
    func resetHandlers() {
        handlers.removeAll()
    }

    // MARK: - Private: Notification Routing

    private func startObservingEvents() {
        observer = NotificationCenter.default.addObserver(
            forName: .appFlowEvent,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let self else { return }
            // Try to read the event directly from userInfo
            if let event = notification.userInfo?["event"] as? AppFlowEvent {
                self.route(event)
            } else {
                // Optionally, support posting with object as event
                if let event = notification.object as? AppFlowEvent {
                    self.route(event)
                }
            }
        }
    }

    private func stopObservingEvents() {
        if let token = observer {
            NotificationCenter.default.removeObserver(token)
        }
        observer = nil
    }

    private func route(_ event: AppFlowEvent) {
        if let handler = handlers[event] {
            handler(event)
        } else {
            // No handler registered: you might log or provide a default behavior.
            print("No handler for event: \(event)")
        }
    }
}
