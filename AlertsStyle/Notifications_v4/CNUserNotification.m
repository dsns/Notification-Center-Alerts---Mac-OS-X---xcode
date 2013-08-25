#import <objc/runtime.h>
#import "CNUserNotification.h"
NSString *CNUserNotificationHasBeenPresentedNotification = @"com.cocoanaut.userNotification.hasBeenPresented";
@interface CNUserNotification () {CNUserNotificationFeature *_feature;}
@property id CNUserNotificationInstance;
@end
@implementation CNUserNotification
- (instancetype)init{
    if (NSClassFromString(@"NSUserNotification")) {
        _CNUserNotificationInstance = [[NSUserNotification alloc] init];
    }else{
        self = [super init];
        if (self) {
            _CNUserNotificationInstance = self;
            _feature = [CNUserNotificationFeature new];
            _title = nil;
            _subtitle = nil;
            _informativeText = nil;
            _hasActionButton = NO;
            _actionButtonTitle = nil;
            _otherButtonTitle = nil;
            _presented = NO;
            _soundName = NSUserNotificationDefaultSoundName;
            _activationType = CNUserNotificationActivationTypeNone;
            _userInfo = [[NSDictionary alloc] init];
            NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
            [nc addObserverForName:CNUserNotificationHasBeenPresentedNotification object:nil queue:[NSOperationQueue mainQueue]usingBlock:^(NSNotification *note) {_presented = YES;}];
            [nc addObserverForName:CNUserNotificationActivatedWithTypeNotification object:nil queue:[NSOperationQueue mainQueue]usingBlock:^(NSNotification *note) {_activationType = [[note object] integerValue];}];
        }
    }
    return _CNUserNotificationInstance;
}
- (instancetype)copyWithZone:(NSZone *)zone{
    CNUserNotification *copy = [super copy];
    [copy setTitle:self.title];
    [copy setSubtitle:self.subtitle];
    [copy setInformativeText:self.informativeText];
    [copy setHasActionButton:self.hasActionButton];
    [copy setActionButtonTitle:self.actionButtonTitle];
    [copy setOtherButtonTitle:self.otherButtonTitle];
    [copy setSoundName:self.soundName];
    [copy setUserInfo:self.userInfo];
    return copy;
}
- (CNUserNotificationFeature *)feature{
    return _feature;
}
- (void)setFeature:(CNUserNotificationFeature *)theFeature{
    if (![_feature isEqual:theFeature]) {
        _feature = nil;
        _feature = theFeature;
    }
}
@end
#pragma mark - NSUserNotification+CNUserNotificationAdditions
const char kCNUserNotificationFeature;
@implementation NSUserNotification (CNUserNotificationAdditions)
- (id)init {
    self = [super init];
    if (self) [self setFeature:[CNUserNotificationFeature new]];
    return self;
}
- (CNUserNotificationFeature *)feature { return objc_getAssociatedObject(self, &kCNUserNotificationFeature); }
- (void)setFeature:(CNUserNotificationFeature *)theFeature { objc_setAssociatedObject(self, &kCNUserNotificationFeature, theFeature, OBJC_ASSOCIATION_RETAIN_NONATOMIC); }
@end
