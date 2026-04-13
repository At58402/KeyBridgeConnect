import Foundation

public struct KeyBridgeToken: Equatable {
    public let id: String
    public let provider: KeyBridgeProvider
    public let expiresAt: Date

    public var isValid: Bool {
        Date() < expiresAt
    }

    // Returns true if the token expires within the next 30 minutes.
    // Call refreshToken when this returns true to get a new token silently.
    public var isExpiringSoon: Bool {
        let thirtyMinutes: TimeInterval = 30 * 60
        return Date().addingTimeInterval(thirtyMinutes) >= expiresAt
    }
}

public enum KeyBridgeProvider: String, CaseIterable {
    case openAI = "openai"
    case anthropic = "anthropic"
    // Added in 1.1.0 — Gemini uses a short-lived OAuth access token (expires ~1 hour).
    case gemini = "googlegemini"
}
