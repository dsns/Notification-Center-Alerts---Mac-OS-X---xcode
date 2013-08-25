//
//  CNUserNotificationFeature.h
//  CNUserNotification Example
//
//  Created by Frank Gregor on 26.05.13.
//  Copyright (c) 2013 cocoa:naut. All rights reserved.
//
#import <Foundation/Foundation.h>
NS_CLASS_AVAILABLE(10_7, NA)
@interface CNUserNotificationFeature : NSObject
@property (assign) NSTimeInterval dismissDelayTime;
@property (assign) NSLineBreakMode lineBreakMode;
@property (strong) NSImage *bannerImage;
@end
