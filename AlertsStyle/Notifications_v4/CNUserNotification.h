#import <Foundation/Foundation.h>
#import "CNUserNotificationCenter.h"
#import "CNUserNotificationFeature.h"
@class CNUserNotificationCenter, CNUserNotification;
@protocol CNUserNotificationCenterDelegate <NSUserNotificationCenterDelegate>
@optional
- (BOOL)userNotificationCenter:(CNUserNotificationCenter *)center shouldPresentNotification:(CNUserNotification *)notification;
- (void)userNotificationCenter:(CNUserNotificationCenter *)center didActivateNotification:(CNUserNotification *)notification;
- (void)userNotificationCenter:(CNUserNotificationCenter *)center didDeliverNotification:(CNUserNotification *)notification;
@end
extern NSString *CNUserNotificationHasBeenPresentedNotification;
extern NSString *CNUserNotificationDismissBannerNotification;
extern NSString *CNUserNotificationActivatedWithTypeNotification;
typedef NS_ENUM (NSInteger, CNUserNotificationActivationType) {
    CNUserNotificationActivationTypeNone = 0,
    CNUserNotificationActivationTypeContentsClicked,
    CNUserNotificationActivationTypeActionButtonClicked
}
NS_ENUM_AVAILABLE (10_7, NA);
NS_CLASS_AVAILABLE(10_7, NA)
@interface CNUserNotification : NSObject <NSCopying>
#pragma mark - Display Information
@property (copy) NSString *title;
@property (copy) NSString *subtitle;
@property (copy) NSString *informativeText;
#pragma mark - Displayed Notification Buttons
@property BOOL hasActionButton;
@property (copy) NSString *actionButtonTitle;
@property (copy) NSString *otherButtonTitle;
#pragma mark - Delivery Timing
@property (copy) NSDate *deliveryDate;
@property (readonly) NSDate *actualDeliveryDate;
@property (copy) NSDateComponents *deliveryRepeatInterval;
@property (copy) NSTimeZone *deliveryTimeZone;
#pragma mark - Delivery Information
@property (readonly, getter=isPresented) BOOL presented;
@property (readonly, getter=isRemote) BOOL remote;
@property (copy) NSString *soundName;
#pragma mark - User Notification Activation Method
@property (readonly) CNUserNotificationActivationType activationType;
#pragma mark - User Notification User Information
@property (copy) NSDictionary *userInfo;
#pragma mark - User Notification Additional Features
- (CNUserNotificationFeature *)feature;
- (void)setFeature:(CNUserNotificationFeature *)theFeature;
@end
#pragma mark - NSUserNotification+CNUserNotificationAdditions
@interface NSUserNotification (CNUserNotificationAdditions)
- (CNUserNotificationFeature *)feature;
- (void)setFeature:(CNUserNotificationFeature *)theFeature;
@end
