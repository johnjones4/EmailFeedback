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
NSString* const EFUserDetailNotProvided = @"[NOT PROVIDED]";

@interface EmailFeedback() {
    UIViewController* root;
    UIAlertView* reviewPrompt;
    UIAlertView* feedbackPrompt;
}

- (NSString*)_defaultEmailBody;
- (void)_processPropertyDictionary:(NSDictionary*)dict fromObject:(id)object intoArray:(NSMutableArray*)array;

@end

@implementation EmailFeedback

#pragma mark Public

- (id)init {
    if (self = [super init]) {
        self.sendUserDetails = YES;
        self.promptReviewAfter = EFDefaultReviewInterval;
        self.repeatPrompt = NO;
        
        self.reviewPromptTitle = @"Review Us?";
        self.reviewPromptMessage = @"If you like this app, would you mind writing a review for us?";
        self.feedbackPromptTitle = @"Feedback";
        self.feedbackPromptMessage = @"Would you prefer to send us feedback directly to help us improve the app?";
        self.promptCancelLabel = @"No Thanks";
        self.promptReviewLabel = @"Write Review";
        self.promptSendFeedbackLabel = @"Send Feedback";
        
        self.emailSubject = @"App Feedback";
        self.emailIsHTML = NO;
        
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
    if (self.reviewURL) {
        reviewPrompt = [[UIAlertView alloc] initWithTitle:self.reviewPromptTitle
                                                  message:self.reviewPromptMessage
                                                 delegate:self
                                        cancelButtonTitle:self.promptCancelLabel
                                        otherButtonTitles:self.promptReviewLabel,nil];
        [reviewPrompt show];
    }
}

- (void)promptForFeedback {
    if ([MFMailComposeViewController canSendMail] && self.emailRecipient && self.emailSubject) {
        feedbackPrompt = [[UIAlertView alloc] initWithTitle:self.feedbackPromptTitle
                                                    message:self.feedbackPromptMessage
                                                   delegate:self
                                          cancelButtonTitle:self.promptCancelLabel
                                          otherButtonTitles:self.promptSendFeedbackLabel, nil];
        [feedbackPrompt show];
    }
}

- (void)sendFeedback {
    root = [UIApplication sharedApplication].keyWindow.rootViewController;
    MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] initWithNibName:nil
                                                                                                       bundle:nil];
    composeViewController.mailComposeDelegate = self;
    [composeViewController setToRecipients:@[self.emailRecipient]];
    [composeViewController setSubject:self.emailSubject];
    if (!self.emailBody) {
        self.emailBody = [self _defaultEmailBody];
    }
    [composeViewController setMessageBody:self.emailBody isHTML:self.emailIsHTML];
    [root presentViewController:composeViewController animated:YES completion:nil];
}

#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSString* title = [alertView buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:self.promptReviewLabel]) {
        [[UIApplication sharedApplication] openURL:self.reviewURL];
    } else if ([title isEqualToString:self.promptSendFeedbackLabel]) {
        [self sendFeedback];
    } else if ([title isEqualToString:self.promptCancelLabel] && alertView == reviewPrompt) {
        [self promptForFeedback];
    }
    reviewPrompt = nil;
    feedbackPrompt = nil;
}

#pragma mark MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [root dismissViewControllerAnimated:YES completion:nil];
    root = nil;
}

#pragma mark Private

- (NSString*)_defaultEmailBody {
    if (self.sendUserDetails) {
        NSMutableArray* userData = [[NSMutableArray alloc] init];
        
        [self _processPropertyDictionary:@{
                                           @"Device Name": @"name",
                                           @"Device System Name": @"systemName",
                                           @"Device System Version": @"systemVersion",
                                           @"Device Model": @"model",
                                           @"Device Localized Model": @"localizedModel",
                                           @"Device Vendor ID": @"identifierForVendor"
                                           }
                              fromObject: [UIDevice currentDevice]
                               intoArray:userData];
        
        [self _processPropertyDictionary:@{
                                           @"System Version": @"operatingSystemVersionString"
                                           }
                              fromObject:[NSProcessInfo processInfo]
                               intoArray:userData];
        
        [self _processPropertyDictionary:@{
                                           @"App Bundle": @"CFBundleIdentifier",
                                           @"App Short Version": @"CFBundleShortVersionString",
                                           @"App Version": @"CFBundleVersion"
                                           }
                              fromObject:[[NSBundle mainBundle] infoDictionary]
                               intoArray:userData];
        
        NSArray* langs = [NSLocale preferredLanguages];
        [userData addObject:[NSString stringWithFormat:@"Languages: %@",[langs componentsJoinedByString:@", "]]];
        
        return [@"Your feedback ...\n\n\n\n" stringByAppendingString:[userData componentsJoinedByString:@"\n"]];
    } else {
        return @"";
    }
}

- (void)_processPropertyDictionary:(NSDictionary*)dict fromObject:(id)object intoArray:(NSMutableArray*)array {
    for(NSString* key in dict.allKeys) {
        NSString* property = [dict valueForKey:key];
        id value = nil;
        if ([object isKindOfClass:[NSDictionary class]]) {
            value = [object objectForKey:property];
        } else {
            SEL selector = NSSelectorFromString(property);
            if ([object respondsToSelector:selector]) {
                value = [object performSelector:selector];
            }
        }
        if (!value) {
            value = EFUserDetailNotProvided;
        }
        [array addObject:[NSString stringWithFormat:@"%@: %@",key,value]];
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
