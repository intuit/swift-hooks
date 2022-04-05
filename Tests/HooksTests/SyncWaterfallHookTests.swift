import XCTest
@testable import SwiftHooks

class SyncWaterfallHookTests: XCTestCase {
    func testSyncWaterfallHook() {
        let expectation1 = XCTestExpectation()
        let expectation2 = XCTestExpectation()
        let hook = SyncWaterfallHook<Int>()

        hook.tap(name: "1") { val in
            expectation1.fulfill()
            return val + 1
        }

        hook.tap(name: "2") { val in
            expectation2.fulfill()
            return val + 2
        }

        XCTAssertEqual(hook.call(0), 3)
        wait(for: [expectation1, expectation2], timeout: 1)
    }
}
