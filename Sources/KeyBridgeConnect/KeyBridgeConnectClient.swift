import Foundation
import UIKit

public final class KeyBridgeConnectClient {

    private static let keybridgeScheme = "keybridge"

    private let appID: String
    private let appName: String
    private let callbackScheme: String
    var pendingCompletion: ((Result<KeyBridgeToken, ConnectError>) -> Void)?

    public init(appID: String, appName: String, callbackScheme: String) {
        self.appID = appID
        self.appName = appName
        self.callbackScheme = callbackScheme
    }

    public func requestAccess(
        to provider: KeyBridgeProvider,
        completion: @escaping (Result<KeyBridgeToken, ConnectError>) -> Void
    ) {
        guard let testURL = URL(string: "\(Self.keybridgeScheme)://"),
              UIApplication.shared.canOpenURL(testURL) else {
            completion(.failure(.keybridgeNotInstalled))
            return
        }

        pendingCompletion = completion

        var components = URLComponents()
        components.scheme = Self.keybridgeScheme
        components.host = "connect"
        components.queryItems = [
            URLQueryItem(name: "provider", value: provider.rawValue),
            URLQueryItem(name: "app_name", value: appName),
            URLQueryItem(name: "app_id", value: appID),
            URLQueryItem(name: "callback", value: "\(callbackScheme)://kb-callback")
        ]

        guard let url = components.url else { return }
        UIApplication.shared.open(url)
    }

    @discardableResult
    public func handleCallback(_ url: URL) -> Bool {
        guard url.scheme == callbackScheme,
              url.host == "kb-callback" else {
            return false
        }

        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else {
            pendingCompletion?(.failure(.invalidCallback))
            pendingCompletion = nil
            return true
        }

        func value(for key: String) -> String? {
            queryItems.first(where: { $0.name == key })?.value
        }

        if let error = value(for: "error") {
            pendingCompletion?(.failure(error == "user_denied" ? .userDenied : .invalidCallback))
            pendingCompletion = nil
            return true
        }

        guard let tokenID = value(for: "token"),
              let providerRaw = value(for: "provider"),
              let provider = KeyBridgeProvider(rawValue: providerRaw),
              let expiresAtString = value(for: "expires_at"),
              let expiresAt = ISO8601DateFormatter().date(from: expiresAtString) else {
            pendingCompletion?(.failure(.invalidCallback))
            pendingCompletion = nil
            return true
        }

        guard Date() < expiresAt else {
            pendingCompletion?(.failure(.tokenExpired))
            pendingCompletion = nil
            return true
        }

        pendingCompletion?(.success(KeyBridgeToken(id: tokenID, provider: provider, expiresAt: expiresAt)))
        pendingCompletion = nil
        return true
    }
}
