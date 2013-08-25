#import <Cocoa/Cocoa.h>
#import "CNUserNotification.h"
typedef void (^CNUserNotificationBannerActivationHandler)(CNUserNotificationActivationType);
@interface CNUserNotificationBannerController : NSWindowController
@property (strong) id<CNUserNotificationCenterDelegate> delegate;
- (instancetype)initWithNotification:(CNUserNotification *)theNotification delegate:(id<CNUserNotificationCenterDelegate>)theDelegate usingActivationHandler:(CNUserNotificationBannerActivationHandler)activationHandler;
- (void)presentBanner;
- (void)presentBannerDismissAfter:(NSTimeInterval)dismissTimerInterval;
- (void)dismissBanner;
@end
