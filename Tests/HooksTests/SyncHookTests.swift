import XCTest
@testable import SwiftHooks

class SyncHookTests: XCTestCase {
    func testSyncSeriesHook() {
        let expectation1 = XCTestExpectation()
        let expectation2 = XCTestExpectation()
        let hook = SyncHook<Int>()

        hook.tap(name: "1") { _ in
            expectation1.fulfill()
        }

        hook.tap(name: "2") { _ in
            expectation2.fulfill()
        }

        hook.call(0)
        wait(for: [expectation1, expectation2], timeout: 1)
    }

    func testVoidCall() {
        let hook = SyncHook<Void>()
        let expected = XCTestExpectation()

        hook.tap(name: "1") {
            expected.fulfill()
        }

        hook.call()

        wait(for: [expected], timeout: 1)
    }
}
