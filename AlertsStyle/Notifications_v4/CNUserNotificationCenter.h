//
//  CNUserNotificationCenter.h
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
