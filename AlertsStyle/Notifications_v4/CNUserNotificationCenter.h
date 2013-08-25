#import <Foundation/Foundation.h>
@class CNUserNotification;
@protocol CNUserNotificationCenterDelegate;
NS_CLASS_AVAILABLE(10_7, NA)
@interface CNUserNotificationCenter : NSObject
#pragma mark - Creating a User Notification Center
+ (instancetype)defaultUserNotificationCenter;
+ (instancetype)customUserNotificationCenter;
#pragma mark - Managing the Scheduled Notification Queue
#pragma mark - Managing the Delivered Notifications
- (void)deliverNotification:(CNUserNotification *)notification;
#pragma mark - Getting and Setting the Delegate
@property (strong) id<CNUserNotificationCenterDelegate> delegate;
@end
