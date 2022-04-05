import XCTest
@testable import Hooks

class AsyncSeriesBailHookTests: XCTestCase {
    func testAsyncSeriesBailHookAsyncSuccess() async {
        let expectation1 = XCTestExpectation()
        let hook = AsyncSeriesBailHook<Int, String>()

        hook.tapAsync(name: "1") { _ in
            try? await Task.sleep(seconds: 1)
            expectation1.fulfill()
            return .bail("1")
        }

        hook.tapAsync(name: "2") { _ in
            XCTFail("Should not have run this")
            return .skip
        }

        let result = await hook.call(2)
        XCTAssertEqual(result, "1")

        wait(for: [expectation1], timeout: 2)
    }

    func testAsyncSeriesBailHookAsyncSkip() async {
        let expectation1 = XCTestExpectation()
        let expectation2 = XCTestExpectation()
        let hook = AsyncSeriesBailHook<Int, String>()

        hook.tapAsync(name: "2") { _ in
            expectation2.fulfill()
            return .skip
        }

        hook.tapAsync(name: "1") { _ in
            try? await Task.sleep(seconds: 1)
            expectation1.fulfill()
            return .bail("1")
        }

        let result = await hook.call(2)
        XCTAssertEqual(result, "1")

        wait(for: [expectation2, expectation1], timeout: 2)
    }

    func testAsyncSeriesBailHookSyncSuccess() async {
        let expectation2 = XCTestExpectation()
        let hook = AsyncSeriesBailHook<Int, String>()

        hook.tap(name: "2") { _ in
            expectation2.fulfill()
            return .bail("2")
        }

        hook.tapAsync(name: "1") { _ in
            try? await Task.sleep(seconds: 1)
            XCTFail("Should not have run this")
            return .bail("1")
        }

        let result = await hook.call(2)
        XCTAssertEqual(result, "2")

        wait(for: [expectation2], timeout: 1)
    }

    func testAsyncSeriesBailHookNoTaps() async {
        let hook = AsyncSeriesBailHook<Int, String>()

        let result = await hook.call(2)

        XCTAssertNil(result)
    }
}
