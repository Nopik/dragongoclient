//
//  Implementation for the message view
//

#import "MessageView.h"


@implementation MessageView

@synthesize messageTextView;
@synthesize messageField;
@synthesize messageDisplayView;
@synthesize messageInputView;

@synthesize message;
@synthesize reply;

@synthesize onHide;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}


- (void)keyboardWillBeShown:(NSNotification *)notification {
	float totalHeight = self.frame.size.height;
	CGRect frame = self.messageInputView.frame;
	frame.origin.y = totalHeight - frame.size.height;
	self.messageInputView.frame = frame;
	CGSize kbSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
	[UIView animateWithDuration:0.3 animations:^(void) {
		CGRect newFrame = self.messageInputView.frame;
		newFrame.origin.y = totalHeight - kbSize.height - frame.size.height;
		self.messageInputView.frame = newFrame;
	}];
}

- (void)keyboardWillBeHidden:(NSNotification *)notification {
	float totalHeight = self.frame.size.height;
	
	[UIView animateWithDuration:0.3 animations:^(void) {
		CGRect frame = self.messageInputView.frame;
		frame.origin.y = totalHeight - frame.size.height;
		self.messageInputView.frame = frame;
	}];
}

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillBeShown:)
												 name:UIKeyboardWillShowNotification object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillBeHidden:)
												 name:UIKeyboardWillHideNotification object:nil];
	
}

// Call this method somewhere in your view controller setup code.
- (void)removeKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
													name:UIKeyboardWillShowNotification object:nil];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:UIKeyboardWillHideNotification object:nil];
	
}

- (BOOL)hasMessage {
	return (self.message.length > 0 || self.reply.length > 0);
}

- (void)show:(void (^)(BOOL hasMessage))_onHide {
	self.onHide = _onHide;
	[self registerForKeyboardNotifications];
	[self.messageField becomeFirstResponder];
	if (self.message) {
		self.messageTextView.text = self.message;
	} else {
		self.messageDisplayView.hidden = YES;
	}
	
	[UIView animateWithDuration:0.3 animations:^(void) {
		self.alpha = 1.0;
	}];
}

- (IBAction)hide {
	self.reply = self.messageField.text;
	self.onHide([self hasMessage]);
	[self.messageField resignFirstResponder];
	[self removeKeyboardNotifications];
	
	[UIView animateWithDuration:0.3 animations:^(void) {
		self.alpha = 0.0;
	} completion:^(BOOL completion) {
		[self removeFromSuperview];
	}];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self hide];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	self.messageTextView = nil;
	self.messageField = nil;
	self.messageDisplayView = nil;
	self.messageInputView = nil;
	self.onHide = nil;
	
	self.message = nil;
	self.reply = nil;
    [super dealloc];
}


@end
