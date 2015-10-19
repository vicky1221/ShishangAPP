//
//  iToast.m
//  iToast
//
//  Created by Diallo Mamadou Bobo on 2/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "iToast.h"
#import <QuartzCore/QuartzCore.h>

static iToastSettings *sharedSettings = nil;

static iToast *default_toast;

@interface iToast(private)

- (iToast *) settings;

@end

@interface iToastMessage : NSObject

@property(copy) NSString *text;

+ (id)messageWithText:(NSString *)_text;

@end

@implementation iToastMessage

+ (id)messageWithText:(NSString *)text
{
	iToastMessage *ret = [[iToastMessage alloc] init];
	ret.text =  text;
	return [ret autorelease];
}

- (void)dealloc {
	self.text = nil;
	[super dealloc];
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"<%p>: %@", self, self.text];
}

@end

@implementation iToast
@synthesize text;
@synthesize showFromTimer;

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

- (id) initWithText:(NSString *) tex{
	if (self = [super init]) {
		text = [tex copy];
		message = [iToastMessage messageWithText:text];
		messages = [[NSMutableArray alloc] init];
		[messages addObject:message];
	}
	
	return self;
}

- (void)dealloc {
	[text release];
	[messages release];
	[super dealloc];
}

#pragma mark - check keyboard if show
- (BOOL)isKeyboardOnScreen {
	
    BOOL isExists = NO;
    for (UIWindow *keyboardWindow in [[UIApplication sharedApplication] windows])   {
		NSLog(@"[keyboardWindow description] %@, class is %@", [keyboardWindow description], [keyboardWindow class]);
        if ([[keyboardWindow description] hasPrefix:@"<UITextEffectsWindow"] == YES) {
            isExists = YES;
        }
    }
	
    return isExists;
}

#pragma mark

- (void) show{

	[self show:iToastTypeNone];
}

- (void) show:(iToastType) type{
	if (message && [messages lastObject] != message && !showFromTimer) {
		NSLog(@"------ error show show timer %@ %@ %d", message, messages, showFromTimer);
		return;
	}
	NSLog(@"------ show show timer %@ %@", message, messages);
	[self removeToast:nil];
	
	iToastSettings *theSettings = _settings;
	
	if (!theSettings) {
		theSettings = [iToastSettings getSharedSettings];
	}
	
	UIImage *image = [theSettings.images valueForKey:[NSString stringWithFormat:@"%i", type]];
	
	UIFont *font = [UIFont systemFontOfSize:16];
	CGSize textSize = [message.text sizeWithFont:font constrainedToSize:CGSizeMake(280, 60)];
	
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textSize.width + 5, textSize.height + 5)];
	label.backgroundColor = [UIColor clearColor];
	label.textColor = [UIColor whiteColor];
	label.font = font;
