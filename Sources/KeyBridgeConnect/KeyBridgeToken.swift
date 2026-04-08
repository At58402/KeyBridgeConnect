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
}
