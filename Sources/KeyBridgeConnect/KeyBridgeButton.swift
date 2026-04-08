import SwiftUI

public struct KeyBridgeButton: View {

    let provider: KeyBridgeProvider
    let client: KeyBridgeConnectClient
    let onResult: (Result<KeyBridgeToken, ConnectError>) -> Void

    @State private var showingNotInstalled = false

    public init(
        provider: KeyBridgeProvider,
        client: KeyBridgeConnectClient,
        onResult: @escaping (Result<KeyBridgeToken, ConnectError>) -> Void
    ) {
        self.provider = provider
        self.client = client
        self.onResult = onResult
    }

    public var body: some View {
        Button {
            client.requestAccess(to: provider) { result in
                if case .failure(let error) = result, error == .keybridgeNotInstalled {
                    showingNotInstalled = true
                } else {
                    onResult(result)
                }
            }
        } label: {
            Label("Connect \(provider.displayName)", systemImage: "link")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.accentColor)
                .foregroundColor(.white)
                .cornerRadius(12)
        }
        .sheet(isPresented: $showingNotInstalled) {
            KeyBridgeNotInstalledView(onDismiss: {
                showingNotInstalled = false
            })
        }
    }
}

extension KeyBridgeProvider {
    public var displayName: String {
        switch self {
        case .openAI: return "OpenAI"
        case .anthropic: return "Anthropic"
        }
    }
}