//	label.textAlignment = UITextAlignmentCenter;
	label.text = message.text;
	label.numberOfLines = 0;
	label.shadowColor = [UIColor darkGrayColor];
	label.shadowOffset = CGSizeMake(1, 1);
	
	UIButton *v = [UIButton buttonWithType:UIButtonTypeCustom];
	if (image) {
		v.frame = CGRectMake(0, 0, image.size.width + textSize.width + 15, MAX(textSize.height, image.size.height) + 10);
		label.center = CGPointMake(image.size.width + 10 + (v.frame.size.width - image.size.width - 10) / 2, v.frame.size.height / 2);
	} else {
		v.frame = CGRectMake(0, 0, textSize.width + 10, textSize.height + 10);
		label.center = CGPointMake(v.frame.size.width / 2, v.frame.size.height / 2);
	}
	[v addSubview:label];
	[label release];
	
	if (image) {
		UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
		imageView.frame = CGRectMake(5, (v.frame.size.height - image.size.height)/2, image.size.width, image.size.height);
		[v addSubview:imageView];
		[imageView release];
	}
	
	v.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
	v.layer.cornerRadius = 5;
	
	UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
	
	CGPoint point = CGPointMake(window.frame.size.width/2, window.frame.size.height/2);
	
	// Set correct orientation/location regarding device orientation
	UIInterfaceOrientation orientation = (UIInterfaceOrientation)[[UIApplication sharedApplication] statusBarOrientation];
	switch (orientation) {
		case UIDeviceOrientationPortrait:
		{
			if (theSettings.gravity == iToastGravityTop) {
				point = CGPointMake(window.frame.size.width / 2, 45);
			} else if (theSettings.gravity == iToastGravityBottom) {
				point = CGPointMake(window.frame.size.width / 2, window.frame.size.height - 45);
			} else if (theSettings.gravity == iToastGravityCenter) {
				point = CGPointMake(window.frame.size.width/2, window.frame.size.height/2);
			} else {
				point = theSettings.postition;
			}
			
			point = CGPointMake(point.x + offsetLeft, point.y + offsetTop);
			break;
		}
		case UIDeviceOrientationPortraitUpsideDown:
		{
			v.transform = CGAffineTransformMakeRotation(M_PI);
			
			float width = window.frame.size.width;
			float height = window.frame.size.height;
			
			if (theSettings.gravity == iToastGravityTop) {
				point = CGPointMake(width / 2, height - 45);
			} else if (theSettings.gravity == iToastGravityBottom) {
				point = CGPointMake(width / 2, 45);
			} else if (theSettings.gravity == iToastGravityCenter) {
				point = CGPointMake(width/2, height/2);
			} else {
				// TODO : handle this case
				point = theSettings.postition;
			}
			
			point = CGPointMake(point.x - offsetLeft, point.y - offsetTop);
			break;
		}
		case UIDeviceOrientationLandscapeLeft:
		{
			v.transform = CGAffineTransformMakeRotation(M_PI/2); //rotation in radians
			
			if (theSettings.gravity == iToastGravityTop) {
				point = CGPointMake(window.frame.size.width - 45, window.frame.size.height / 2);
			} else if (theSettings.gravity == iToastGravityBottom) {
				point = CGPointMake(45,window.frame.size.height / 2);
			} else if (theSettings.gravity == iToastGravityCenter) {
				point = CGPointMake(window.frame.size.width/2, window.frame.size.height/2);
			} else {
				// TODO : handle this case
				point = theSettings.postition;
			}
			
			point = CGPointMake(point.x - offsetTop, point.y - offsetLeft);
			break;
		}
		case UIDeviceOrientationLandscapeRight:
		{
			v.transform = CGAffineTransformMakeRotation(-M_PI/2);
			
			if (theSettings.gravity == iToastGravityTop) {
				point = CGPointMake(45, window.frame.size.height / 2);
			} else if (theSettings.gravity == iToastGravityBottom) {
				point = CGPointMake(window.frame.size.width - 45, window.frame.size.height/2);
			} else if (theSettings.gravity == iToastGravityCenter) {
				point = CGPointMake(window.frame.size.width/2, window.frame.size.height/2);
			} else {
				// TODO : handle this case
				point = theSettings.postition;
			}
			
			point = CGPointMake(point.x + offsetTop, point.y + offsetLeft);
			break;
		}
		default:
			break;
	}

	// 键盘挡住iToast
	if (!iPhone5) {
		if ([self isKeyboardOnScreen]) {
			point = CGPointMake(point.x, point.y - 30);
		}
	}
	
	v.center = point;
	
	
	NSTimeInterval duration = iToastDurationShort;
	
	if (message.text.length > 15) {
		duration = iToastDurationLong;
	} else if (message.text.length > 8) {
		duration = iToastDurationNormal;
	}

	NSTimer *timer1 = [NSTimer timerWithTimeInterval:duration/1000 
											 target:self selector:@selector(hideToast:) 
										   userInfo:nil repeats:NO];
	[[NSRunLoop mainRunLoop] addTimer:timer1 forMode:NSDefaultRunLoopMode];
	
	[window addSubview:v];
	
	view = [v retain];
	
	[v addTarget:self action:@selector(hideToast:) forControlEvents:UIControlEventTouchDown];
}

