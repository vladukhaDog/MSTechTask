//
//  UserDefaultsService.swift
//  MSTechTask
//
//  Created by Владислав Пермяков on 14.01.2026.
//

import Foundation
import Observation

fileprivate enum UserDefaultsKeys: String {
    case subscriptionIDKey = "com.mstechtask.subscription.currentID"
    case onboardingShownKey = "com.mstechtask.onboarding.shown"
}

/// A lightweight service for persisting and retrieving the currently selected subscription ID.
/// Uses UserDefaults.standard by default.
@Observable
final class UserDefaultsService {

    // MARK: - Singleton
    // TODO: Make a DI inserted and controlled at the top level of MSTechTasApp.swift
    // DI will help with testing scenarios and will add an ability to change how we store this info: CoreData/SwiftData/LocalFile/Backend
    static let shared = UserDefaultsService()

    // MARK: - Configuration
    private let defaults: UserDefaults

    // MARK: - Init
    /// - Parameter defaults: Inject a custom UserDefaults (e.g., for testing or app groups).
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        
    }
}


// MARK: Subscription save info
extension UserDefaultsService {
    
    /// Returns the currently stored subscription ID, if any.
    func getSubscriptionID() -> String? {
        defaults.string(forKey: UserDefaultsKeys.subscriptionIDKey.rawValue)
    }
    /// Saves the given subscription ID. Pass nil to clear.
    func setSubscriptionID(_ id: String?) {
        defaults.set(id, forKey: UserDefaultsKeys.subscriptionIDKey.rawValue)
    }

    /// Clears any stored subscription ID.
    func clearSubscriptionID() {
        defaults.removeObject(forKey: UserDefaultsKeys.subscriptionIDKey.rawValue)
    }

    /// Convenience flag indicating whether a subscription ID is stored.
    var hasSubscription: Bool {
        getSubscriptionID() != nil
    }
}

// MARK: Onboarding shown flag
extension UserDefaultsService {
    
    /// Returns whether onboarding has been shown.
    func getOnboardingShown() -> Bool {
        defaults.bool(forKey: UserDefaultsKeys.onboardingShownKey.rawValue)
    }
    
    /// Sets whether onboarding has been shown.
    func setOnboardingShown(_ shown: Bool) {
        defaults.set(shown, forKey: UserDefaultsKeys.onboardingShownKey.rawValue)
    }
    
    /// Clears the onboarding shown flag.
    func clearOnboardingShown() {
        defaults.removeObject(forKey: UserDefaultsKeys.onboardingShownKey.rawValue)
    }
    
    /// Convenience property mirroring `hasSubscription` for onboarding.
    var isOnboardingShown: Bool {
        getOnboardingShown()
    }
}
