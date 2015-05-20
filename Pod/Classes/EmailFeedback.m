//
//  EmailFeedback.m
//  Pods
//
//  Created by John Jones on 5/19/15.
//
//

#import "EmailFeedback.h"

NSTimeInterval const EFDefaultReviewInterval = 2592000;
NSString* const EFUserDetaultsMarkerDate = @"ef_marker_date";
NSString* const EFUserDetaultsReviewPromptDate = @"ef_review_prompt";

@implementation EmailFeedback

#pragma mark Public

- (id)init {
    if (self = [super init]) {
        self.sendUserDetails = YES;
        self.promptReviewAfter = EFDefaultReviewInterval;
        self.repeatPrompt = NO;
        
        self.promptTitle = @"Feedback?";
        self.promptMessage = @"If you like this app, please write us a review! We'd also love to hear feedback from you directly if you have suggestions.";
        self.promptCancelLabel = @"No Thanks";
        self.promptReviewLabel = @"Review";
        self.promptSendFeedbackLabel = @"Send Feedback";
        
        
        NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
        
        NSNumber* installDate = [defs objectForKey:EFUserDetaultsMarkerDate];
        if (!installDate) {
            NSTimeInterval now = [NSDate date].timeIntervalSince1970;
            [defs setObject:@(now) forKey:EFUserDetaultsMarkerDate];
        }
        
        NSNumber* didPrompt = [defs objectForKey:EFUserDetaultsReviewPromptDate];
        if (!didPrompt) {
            [defs setObject:@FALSE forKey:EFUserDetaultsReviewPromptDate];
        }
    }
    return self;
}

- (void)ping {
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSTimeInterval now = [NSDate date].timeIntervalSince1970;
    NSNumber *installTimeObj = [defs objectForKey:EFUserDetaultsMarkerDate];
    NSTimeInterval installTime = installTimeObj.doubleValue;
    if ((now - installTime) > self.promptReviewAfter) {
        BOOL didPrompt = [[defs objectForKey:EFUserDetaultsReviewPromptDate] boolValue];
        if (self.repeatPrompt || !didPrompt) {
            [defs setObject:@TRUE forKey:EFUserDetaultsReviewPromptDate];
        }
        if (self.repeatPrompt) {
            [defs setObject:@(now) forKey:EFUserDetaultsMarkerDate];
        }
    }
}

- (void)promptForReview {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:self.promptTitle
                                                    message:self.promptMessage
                                                   delegate:self
                                          cancelButtonTitle:self.promptCancelLabel
                                          otherButtonTitles:nil];
    if (self.reviewURL) {
        [alert addButtonWithTitle:self.promptReviewLabel];
    }
    [alert addButtonWithTitle:self.promptSendFeedbackLabel];
    [alert show];
}

- (void)sendFeedback {
    UIViewController* root = [UIApplication sharedApplication].keyWindow.rootViewController;
    //TODO
}

#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString* title = [alertView buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:self.promptReviewLabel]) {
        [[UIApplication sharedApplication] openURL:self.reviewURL];
    } else if ([title isEqualToString:self.promptSendFeedbackLabel]) {
        [self sendFeedback];
    }
}

#pragma mark Static

+ (instancetype)defaultFeedback {
    static EmailFeedback* feedback;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        feedback = [[EmailFeedback alloc] init];
    });
    return feedback;
}
   
@end
