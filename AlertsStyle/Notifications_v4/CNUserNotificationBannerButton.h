#import <Cocoa/Cocoa.h>
@interface CNUserNotificationBannerButton : NSButton
- (instancetype)initWithTitle:(NSString *)theTitle actionHandler:(void (^)(void))actionHandler;
@end
