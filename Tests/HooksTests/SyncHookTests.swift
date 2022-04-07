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

    func testUntappingGeneratedId() {
        let expectation1 = XCTestExpectation()
        let expectation2 = XCTestExpectation()
        expectation2.expectedFulfillmentCount = 2
        let hook = SyncHook<Int>()

        let id = hook.tap(name: "1") { _ in
            expectation1.fulfill()
        }

        hook.tap(name: "2") { _ in
            expectation2.fulfill()
        }

        hook.call(0)
        id.map { hook.untap($0) }
        hook.call(1)
        wait(for: [expectation1, expectation2], timeout: 1)
    }

    func testUntappingSuppliedId() {
        let expectation1 = XCTestExpectation()
        let expectation2 = XCTestExpectation()
        expectation2.expectedFulfillmentCount = 2
        let hook = SyncHook<Int>()

        hook.tap(name: "1", id: "test") { _ in
            expectation1.fulfill()
        }

        hook.tap(name: "2") { _ in
            expectation2.fulfill()
        }

        hook.call(0)
        hook.untap("test")
        hook.call(1)
        wait(for: [expectation1, expectation2], timeout: 1)
    }

    func testUntappingSuppliedIdWithContext() {
        let expectation1 = XCTestExpectation()
        let expectation2 = XCTestExpectation()
        expectation2.expectedFulfillmentCount = 2
        let hook = SyncHook<Int>()

        hook.tap(name: "1", id: "test") { (_, _) in
            expectation1.fulfill()
        }

        hook.tap(name: "2") { _ in
            expectation2.fulfill()
        }

        hook.call(0)
        hook.untap("test")
        hook.call(1)
        wait(for: [expectation1, expectation2], timeout: 1)
    }

    func testRegisterInterceptRejection() {
        let expectation1 = XCTestExpectation(description: "hook 1 called")
        expectation1.isInverted = true
        let expectation2 = XCTestExpectation(description: "hook 2 called")
        let hook = SyncHook<Int>()

        hook.interceptRegister { info in
            guard info.name == "1" else { return info }
            return nil
        }

        let id = hook.tap(name: "1", id: "test") { _ in
            expectation1.fulfill()
        }

        XCTAssertNil(id)

        hook.tap(name: "2") { _ in
            expectation2.fulfill()
        }

        hook.call(0)
        wait(for: [expectation1, expectation2], timeout: 1)
    }
}
