extension Task where Failure == Never, Success == Never {
    static func sleep(seconds: UInt64) async throws {
        try await Task.sleep(nanoseconds: 1000000000)
    }
}
