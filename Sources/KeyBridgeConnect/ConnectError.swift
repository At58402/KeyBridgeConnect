import Foundation

public enum ConnectError: Error, Equatable {
    case keybridgeNotInstalled
    case userDenied
    case invalidCallback
    case tokenExpired
}
