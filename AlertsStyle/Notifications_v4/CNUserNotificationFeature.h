#import <Foundation/Foundation.h>
NS_CLASS_AVAILABLE(10_7, NA)
@interface CNUserNotificationFeature : NSObject
@property (assign) NSTimeInterval dismissDelayTime;
@property (assign) NSLineBreakMode lineBreakMode;
@property (strong) NSImage *bannerImage;
@end
