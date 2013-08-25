#ifndef CNLog_h
#define CNLog_h
#ifdef DEBUG
    #define CNLog(aParam, ...)      NSLog(@"%s(%d): " aParam, ((strrchr(__FILE__, '/') ? : __FILE__- 1) + 1), __LINE__, ##__VA_ARGS__)
    #define CNLogForRect(aRect)     CNLog(@"[%s] x: %f, y: %f, width: %f, height: %f", #aRect, aRect.origin.x, aRect.origin.y, aRect.size.width, aRect.size.height)
    #define CNLogForRange(aRange)   CNLog(@"[%s] location: %lu; length: %lu", #aRange, aRange.location, aRange.length)
#else
    #define CNLog(xx, ...)          ((void)0)
    #define CNLogForRect(aRect)     ((void)0)
    #define CNLogForRange(aRange)   ((void)0)
#endif
#endif