#import <QuartzCore/QuartzCore.h>
#import "CNUserNotificationBannerController.h"
#import "CNUserNotificationBannerBackgroundView.h"
#import "CNUserNotificationBannerButton.h"
static NSTimeInterval slideInAnimationDuration = 0.5;
static NSTimeInterval slideOutAnimationDuration = 0.5;
static NSDictionary *titleAttributes, *subtitleAttributes, *informativeTextAttributes;
static NSRect presentationBeginRect, presentationRect, presentationEndRect;
static CGFloat bannerTopMargin = 10;
static CGFloat bannerTrailingMargin = 15;
static CGSize bannerSize;
static CGSize bannerImageSize;
static CGFloat bannerContentPadding = 7;
static CGFloat bannerContentLabelPadding = 0.8;
static CGSize buttonSize;
CGFloat CNGetMaxCGFloat(CGFloat left, CGFloat right) {
	return (left > right ? left : right);
}
@interface CNUserNotificationBannerController () {
	NSDictionary *_userInfo;
	CNUserNotification *_userNotification;
	CNUserNotificationBannerActivationHandler _bannerActivationHandler;
	CGFloat _labelWidth;
	NSLineBreakMode _informativeTextLineBreakMode;
    CGFloat _calculatedButtonWidth;
    BOOL _hasActionButton;
}
@property (strong, nonatomic) NSTextField *title;
@property (strong, nonatomic) NSTextField *subtitle;
@property (strong, nonatomic) NSTextField *informativeText;
@property (strong, nonatomic) NSImageView *bannerImageView;
@property (strong) CNUserNotificationBannerButton *actionButton;
@property (strong) CNUserNotificationBannerButton *otherButton;
@property (assign) BOOL animationIsRunning;
@property (strong) NSTimer *dismissTimer;
@end
@implementation CNUserNotificationBannerController
#pragma mark - Initialization
+ (void)initialize {
	bannerSize = NSMakeSize(320.0, 65.0);
	bannerImageSize = NSMakeSize(36.0, 36.0);
	buttonSize = NSMakeSize(80.0, 32.0);
}
- (instancetype)initWithNotification:(CNUserNotification *)theNotification delegate:(id <CNUserNotificationCenterDelegate> )theDelegate usingActivationHandler:(CNUserNotificationBannerActivationHandler)activationHandler {
	self = [super init];
	if (self) {
		_bannerActivationHandler = [activationHandler copy];
		_animationIsRunning = NO;
		_userInfo = theNotification.userInfo;
		_delegate = theDelegate;
		_userNotification = theNotification;
		_informativeTextLineBreakMode = _userNotification.feature.lineBreakMode;
        _actionButton = nil;
        _otherButton = nil;
        _hasActionButton = NO;
		[self adjustTextFieldAttributes];
		[[NSNotificationCenter defaultCenter] addObserverForName:CNUserNotificationDismissBannerNotification object:nil queue:[NSOperationQueue mainQueue]usingBlock: ^(NSNotification *note) {[self dismissBanner];}];
	}
	return self;
}
#pragma mark - API
- (void)presentBanner {
	if (self.animationIsRunning) return;
	self.animationIsRunning = YES;
	[self prepareNotificationBanner];
	[NSApp activateIgnoringOtherApps:YES];
	NSWindow *window = [self window];
	[window setFrame:presentationBeginRect display:NO];
	[window orderFront:self];
	[NSAnimationContext runAnimationGroup: ^(NSAnimationContext *context) {
	    context.duration = slideInAnimationDuration;
	    context.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	    [[window animator] setAlphaValue:1.0];
	    [[window animator] setFrame:presentationRect display:YES];
	} completionHandler: ^{
	    self.animationIsRunning = NO;
	    [window makeKeyAndOrderFront:self];
	    [[NSNotificationCenter defaultCenter] postNotificationName:CNUserNotificationHasBeenPresentedNotification object:nil];
	}];
}
- (void)presentBannerDismissAfter:(NSTimeInterval)dismissTimerInterval {
	[self presentBanner];
	self.dismissTimer = [NSTimer timerWithTimeInterval:dismissTimerInterval target:self selector:@selector(timedBannerDismiss:) userInfo:nil repeats:NO];
	[[NSRunLoop mainRunLoop] addTimer:self.dismissTimer forMode:NSDefaultRunLoopMode];
}
- (void)dismissBanner {
	if (self.animationIsRunning) return;
	self.animationIsRunning = YES;
	[NSAnimationContext runAnimationGroup: ^(NSAnimationContext *context) {context.duration = slideOutAnimationDuration;context.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];[[[self window] animator] setAlphaValue:0.0];[[[self window] animator] setFrame:presentationEndRect display:YES];} completionHandler: ^{self.animationIsRunning = NO; [[self window] close]; }];
}
#pragma mark - Actions
- (void)actionButtonAction {_bannerActivationHandler(CNUserNotificationActivationTypeActionButtonClicked);}
- (void)otherButtonAction {[self dismissBanner];}
#pragma mark - Private Helper
- (void)adjustTextFieldAttributes {
	NSShadow *textShadow = [[NSShadow alloc] init];
	[textShadow setShadowColor:[[NSColor whiteColor] colorWithAlphaComponent:0.8]];
	[textShadow setShadowOffset:NSMakeSize(0, -1)];
	NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
	[textStyle setAlignment:NSLeftTextAlignment];
	[textStyle setLineBreakMode:NSLineBreakByTruncatingTail];
	titleAttributes = @{
        NSShadowAttributeName:          textShadow,
        NSForegroundColorAttributeName: [NSColor colorWithCalibratedWhite:0.280 alpha:1.000],
        NSFontAttributeName:            [NSFont fontWithName:@"LucidaGrande-Bold" size:12],
        NSParagraphStyleAttributeName:  textStyle
    };
	subtitleAttributes = @{
        NSShadowAttributeName:          textShadow,
        NSForegroundColorAttributeName: [NSColor colorWithCalibratedWhite:0.280 alpha:1.000],
        NSFontAttributeName:            [NSFont fontWithName:@"LucidaGrande-Bold" size:11],
        NSParagraphStyleAttributeName:  textStyle
    };
	[textStyle setLineBreakMode:_informativeTextLineBreakMode];
	informativeTextAttributes = @{
        NSShadowAttributeName:          textShadow,
        NSForegroundColorAttributeName: [NSColor colorWithCalibratedWhite:0.500 alpha:1.000],
        NSFontAttributeName:            [NSFont fontWithName:@"LucidaGrande" size:11],
        NSParagraphStyleAttributeName:  textStyle
    };
}
- (void)timedBannerDismiss:(NSTimer *)theTimer {[self dismissBanner];}
- (void)calculateBannerPositions {
	NSRect mainScreenFrame = [[NSScreen screens][0] frame];
	CGFloat statusBarThickness = [[NSStatusBar systemStatusBar] thickness];
	CGFloat calculatedBannerHeight = bannerContentPadding + self.title.intrinsicContentSize.height * 2 + self.informativeText.intrinsicContentSize.height + bannerContentLabelPadding * 2 + bannerContentPadding;
	CGFloat delta = bannerSize.height - calculatedBannerHeight;
	CGFloat bannerheight = (delta < 0 ? bannerSize.height + delta * -1 : bannerSize.height);
	presentationBeginRect = NSMakeRect(NSMaxX(mainScreenFrame) - bannerSize.width - bannerTrailingMargin,NSMaxY(mainScreenFrame) - bannerheight - bannerTopMargin,bannerSize.width,bannerheight);
	presentationRect = NSMakeRect(NSMaxX(mainScreenFrame) - bannerSize.width - bannerTrailingMargin,NSMaxY(mainScreenFrame) - statusBarThickness - bannerheight - bannerTopMargin,bannerSize.width,bannerheight);
	presentationEndRect = NSMakeRect(NSMaxX(mainScreenFrame) - bannerSize.width,NSMaxY(mainScreenFrame) - statusBarThickness - bannerheight - bannerTopMargin,bannerSize.width,bannerheight);
}
- (void)prepareNotificationBanner {
	[self configureNotificationBannerWindow];
	[self configureNotificationBannerImage];
	[self configureNotificationBannerTexts];
	[self configureNotificationBannerButtons];
    [self configureNotificationBannerConstraints];
	[self calculateBannerPositions];
	[self showWindow:nil];
}
- (NSTextField *)labelWithidentifier:(NSString *)theIdentifier attributedTextValue:(NSAttributedString *)theTextValue superView:(NSView *)theSuperView {
	NSTextField *aTextField = [NSTextField new];
	aTextField.translatesAutoresizingMaskIntoConstraints = NO;
	aTextField.attributedStringValue = theTextValue;
	aTextField.identifier = theIdentifier;
	aTextField.drawsBackground = NO;
	[aTextField setSelectable:NO];
	[aTextField setEditable:NO];
	[aTextField setBordered:NO];
	[aTextField setAlignment:NSLeftTextAlignment];
	[theSuperView addSubview:aTextField];
	return aTextField;
}
#pragma mark - Banner Window Configurations
- (void)configureNotificationBannerWindow {
	if (![self window]) {[self setWindow:[[NSWindow alloc] initWithContentRect:NSZeroRect styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO screen:[NSScreen screens][0]]];}
	[[self window] setHasShadow:YES];
	[[self window] setDisplaysWhenScreenProfileChanges:YES];
	[[self window] setReleasedWhenClosed:NO];
	[[self window] setAlphaValue:0.0];
	[[self window] setOpaque:NO];
	[[self window] setLevel:NSStatusWindowLevel];
	[[self window] setBackgroundColor:[NSColor clearColor]];
	[[self window] setCollectionBehavior:(NSWindowCollectionBehaviorCanJoinAllSpaces | NSWindowCollectionBehaviorStationary)];
	CNUserNotificationBannerBackgroundView *contentView = [CNUserNotificationBannerBackgroundView new];
	[[self window] setContentView:contentView];
}
- (void)configureNotificationBannerImage {
	self.bannerImageView = [NSImageView new];
	self.bannerImageView.translatesAutoresizingMaskIntoConstraints = NO;
	self.bannerImageView.image = _userNotification.feature.bannerImage;
	[[[self window] contentView] addSubview:self.bannerImageView];
}
- (void)configureNotificationBannerTexts {
	self.title = [self labelWithidentifier:@"titleLabel" attributedTextValue:[[NSAttributedString alloc] initWithString:_userNotification.title attributes:titleAttributes] superView:[[self window] contentView]];
	self.subtitle = [self labelWithidentifier:@"subtitleLabel" attributedTextValue:[[NSAttributedString alloc] initWithString:_userNotification.subtitle attributes:subtitleAttributes] superView:[[self window] contentView]];
	self.informativeText = [self labelWithidentifier:@"informativeTextLabel" attributedTextValue:[[NSAttributedString alloc] initWithString:_userNotification.informativeText attributes:informativeTextAttributes] superView:[[self window] contentView]];
	switch (_informativeTextLineBreakMode) {
		case NSLineBreakByClipping:
		case NSLineBreakByTruncatingHead:
		case NSLineBreakByTruncatingTail:
		case NSLineBreakByTruncatingMiddle:
			[self.informativeText.cell setUsesSingleLineMode:YES];
        break;
		default:
			[self.informativeText.cell setUsesSingleLineMode:NO];
        break;
	}
}
- (void)configureNotificationBannerButtons {
	if (_userNotification.hasActionButton) {
        self.otherButton = [CNUserNotificationBannerButton new];
        self.otherButton.target = self;
        self.otherButton.action = @selector(otherButtonAction);
        if (!_userNotification.otherButtonTitle) {
            self.otherButton.title = NSLocalizedString(@"Close", @"CNUserNotificationBannerController: Other-Button title");
        }else {
            self.otherButton.title = (![_userNotification.otherButtonTitle isEqualToString:@""] ? _userNotification.otherButtonTitle : NSLocalizedString(@"Close", @"CNUserNotificationBannerController: Other-Button title"));
        }
        [[[self window] contentView] addSubview:self.otherButton];

		self.actionButton = [CNUserNotificationBannerButton new];
		self.actionButton.target = self;
		self.actionButton.action = @selector(actionButtonAction);
        if (!_userNotification.actionButtonTitle) {
            self.actionButton.title = NSLocalizedString(@"Show", @"CNUserNotificationBannerController: Activation-Button title");
        }else {
            self.actionButton.title = (![_userNotification.actionButtonTitle isEqualToString:@""] ? _userNotification.actionButtonTitle : NSLocalizedString(@"Show", @"CNUserNotificationBannerController: Activation-Button title"));
        }
		[[[self window] contentView] addSubview:self.actionButton];
		_calculatedButtonWidth = CNGetMaxCGFloat(self.otherButton.intrinsicContentSize.width, self.actionButton.intrinsicContentSize.width);
	}
}
- (void)configureNotificationBannerConstraints {
    NSView *contentView = [[self window] contentView];
	NSDictionary *defaultViews = @{
        @"bannerImage":     self.bannerImageView,
        @"title":           self.title,
        @"subtitle":        self.subtitle,
        @"informativeText": self.informativeText
    };
	NSDictionary *defaultMetrics = @{
        @"padding":         @(bannerContentPadding),
        @"labelPadding":    @(bannerContentLabelPadding),
        @"labelHeight":     @(self.title.intrinsicContentSize.height),
        @"imageWidth":      @(bannerImageSize.width),
        @"imageHeight":     @(bannerImageSize.height)
    };
    NSMutableDictionary *views = [NSMutableDictionary dictionaryWithDictionary:defaultViews];
    NSMutableDictionary *metrics = [NSMutableDictionary dictionaryWithDictionary:defaultMetrics];
	_labelWidth = 0;
    if (_userNotification.hasActionButton) {
        [views setValue:self.actionButton forKey:@"actionButton"];
        [views setValue:self.otherButton forKey:@"otherButton"];
        [metrics setValue:@(_calculatedButtonWidth) forKey:@"buttonWidth"];
		_labelWidth = bannerSize.width - (bannerContentPadding + bannerImageSize.width + bannerContentPadding + bannerContentPadding + _calculatedButtonWidth + bannerContentPadding);
    }else{
		_labelWidth = bannerSize.width - (bannerContentPadding + bannerImageSize.width + bannerContentPadding + bannerContentPadding);
    }
    [metrics setValue:@(_labelWidth) forKey:@"labelWidth"];
	[self.informativeText setPreferredMaxLayoutWidth:_labelWidth];
	[contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-padding-[bannerImage(imageHeight)]" options:0 metrics:metrics views:views]];
	[contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-padding-[title(labelHeight)]-labelPadding-[subtitle(labelHeight)]-labelPadding-[informativeText(>=labelHeight)]" options:NSLayoutFormatAlignAllLeading | NSLayoutFormatAlignAllTrailing metrics:metrics views:views]];
	if (_userNotification.hasActionButton) {
		[contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-padding-[otherButton]-padding-[actionButton]" options:0 metrics:metrics views:views]];
		[contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[bannerImage(imageWidth)]-padding-[title(labelWidth)]-padding-[otherButton(buttonWidth)]-padding-|" options:0 metrics:metrics views:views]];
		[contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[actionButton(==otherButton)]-padding-|" options:0 metrics:metrics views:views]];
		[contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[subtitle(==title)]" options:0 metrics:metrics views:views]];
		[contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[informativeText(==title)]" options:0 metrics:metrics views:views]];
	}else{
		[contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[bannerImage(imageWidth)]-padding-[title(labelWidth)]-padding-|" options:0 metrics:metrics views:views]];
	}
}
#pragma mark - NSResponder
- (void)mouseUp:(NSEvent *)theEvent {
	_bannerActivationHandler(CNUserNotificationActivationTypeContentsClicked);
}
@end
