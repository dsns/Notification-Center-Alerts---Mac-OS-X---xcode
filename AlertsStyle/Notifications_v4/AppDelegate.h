//
//  AppDelegate.h
//  Notifications_v3
//
//  Created by Ksenofontov Misha on 21/08/13.
//  Copyright (c) 2013 Ksenofontov Misha. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@interface AppDelegate : NSObject <NSApplicationDelegate, CNUserNotificationCenterDelegate>
@property (assign) IBOutlet NSWindow *window;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
- (IBAction)saveAction:(id)sender;
@end
