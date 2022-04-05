import XCTest
@testable import Hooks

class AsyncSeriesLoopHookTests: XCTestCase {
    func testAsyncSeriesLoopHook() async {
        let hook = AsyncSeriesLoopHook<Int>()

        let tap1 = XCTestExpectation(description: "First tap invoked")
        tap1.expectedFulfillmentCount = 2
        let tap2 = XCTestExpectation(description: "Second tap invoked")

        var tap1Run = false

        hook.tapAsync(name: "1") { _ in
            try? await Task.sleep(seconds: 1)
            tap1.fulfill()
            if tap1Run {
                return .continue
            } else {
                tap1Run = true
                return .restart
            }
        }

        hook.tapAsync(name: "2") { _ in
            tap2.fulfill()
            return .continue
        }

        await hook.call(0)

        wait(for: [tap1, tap2,], timeout: 2)
    }

    func testLoopInterceptors() async {
        let hook = AsyncSeriesLoopHook<Int>()

        let intercepted = XCTestExpectation(description: "Loop Interceptors called per loop")
        intercepted.expectedFulfillmentCount = 2
        hook.interceptLoop { _, _ in
            intercepted.fulfill()
        }

        let tapped = XCTestExpectation(description: "Tap Interceptors called per loop")
        tapped.expectedFulfillmentCount = 2
        hook.interceptTap { _, _ in
            tapped.fulfill()
        }

        let tap1 = XCTestExpectation(description: "First tap invoked")
        tap1.expectedFulfillmentCount = 2
        let tap2 = XCTestExpectation(description: "Second tap invoked")

        var tap1Run = false

        hook.tapAsync(name: "1") { _ in
            try? await Task.sleep(seconds: 1)
            tap1.fulfill()
            if tap1Run {
                return .continue
            } else {
                tap1Run = true
                return .restart
            }
        }

        hook.tapAsync(name: "2") { _ in
            tap2.fulfill()
            return .continue
        }

        await hook.call(0)

        wait(for: [tap1, tap2, intercepted, tapped], timeout: 1)
    }
}
