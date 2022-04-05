struct BasicHooks {
    var syncHook = SyncHook<Int>()
    var asyncSeriesHook = AsyncSeriesHook<Int>()
    var asyncParallelHook = AsyncParallelHook<Int>()
}

struct WaterfallHooks {
    var syncWaterfall = SyncWaterfallHook<Int>()
    var asyncWaterfall = AsyncSeriesWaterfallHook<Int>()
}
