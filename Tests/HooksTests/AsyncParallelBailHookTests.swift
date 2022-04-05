import XCTest
@testable import Hooks

class AsyncParallelBailHookTests: XCTestCase {
    func testAsyncParallelBailHookAsyncSuccess() async {
        let expectation1 = XCTestExpectation(description: "Tap 1 invoked")
        let expectation2 = XCTestExpectation(description: "Tap 2 invoked")
        let hook = AsyncParallelBailHook<Int, String>()

        hook.tapAsync(name: "1") { _ in
            try? await Task.sleep(seconds: 1)
            expectation1.fulfill()
            return .bail("1")
        }

        hook.tapAsync(name: "2") { _ in
            expectation2.fulfill()
            return .skip
        }

        let result = await hook.call(2)
        XCTAssertEqual(result, "1")

        wait(for: [expectation1, expectation2], timeout: 2)
    }
    func testAsyncParallelBailHookSyncSuccess() async {
        let expectation1 = XCTestExpectation(description: "Tap 1 invoked")
        let expectation2 = XCTestExpectation(description: "Tap 2 invoked")
        let hook = AsyncParallelBailHook<Int, String>()

        hook.tapAsync(name: "1") { _ in
            try? await Task.sleep(seconds: 2)
            expectation1.fulfill()
            return .bail("1")
        }

        hook.tap(name: "2") { _ in
            expectation2.fulfill()
            return .bail("2")
        }

        let result = await hook.call(2)
        XCTAssertEqual(result, "2")

        wait(for: [expectation1, expectation2], timeout: 3)
    }
}
