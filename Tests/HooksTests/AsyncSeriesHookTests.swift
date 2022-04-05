import XCTest
@testable import SwiftHooks

class AsyncSeriesHookTests: XCTestCase {
    func testAsyncSeriesHook() async {
        let expectation1 = XCTestExpectation()
        let expectation2 = XCTestExpectation()
        let hook = AsyncSeriesHook<Int>()

        hook.tapAsync(name: "1") { val in
            XCTAssertEqual(val, 2)
            try? await Task.sleep(seconds: 1)
            expectation1.fulfill()
        }

        hook.tap(name: "2") { val in
            XCTAssertEqual(val, 2)
            expectation2.fulfill()
        }

        await hook.call(2)

        wait(for: [expectation1, expectation2], timeout: 5)
    }

    func testRegisterInterceptors() async {
        let hook = AsyncSeriesHook<Int>()
        let registerExpectation = XCTestExpectation()

        hook.interceptRegister { info in
            XCTAssertEqual(info.name, "tap test")
            registerExpectation.fulfill()
            return info
        }

        hook.tap(name: "tap test") { _ in }

        wait(for: [registerExpectation], timeout: 1)
    }

    func testRegisterInterceptorModification() async {
        let hook = AsyncSeriesHook<Int>()
        let registerExpectation = XCTestExpectation()

        hook.interceptRegister { info in
            var newInfo = info
            newInfo.name = "modified tap"
            registerExpectation.fulfill()
            return newInfo
        }

        hook.tap(name: "tap test") { _ in }

        wait(for: [registerExpectation], timeout: 1)

        XCTAssertEqual(hook.taps.first?.name, "modified tap")
    }
}
