struct BasicHooks {
    var syncHook = SyncHook<Int>()
    var asyncSeriesHook = AsyncSeriesHook<Int>()
    var asyncParallelHook = AsyncParallelHook<Int>()
}

struct WaterfallHooks {
    var syncWaterfall = SyncWaterfallHook<Int>()
    var asyncWaterfall = AsyncSeriesWaterfallHook<Int>()
}

struct BailHooks {
    var syncBail = SyncBailHook<Int, Bool>()
    var asyncSeriesBail = AsyncSeriesBailHook<Int, Bool>()
    var asyncParallelBail = AsyncParallelBailHook<Int, Bool>()
}
