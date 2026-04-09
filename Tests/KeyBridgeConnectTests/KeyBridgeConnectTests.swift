import XCTest
@testable import KeyBridgeConnect

final class KeyBridgeConnectTests: XCTestCase {

    func testHandleApprovalCallback() {
        let client = KeyBridgeConnectClient(
            appID: "com.test.app",
            appName: "TestApp",
            callbackScheme: "testapp"
        )

        let exp = expectation(description: "completion")

        var receivedToken: KeyBridgeToken?
        client.pendingCompletion = { result in
            if case .success(let token) = result {
                receivedToken = token
            }
            exp.fulfill()
        }

        let future = Date().addingTimeInterval(60 * 60 * 24)
        let formatter = ISO8601DateFormatter()
        let urlString = "testapp://callback?token=TEST-TOKEN-ID&provider=openai&expires_at=\(formatter.string(from: future))"
        let url = URL(string: urlString)!

        let handled = client.handleCallback(url)

        waitForExpectations(timeout: 1.0)
        XCTAssertTrue(handled)
        XCTAssertNotNil(receivedToken)
        XCTAssertEqual(receivedToken?.provider, .openAI)
        XCTAssertTrue(receivedToken?.isValid ?? false)
    }

    func testHandleDenialCallback() {
        let client = KeyBridgeConnectClient(
            appID: "com.test.app",
            appName: "TestApp",
            callbackScheme: "testapp"
        )

        let exp = expectation(description: "completion")

        var receivedError: ConnectError?
        client.pendingCompletion = { result in
            if case .failure(let error) = result {
                receivedError = error
            }
            exp.fulfill()
        }

        let url = URL(string: "testapp://callback?error=user_denied&provider=anthropic")!
        client.handleCallback(url)

        waitForExpectations(timeout: 1.0)
        XCTAssertEqual(receivedError, .userDenied)
    }
}
