#import "CNUserNotificationFeature.h"
@implementation CNUserNotificationFeature
- (id)init{
    self = [super init];
    if (self) {
        _dismissDelayTime = 999999;
        _lineBreakMode = NSLineBreakByTruncatingTail;
        _bannerImage = [NSApp applicationIconImage];
    }
    return self;
}
@end
