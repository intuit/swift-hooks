struct BasicHooks {
    var syncHook = SyncHook<Int>()
    var asyncSeriesHook = AsyncSeriesHook<Int>()
    var asyncParallelHook = AsyncParallelHook<Int>()
}
