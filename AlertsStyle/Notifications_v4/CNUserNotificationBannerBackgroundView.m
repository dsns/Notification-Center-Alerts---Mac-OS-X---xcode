#import "CNUserNotificationBannerBackgroundView.h"
static NSColor *gradientTopColor, *gradientBottomColor;
static NSGradient *backgroundGradient;
static CGFloat bannerRadius;
@implementation CNUserNotificationBannerBackgroundView
+ (void)initialize{
    gradientTopColor = [NSColor colorWithCalibratedWhite:0.975 alpha:0.950];
    gradientBottomColor = [NSColor colorWithCalibratedWhite:0.820 alpha:0.950];
    backgroundGradient = [[NSGradient alloc] initWithStartingColor:gradientTopColor endingColor:gradientBottomColor];
    bannerRadius = 5.0;
}
- (void)drawRect:(NSRect)dirtyRect{
    NSRect bounds = [self bounds];
    NSBezierPath *backgroundPath = [NSBezierPath bezierPathWithRoundedRect:bounds xRadius:bannerRadius yRadius:bannerRadius];
    [backgroundGradient drawInBezierPath:backgroundPath angle:-90];
}
@end
