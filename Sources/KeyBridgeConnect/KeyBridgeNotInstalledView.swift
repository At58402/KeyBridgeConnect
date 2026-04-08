import SwiftUI
import UIKit

struct KeyBridgeNotInstalledView: View {

    let onDismiss: () -> Void

    private let appStoreURL = URL(string: "https://apps.apple.com/app/keybridge/id0000000000")!

    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                Image(systemName: "arrow.down.app")
                    .font(.system(size: 48))
                    .foregroundColor(.accentColor)
                Text("KeyBridge Required")
                    .font(.title2)
                    .fontWeight(.bold)
                Text("KeyBridge is a free app that securely connects your AI accounts. Install it to continue.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .padding(.top, 32)

            Spacer()

            VStack(spacing: 12) {
                Button {
                    UIApplication.shared.open(appStoreURL)
                    onDismiss()
                } label: {
                    Text("Get KeyBridge — Free")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal)

                Button("Not Now") {
                    onDismiss()
                }
                .foregroundColor(.secondary)
            }
            .padding(.bottom, 32)
        }
    }
}
