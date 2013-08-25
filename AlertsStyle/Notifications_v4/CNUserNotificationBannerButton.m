#import "CNUserNotificationBannerButton.h"
#import "CNUserNotificationBannerButtonCell.h"
static NSDictionary *buttonTextAttributes;
typedef void (^CNUserNotificationBannerButtonActionHandler)(void);
@interface CNUserNotificationBannerButton () {}
@property (strong) CNUserNotificationBannerButtonActionHandler actionHandler;
@end
@implementation CNUserNotificationBannerButton
+ (void)initialize{
    NSMutableParagraphStyle *buttonStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    buttonStyle.alignment = NSCenterTextAlignment;
    buttonTextAttributes = @{
        NSForegroundColorAttributeName: [NSColor colorWithCalibratedWhite:0.238 alpha:1.000],
        NSParagraphStyleAttributeName:  buttonStyle,
        NSFontAttributeName:            [NSFont fontWithName:@"LucidaGrande" size:12],
        NSBaselineOffsetAttributeName:  [NSNumber numberWithInt:-2]
    };
}
+ (Class)cellClass{
    return [CNUserNotificationBannerButtonCell class];
}
- (instancetype)initWithTitle:(NSString *)theTitle actionHandler:(void (^)(void))actionHandler{
    self = [self init];
    if (self) {
        [self setTitle:theTitle];
        [self setActionHandler:actionHandler];
    }
    return self;
}
- (id)init{
    self = [super init];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self setButtonType:NSMomentaryPushInButton];
        [self setBezelStyle:NSRoundedBezelStyle];
    }
    return self;
}
- (void)setTitle:(NSString *)aString{
    [super setTitle:aString];
    [self setAttributedTitle:[[NSAttributedString alloc] initWithString:aString attributes:buttonTextAttributes]];
}
@end
