import XCTest
@testable import SwiftHooks

class SyncBailHookTests: XCTestCase {
    func testSyncBailHook() {
        let expectation1 = XCTestExpectation()
        let expectation2 = XCTestExpectation()
        let hook = SyncBailHook<Int, Bool>()

        XCTAssertNil(hook.call(0))

        hook.tap(name: "1") { val in
            guard val == 0 else { return .skip }
            expectation1.fulfill()
            return .bail(true)
        }

        hook.tap(name: "2") { val in
            guard val == 1 else { return .skip }
            expectation2.fulfill()
            return .bail(true)
        }

        _ = hook.call(0)
        wait(for: [expectation1], timeout: 1)

        _ = hook.call(1)

        wait(for: [expectation2], timeout: 1)
    }

    func testBailWithNil() {
        let expectation1 = XCTestExpectation(description: "Tap 1 invoked twice")
        expectation1.expectedFulfillmentCount = 2
        let expectation2 = XCTestExpectation(description: "Tap 2 not invoked")
        expectation2.isInverted = true
        let hook = SyncBailHook<Int, Bool>()

        XCTAssertNil(hook.call(0))

        hook.tap(name: "1") { val in
            expectation1.fulfill()
            return .bail(nil)
        }

        hook.tap(name: "2") { val in
            expectation2.fulfill()
            return .bail(true)
        }

        let val = hook.call(0)
        XCTAssertNil(val)

        let val2 = hook.call(1)
        XCTAssertNil(val2)

        wait(for: [expectation1, expectation2], timeout: 1)
    }

    func testVoidCall() {
        let hook = SyncBailHook<Void, Bool>()
        let expected = XCTestExpectation()

        hook.tap(name: "1") {
            expected.fulfill()
            return .bail(true)
        }

        _ = hook.call()

        wait(for: [expected], timeout: 1)
    }
}