- (void)show:(iToastType)type setting:(iToastSettings *)setting {
	if ([messages objectAtIndex:0] != message) {
		return;
	}
	
    [self removeToast:nil];
	
	iToastSettings *theSettings = setting;
	
	if (!theSettings) {
		theSettings = [iToastSettings getSharedSettings];
	}
	
	UIImage *image = [theSettings.images valueForKey:[NSString stringWithFormat:@"%i", type]];
	
	UIFont *font = [UIFont systemFontOfSize:16];
	CGSize textSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(280, 60)];
	
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textSize.width + 5, textSize.height + 5)];
	label.backgroundColor = [UIColor clearColor];
	label.textColor = [UIColor whiteColor];
	label.font = font;
	label.text = message.text;
	label.numberOfLines = 0;
	label.shadowColor = [UIColor darkGrayColor];
	label.shadowOffset = CGSizeMake(1, 1);
	
	UIButton *v = [UIButton buttonWithType:UIButtonTypeCustom];
	if (image) {
		v.frame = CGRectMake(0, 0, image.size.width + textSize.width + 15, MAX(textSize.height, image.size.height) + 10);
		label.center = CGPointMake(image.size.width + 10 + (v.frame.size.width - image.size.width - 10) / 2, v.frame.size.height / 2);
	} else {
		v.frame = CGRectMake(0, 0, textSize.width + 10, textSize.height + 10);
		label.center = CGPointMake(v.frame.size.width / 2, v.frame.size.height / 2);
	}
	[v addSubview:label];
	[label release];
	
	if (image) {
		UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
		imageView.frame = CGRectMake(5, (v.frame.size.height - image.size.height)/2, image.size.width, image.size.height);
		[v addSubview:imageView];
		[imageView release];
	}
	
	v.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
	v.layer.cornerRadius = 5;
	
	UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
	
	CGPoint point = CGPointMake(window.frame.size.width/2, window.frame.size.height/2);
	
	// Set correct orientation/location regarding device orientation
	UIInterfaceOrientation orientation = (UIInterfaceOrientation)[[UIApplication sharedApplication] statusBarOrientation];
	switch (orientation) {
		case UIDeviceOrientationPortrait:
		{
			if (theSettings.gravity == iToastGravityTop) {
				point = CGPointMake(window.frame.size.width / 2, 45);
			} else if (theSettings.gravity == iToastGravityBottom) {
				point = CGPointMake(window.frame.size.width / 2, window.frame.size.height - 45);
			} else if (theSettings.gravity == iToastGravityCenter) {
				point = CGPointMake(window.frame.size.width/2, window.frame.size.height/2);
			} else {
				point = theSettings.postition;
			}
			
			point = CGPointMake(point.x + offsetLeft, point.y + offsetTop);
			break;
		}
		case UIDeviceOrientationPortraitUpsideDown:
		{
			v.transform = CGAffineTransformMakeRotation(M_PI);
			
			float width = window.frame.size.width;
			float height = window.frame.size.height;
			
			if (theSettings.gravity == iToastGravityTop) {
				point = CGPointMake(width / 2, height - 45);
			} else if (theSettings.gravity == iToastGravityBottom) {
				point = CGPointMake(width / 2, 45);
			} else if (theSettings.gravity == iToastGravityCenter) {
				point = CGPointMake(width/2, height/2);
			} else {
				// TODO : handle this case
				point = theSettings.postition;
			}
			
			point = CGPointMake(point.x - offsetLeft, point.y - offsetTop);
			break;
		}
		case UIDeviceOrientationLandscapeLeft:
		{
			v.transform = CGAffineTransformMakeRotation(M_PI/2); //rotation in radians
			
			if (theSettings.gravity == iToastGravityTop) {
				point = CGPointMake(window.frame.size.width - 45, window.frame.size.height / 2);
			} else if (theSettings.gravity == iToastGravityBottom) {
				point = CGPointMake(45,window.frame.size.height / 2);
			} else if (theSettings.gravity == iToastGravityCenter) {
				point = CGPointMake(window.frame.size.width/2, window.frame.size.height/2);
			} else {
				// TODO : handle this case
				point = theSettings.postition;
			}
			
			point = CGPointMake(point.x - offsetTop, point.y - offsetLeft);
			break;
		}
		case UIDeviceOrientationLandscapeRight:
		{
			v.transform = CGAffineTransformMakeRotation(-M_PI/2);
			
			if (theSettings.gravity == iToastGravityTop) {
				point = CGPointMake(45, window.frame.size.height / 2);
			} else if (theSettings.gravity == iToastGravityBottom) {
				point = CGPointMake(window.frame.size.width - 45, window.frame.size.height/2);
			} else if (theSettings.gravity == iToastGravityCenter) {
				point = CGPointMake(window.frame.size.width/2, window.frame.size.height/2);
			} else {
				// TODO : handle this case
				point = theSettings.postition;
			}
			
			point = CGPointMake(point.x + offsetTop, point.y + offsetLeft);
			break;
		}
		default:
			break;
	}
    
	v.center = point;
	
	NSTimeInterval duration = iToastDurationShort;
	
	if (message.text.length > 30) {
		duration = iToastDurationLong;
	} else if (message.text.length > 20) {
		duration = iToastDurationNormal;
	}
	
