//
//  SpinnerView.m
//  DGSPhone
//
//  Created by Justin Weiss on 7/23/10.
//  Copyright 2010 Avvo. All rights reserved.
//

#import "SpinnerView.h"

@implementation SpinnerView

@synthesize spinner;
@synthesize label;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		[self setBackgroundColor:[UIColor clearColor]];
		[self setOpaque:NO];
		self.spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectZero];
		self.spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
		[self.spinner startAnimating];
		
		self.label = [[UILabel alloc] initWithFrame:CGRectZero];
		
		self.label.text = @"Loading...";
		self.label.textAlignment = UITextAlignmentCenter;
		self.label.textColor = [UIColor lightTextColor];
		self.label.font = [UIFont boldSystemFontOfSize:14.0];
		self.label.backgroundColor = [UIColor clearColor];
		self.label.opaque = NO;
		
		[self addSubview:self.spinner];
		[self addSubview:self.label];
	}
    return self;
}

- (void)drawRoundedRect:(CGContextRef)context frame:(CGRect)roundedRect radius:(int)radius {
	
	CGContextBeginPath(context);
	CGContextMoveToPoint(context, roundedRect.origin.x, roundedRect.origin.y + radius);
	CGContextAddLineToPoint(context, roundedRect.origin.x, roundedRect.origin.y + roundedRect.size.height - radius);
	
	CGContextAddArcToPoint(context, roundedRect.origin.x, roundedRect.origin.y + roundedRect.size.height, roundedRect.origin.x + radius, roundedRect.origin.y + roundedRect.size.height, radius);
	CGContextAddLineToPoint(context, roundedRect.origin.x + roundedRect.size.width - radius, roundedRect.origin.y + roundedRect.size.height);
	
	CGContextAddArcToPoint(context, roundedRect.origin.x + roundedRect.size.width, roundedRect.origin.y + roundedRect.size.height, roundedRect.origin.x + roundedRect.size.width, roundedRect.origin.y + roundedRect.size.height - radius, radius);
	CGContextAddLineToPoint(context, roundedRect.origin.x + roundedRect.size.width, roundedRect.origin.y + radius);	
	
	CGContextAddArcToPoint(context, roundedRect.origin.x + roundedRect.size.width, roundedRect.origin.y, roundedRect.origin.x + roundedRect.size.width - radius, roundedRect.origin.y, radius);
	CGContextAddLineToPoint(context, roundedRect.origin.x + radius, roundedRect.origin.y);	
	CGContextAddArcToPoint(context, roundedRect.origin.x, roundedRect.origin.y, roundedRect.origin.x, roundedRect.origin.y + radius, radius);
	
	CGContextFillPath(context);
}

+ (SpinnerView *)showInView:(UIView *)view {
	CGRect rect = CGRectMake(view.center.x - 100, view.center.y - 100, 200, 200);
	SpinnerView *spinnerView = [[[SpinnerView alloc] initWithFrame:rect] autorelease];
	spinnerView.alpha = 0.0;
	[view addSubview:spinnerView];
	[view bringSubviewToFront:spinnerView];
	
	[UIView animateWithDuration:0.2 animations:^(void) {
		CGRect newFrame = spinnerView.frame;
		newFrame.origin.x += newFrame.size.width / 4;
		newFrame.origin.y += newFrame.size.height / 4;
		newFrame.size.width /= 2;
		newFrame.size.height /= 2;
		spinnerView.frame = newFrame;
		spinnerView.alpha = 1.0;
	}];
	
	return spinnerView;
}

- (void)dismiss {
	[UIView animateWithDuration:0.2 delay:0.5 options:UIViewAnimationOptionLayoutSubviews animations:^(void) {
		CGRect newFrame = self.frame;
		newFrame.origin.x -= newFrame.size.width / 2;
		newFrame.origin.y -= newFrame.size.height / 2;
		newFrame.size.width *= 2;
		newFrame.size.height *= 2;
		self.frame = newFrame;
		self.alpha = 0.0;
	} completion:^(BOOL completion) {
		[self removeFromSuperview];
	}];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0);
	CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 0.8);
	
	[self drawRoundedRect:context frame:self.bounds radius:10];
}

- (void)layoutSubviews {
	int spinnerSize = 37;
	int textWidth = 80;
	self.spinner.frame = CGRectMake((self.frame.size.width - spinnerSize) / 2, (self.frame.size.height - spinnerSize) / 2, spinnerSize, spinnerSize);
	
	self.label.frame = CGRectMake((self.frame.size.width - textWidth) / 2, self.spinner.frame.origin.y + self.spinner.frame.size.height + 4, textWidth, 16);
							
}

- (void)dealloc {
	[spinner release], spinner = nil;
	[label release], label = nil;

    [super dealloc];
}


@end

