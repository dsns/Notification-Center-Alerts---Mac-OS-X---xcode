#import "CNUserNotificationBannerButtonCell.h"
static NSColor *gradientTopColor, *gradientBottomColor;
static NSGradient *backgroundGradient;
static NSColor *strokeColor;
static CGFloat borderRadius;
@implementation CNUserNotificationBannerButtonCell
+ (void)initialize{
    gradientTopColor = [NSColor colorWithCalibratedWhite:0.980 alpha:0.950];
    gradientBottomColor = [NSColor colorWithCalibratedWhite:0.802 alpha:0.950];
    backgroundGradient = [[NSGradient alloc] initWithStartingColor:gradientTopColor endingColor:gradientBottomColor];
    strokeColor = [NSColor colorWithCalibratedWhite:0.369 alpha:1.000];
    borderRadius = 5.0;
}
- (void)drawBezelWithFrame:(NSRect)frame inView:(NSView *)controlView{
    NSRect borderRect = NSInsetRect(frame, 5, 5);
    NSBezierPath *borderPath = [NSBezierPath bezierPathWithRoundedRect:borderRect xRadius:4 yRadius:4];
    [strokeColor setFill];
    [borderPath fill];
    if (self.isHighlighted) {
        NSBezierPath *buttonPath = [NSBezierPath bezierPathWithRoundedRect:NSInsetRect(borderRect, 0.5, 0.5) xRadius:4 yRadius:4];
        [backgroundGradient drawInBezierPath:buttonPath angle:-90];
    } else {
        NSBezierPath *buttonPath = [NSBezierPath bezierPathWithRoundedRect:NSInsetRect(borderRect, 0.5, 0.5) xRadius:4 yRadius:4];
        [backgroundGradient drawInBezierPath:buttonPath angle:90];
    }
}
@end
