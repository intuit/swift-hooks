import XCTest
@testable import SwiftHooks

class AsyncSeriesWaterfallHookTests: XCTestCase {
    func testAsyncSeriesWaterfallHook() async {
        let expectation1 = XCTestExpectation()
        let expectation2 = XCTestExpectation()
        let hook = AsyncSeriesWaterfallHook<Int>()

        hook.tap(name: "0") { val in
            val + 1
        }

        hook.tapAsync(name: "1") { val in
            try? await Task.sleep(seconds: 1)
            expectation1.fulfill()
            return val * 2
        }

        hook.tapAsync(name: "2") { val in
            expectation2.fulfill()
            return val * 3
        }

        let result = await hook.call(2)
        XCTAssertEqual(result, 18)

        wait(for: [expectation1, expectation2], timeout: 5)
    }

}
