import XCTest
@testable import SwiftHooks

class AsyncParallelHookTests: XCTestCase {
    func testAsyncParallelHook() async {
        let expectation0 = XCTestExpectation()
        let expectation1 = XCTestExpectation()
        let expectation2 = XCTestExpectation()
        let hook = AsyncParallelHook<Int>()

        hook.tap(name: "0") { _ in
            expectation0.fulfill()
        }

        hook.tapAsync(name: "1") { _ in
            try? await Task.sleep(seconds: 2)
            expectation1.fulfill()
        }

        hook.tapAsync(name: "2") { _ in
            expectation2.fulfill()
        }

        await hook.call(2)

        wait(for: [expectation0, expectation1, expectation2], timeout: 5)
    }
}