//	NSTimer *timer1 = [NSTimer timerWithTimeInterval:((float)theSettings.duration)/1000
//                                              target:self selector:@selector(hideToast:)
//                                            userInfo:nil repeats:NO];
	NSTimer *timer1 = [NSTimer timerWithTimeInterval:(duration)/1000
                                              target:self selector:@selector(hideToast:)
                                            userInfo:nil repeats:NO];
	[[NSRunLoop mainRunLoop] addTimer:timer1 forMode:NSDefaultRunLoopMode];
	
	[window addSubview:v];
	
	view = [v retain];
	
	[v addTarget:self action:@selector(hideToast:) forControlEvents:UIControlEventTouchDown];

}

- (void) hideToast:(NSTimer*)theTimer{
//	[UIView beginAnimations:nil context:NULL];
//	view.alpha = 0;
//	[UIView commitAnimations];
	[UIView animateWithDuration:0.2 animations:^{
		view.alpha = 0;
	} completion:^(BOOL finished) {
		[self removeToast:theTimer];
		if (messages.count > 0)
			[messages removeObjectAtIndex:0];
		message = nil;
		if (messages.count > 0) {
			iToastMessage *m = [messages objectAtIndex:0];
			message = m;
			showFromTimer = YES;
			[self show];
//			[self performSelector:@selector(show) withObject:nil];
		}
	}];
	
//	NSTimer *timer2 = [NSTimer timerWithTimeInterval:500 
//											 target:self selector:@selector(hideToast:) 
//										   userInfo:nil repeats:NO];
//	[[NSRunLoop mainRunLoop] addTimer:timer2 forMode:NSDefaultRunLoopMode];
}

- (void) removeToast:(NSTimer*)theTimer{
	[view removeFromSuperview];
	[view release];
	view = nil;
}


+ (iToast *) makeText:(NSString *) _text{
	if (_text == nil)
		return nil;
	
//	iToast *toast = [[[iToast alloc] initWithText:_text] autorelease];
	
	if (default_toast == nil) {
		default_toast = [[iToast alloc] initWithText:_text];
	} else {
		default_toast.text = _text;
	}
	
	default_toast.showFromTimer = NO;
	//	return toast;
	return default_toast;
}

- (void)setText:(NSString *)_text
{
    if (messages.count > 0) {
        iToastMessage *tempStr = [messages lastObject];
        if ([tempStr.text isEqualToString:_text]) {
            return;
        }
    }
	text = [_text copy];
	iToastMessage *m = [iToastMessage messageWithText:text];
	if (message == nil)
		message = m;
	[messages addObject:m];
}

- (NSString *)text {
	return message.text;
}

- (iToast *) setDuration:(NSInteger ) duration{
	[self theSettings].duration = duration;
	return self;
}

- (iToast *) setGravity:(iToastGravity) gravity 
			 offsetLeft:(NSInteger) left
			  offsetTop:(NSInteger) top{
	[self theSettings].gravity = gravity;
	offsetLeft = left;
	offsetTop = top;
	return self;
}

- (iToast *) setGravity:(iToastGravity) gravity{
	[self theSettings].gravity = gravity;
	return self;
}

- (iToast *) setPostion:(CGPoint) _position{
	[self theSettings].postition = CGPointMake(_position.x, _position.y);
	
	return self;
}

-(iToastSettings *) theSettings{
	if (!_settings) {
		_settings = [[iToastSettings getSharedSettings] copy];
	}
	
	return _settings;
}

@end


@implementation iToastSettings
@synthesize duration;
@synthesize gravity;
@synthesize postition;
@synthesize images;

- (void) setImage:(UIImage *) img forType:(iToastType) type{
	if (type == iToastTypeNone) {
		// This should not be used, internal use only (to force no image)
		return;
	}
	
	if (!images) {
		images = [[NSMutableDictionary alloc] initWithCapacity:4];
	}
	
	if (img) {
		NSString *key = [NSString stringWithFormat:@"%i", type];
		[images setValue:img forKey:key];
	}
}


+ (iToastSettings *) getSharedSettings{
	if (!sharedSettings) {
		sharedSettings = [iToastSettings new];
		sharedSettings.gravity = iToastGravityCenter;
		sharedSettings.duration = iToastDurationNormal;//iToastDurationShort;
	}
	
	return sharedSettings;
	
}

- (id) copyWithZone:(NSZone *)zone{
	iToastSettings *copy = [iToastSettings new];
	copy.gravity = self.gravity;
	copy.duration = self.duration;
	copy.postition = self.postition;
	
	NSArray *keys = [self.images allKeys];
	
	for (NSString *key in keys){
		[copy setImage:[images valueForKey:key] forType:[key intValue]];
	}
	
	return copy;
}

@end