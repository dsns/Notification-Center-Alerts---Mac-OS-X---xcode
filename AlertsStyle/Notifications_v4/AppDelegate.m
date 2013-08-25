#import "AppDelegate.h"
@interface AppDelegate() {}
@property (assign) NSUInteger dismissDelayTime;
@property (strong) CNUserNotificationCenter *notificationCenter;
@property (assign) NSLineBreakMode lineBreakMode;
@end
@implementation AppDelegate
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification{
    [[NSUserNotificationCenter defaultUserNotificationCenter] removeAllDeliveredNotifications];
    [[NSNotificationCenter defaultCenter] postNotificationName:CNUserNotificationDismissBannerNotification object:nil];

    
}
- (IBAction)deliverButtonAction:(id)sender{
    [[NSUserNotificationCenter defaultUserNotificationCenter] removeAllDeliveredNotifications];
    [[NSNotificationCenter defaultCenter] postNotificationName:CNUserNotificationDismissBannerNotification object:nil];
    NSUserNotificationCenter *nc =  [NSUserNotificationCenter defaultUserNotificationCenter];
    nc.delegate = nil;
    NSUserNotification *n = [[NSUserNotification alloc] init];
    NSString * title =@"Title";
    NSString * subtitle =@"All not saved data will we lost";
    NSString * informativeText =@"To Activate web inspector required application reloading, reload application now?";
    NSString * otherTitle =@"Later";
    NSString * actionTitle =@"Reload";
    NSString * bannerImage =@"1.png";
    self.notificationCenter = [CNUserNotificationCenter customUserNotificationCenter];
    self.notificationCenter.delegate = self;
    self.lineBreakMode = NSLineBreakByWordWrapping;
    CNUserNotification *notification = [CNUserNotification new];
    notification.title = title;
    notification.subtitle = subtitle;
    notification.informativeText = informativeText;
    notification.hasActionButton = YES;
    notification.otherButtonTitle = otherTitle;
    notification.actionButtonTitle = actionTitle;
    notification.feature.lineBreakMode = self.lineBreakMode;
    notification.feature.bannerImage = [NSImage imageNamed:bannerImage];
    notification.userInfo = @{ @"openThisURLBecauseItsAwesome": @"http://jsses.com" };
    [n setTitle: title];
    [n setSubtitle: subtitle];
    [n setDeliveryDate: [NSDate dateWithTimeIntervalSinceNow: 0]];
    [n setInformativeText: informativeText];
    [n setActionButtonTitle: otherTitle];
    [n setOtherButtonTitle: actionTitle];
    [self.notificationCenter setValuesForKeysWithDictionary:[NSMutableDictionary dictionary]];
    [self.notificationCenter deliverNotification:notification];
    [[NSUserNotificationCenter defaultUserNotificationCenter] scheduleNotification: n];
    switch (n.remote){
        case NSUserNotificationActivationTypeContentsClicked:
            [self didActivateNotification];
        break;
        case NSUserNotificationActivationTypeActionButtonClicked:
           // [self say:@"Deliver"];
        break;
        case NSUserNotificationActivationTypeNone:
            [[NSNotificationCenter defaultCenter] removeObserver:self];
        break;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,NSEC_PER_SEC*0.5),dispatch_get_main_queue(),^(void){nc.delegate = self;});
}
- (void)didActivateNotification{
    [[NSUserNotificationCenter defaultUserNotificationCenter] removeAllDeliveredNotifications];
    [[NSNotificationCenter defaultCenter] postNotificationName:CNUserNotificationDismissBannerNotification object:nil];
    [self say:@"Did activate notification"];
}
#pragma mark - CNUserNotification Delegate
- (BOOL)userNotificationCenter:(CNUserNotificationCenter *)center shouldPresentNotification:(CNUserNotification *)notification{return YES;}
- (void)userNotificationCenter:(CNUserNotificationCenter *)center didDeliverNotification:(CNUserNotification *)notification{
    //[self say:@"Deliver"];
}
- (void)userNotificationCenter:(CNUserNotificationCenter *)center didActivateNotification:(CNUserNotification *)notification{[self didActivateNotification];}
#pragma mark -
- (NSURL *)applicationFilesDirectory{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *appSupportURL = [[fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    return [appSupportURL URLByAppendingPathComponent:@"JSSES.Notifications_v4"];
}
- (NSManagedObjectModel *)managedObjectModel{
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Notifications_v4" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator{
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    NSManagedObjectModel *mom = [self managedObjectModel];
    if (!mom) {
        NSLog(@"%@:%@ No model to generate a store from", [self class], NSStringFromSelector(_cmd));
        return nil;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *applicationFilesDirectory = [self applicationFilesDirectory];
    NSError *error = nil;
    NSDictionary *properties = [applicationFilesDirectory resourceValuesForKeys:@[NSURLIsDirectoryKey] error:&error];
    if (!properties) {
        BOOL ok = NO;
        if ([error code] == NSFileReadNoSuchFileError) {
            ok = [fileManager createDirectoryAtPath:[applicationFilesDirectory path] withIntermediateDirectories:YES attributes:nil error:&error];
        }
        if (!ok) {
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    } else {
        if (![properties[NSURLIsDirectoryKey] boolValue]) {
            NSString *failureDescription = [NSString stringWithFormat:@"Expected a folder to store application data, found a file (%@).", [applicationFilesDirectory path]];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:failureDescription forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:101 userInfo:dict];
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    }
    NSURL *url = [applicationFilesDirectory URLByAppendingPathComponent:@"Notifications_v4.storedata"];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    if (![coordinator addPersistentStoreWithType:NSXMLStoreType configuration:nil URL:url options:nil error:&error]) {
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    _persistentStoreCoordinator = coordinator;
    return _persistentStoreCoordinator;
}
- (NSManagedObjectContext *)managedObjectContext{
    if (_managedObjectContext) {return _managedObjectContext;}
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@"Failed to initialize the store" forKey:NSLocalizedDescriptionKey];
        [dict setValue:@"There was an error building up the data file." forKey:NSLocalizedFailureReasonErrorKey];
        NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}
- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window{return [[self managedObjectContext] undoManager];}
- (IBAction)saveAction:(id)sender{
    NSError *error = nil;
    if (![[self managedObjectContext] commitEditing]) {NSLog(@"%@:%@ unable to commit editing before saving", [self class], NSStringFromSelector(_cmd));}
    if (![[self managedObjectContext] save:&error]) {[[NSApplication sharedApplication] presentError:error];}
}
- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender{
    [[NSUserNotificationCenter defaultUserNotificationCenter] removeAllDeliveredNotifications];
    [[NSNotificationCenter defaultCenter] postNotificationName:CNUserNotificationDismissBannerNotification object:nil];
    [[NSUserNotificationCenter defaultUserNotificationCenter] removeAllDeliveredNotifications];
    if (!_managedObjectContext) {return NSTerminateNow;}
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing to terminate", [self class], NSStringFromSelector(_cmd));
        return NSTerminateCancel;
    }
    if (![[self managedObjectContext] hasChanges]) {return NSTerminateNow;}
    NSError *error = nil;
    if (![[self managedObjectContext] save:&error]) {
        BOOL result = [sender presentError:error];
        if (result) {
            return NSTerminateCancel;
        }
        NSString *question = NSLocalizedString(@"Could not save changes while quitting. Quit anyway?", @"Quit without saves error question message");
        NSString *info = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
        NSString *quitButton = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
        NSString *cancelButton = NSLocalizedString(@"Cancel", @"Cancel button title");
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:question];
        [alert setInformativeText:info];
        [alert addButtonWithTitle:quitButton];
        [alert addButtonWithTitle:cancelButton];
        NSInteger answer = [alert runModal];
        if (answer == NSAlertAlternateReturn) {
            return NSTerminateCancel;
        }
    }
    return NSTerminateNow;
}
- (void)say:(NSString *)a{NSTask *task = [[NSTask alloc] init];task.launchPath = @"/usr/bin/say";task.arguments  = @[@"-v", @"Alex", a];[task launch];[task waitUntilExit];}


@end
