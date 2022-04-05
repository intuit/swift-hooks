import XCTest
@testable import Hooks
class TestHook<T>: BaseSyncHook<T, Void> {
    public func call(_ value: T) {
        var context = context(value)
        for tap in taps {
            tap.handler(&context, value)
        }
    }
}
class AsyncTestHook<T>: BaseAsyncHook<T, Void> {
    public func call(_ value: T) async {
        let context = context(value)
        for tap in taps {
            await tap.handler(context, value)
        }
    }
}
class SyncInterceptorsTests: XCTestCase {
    func testRegisterInterceptors() {
        let hook = TestHook<Int>()
        let registerExpectation = XCTestExpectation()

        hook.interceptRegister { info in
            XCTAssertEqual(info.name, "tap test")
            registerExpectation.fulfill()
            return info
        }

        hook.tap(name: "tap test") { _ in }

        wait(for: [registerExpectation], timeout: 1)
    }

    func testRegisterInterceptorRejection() {
        let hook = TestHook<Int>()
        let registerExpectation = XCTestExpectation()

        hook.interceptRegister { info in
            XCTAssertEqual(info.name, "tap test")
            registerExpectation.fulfill()
            return nil
        }

        hook.tap(name: "tap test") { _ in }

        wait(for: [registerExpectation], timeout: 1)
        XCTAssertEqual(0, hook.taps.count)
    }

    func testRegisterInterceptorModification() {
        let hook = TestHook<Int>()
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

    func testTapInterceptors() {
        let hook = TestHook<Int>()
        let interceptorExpectation = XCTestExpectation()
        let callExpectation = XCTestExpectation()

        hook.interceptTap { context, tapInfo in
            XCTAssertEqual(tapInfo.name, "tap test")
            interceptorExpectation.fulfill()
        }

        hook.tap(name: "tap test") { _ in
            callExpectation.fulfill()
        }

        hook.call(1)

        wait(for: [interceptorExpectation, callExpectation], timeout: 1)
    }

    func testTapInterceptorsNoTaps() {
        let hook = TestHook<Int>()
        let interceptorExpectation = XCTestExpectation()
        interceptorExpectation.isInverted = true

        hook.interceptTap { context, tapInfo in
            XCTAssertEqual(tapInfo.name, "tap test")
            interceptorExpectation.fulfill()
        }

        hook.call(1)

        wait(for: [interceptorExpectation], timeout: 1)
    }

    func testCallInterceptors() {
        let hook = TestHook<Int>()
        let interceptorExpectation = XCTestExpectation()
        let callExpectation = XCTestExpectation()

        hook.interceptCall { context, val in
            XCTAssertEqual(val, 1)
            interceptorExpectation.fulfill()
        }

        hook.tap(name: "tap test") { _ in
            callExpectation.fulfill()
        }

        hook.call(1)

        wait(for: [interceptorExpectation, callExpectation], timeout: 1)
    }

    func testContextPassing() {
        let hook = TestHook<Int>()
        let interceptorExpectation = XCTestExpectation()
        let callExpectation = XCTestExpectation()
        hook.interceptCall { context, _ in
            context["testKey"] = "call value"
        }
        hook.interceptTap { context, tapInfo in
            interceptorExpectation.fulfill()
            XCTAssertEqual(context["testKey"] as? String, "call value")
            context["testKey"] = "tap value"
        }

        hook.tap(name: "tap test") { context, _ in
            guard context["testKey"] as? String == "tap value" else { return XCTFail() }
            callExpectation.fulfill()
        }

        hook.call(1)

        wait(for: [interceptorExpectation, callExpectation], timeout: 1)
    }
}

class AsyncInterceptorsTests: XCTestCase {
    // Verify async access
    func testContextPassing() async {
        let hook = AsyncTestHook<Int>()
        let interceptorExpectation = XCTestExpectation()
        let callExpectation = XCTestExpectation()
        hook.interceptCall { context, _ in
            context["testKey"] = "call value"
        }
        hook.interceptTap { context, tapInfo in
            interceptorExpectation.fulfill()
            XCTAssertEqual(context["testKey"] as? String, "call value")
            context["testKey"] = "tap value"
        }

        hook.tapAsync(name: "tap test") { context, _ in
            guard let value: String = await context["testKey"], value == "tap value" else { return XCTFail() }
            callExpectation.fulfill()
            await context.set("newKey", value: 2)

            guard let value2: Int = await context["newKey"], value2 == 2 else { return XCTFail() }
        }

        await hook.call(1)

        wait(for: [interceptorExpectation, callExpectation], timeout: 1)
    }
}
