//
//  CNUserNotification.h
//
//  Created by Frank Gregor on 16.05.13.
//  Copyright (c) 2013 cocoa:naut. All rights reserved.
//

/*
 The MIT License (MIT)
 Copyright © 2013 Frank Gregor, <phranck@cocoanaut.com>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the “Software”), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */
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
