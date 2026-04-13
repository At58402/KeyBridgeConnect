import Foundation

public struct KeyBridgeToken: Equatable {
    public let id: String
    public let provider: KeyBridgeProvider
    public let expiresAt: Date

    public var isValid: Bool {
        Date() < expiresAt
    }
}

public enum KeyBridgeProvider: String, CaseIterable {
    case openAI = "openai"
    case anthropic = "anthropic"
    // Added in 1.1.0 — Gemini uses a short-lived OAuth access token (expires ~1 hour).
    case gemini = "googlegemini"
}
