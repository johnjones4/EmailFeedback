//
//  EmailFeedback.h
//  Pods
//
//  Created by John Jones on 5/19/15.
//
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

extern NSTimeInterval const EFDefaultReviewInterval;
extern NSString* const EFUserDetaultsMarkerDate;
extern NSString* const EFUserDetaultsReviewPromptDate;
extern NSString* const EFUserDetailNotProvided;

@interface EmailFeedback : NSObject <UIAlertViewDelegate,MFMailComposeViewControllerDelegate>

@property (nonatomic) BOOL sendUserDetails;
@property (nonatomic) NSTimeInterval promptReviewAfter;
@property (nonatomic) BOOL repeatPrompt;
@property (nonatomic) NSString* reviewPromptTitle;
@property (nonatomic) NSString* reviewPromptMessage;
@property (nonatomic) NSString* feedbackPromptTitle;
@property (nonatomic) NSString* feedbackPromptMessage;
@property (nonatomic) NSString* promptCancelLabel;
@property (nonatomic) NSString* promptReviewLabel;
@property (nonatomic) NSString* promptSendFeedbackLabel;
@property (nonatomic) NSURL* reviewURL;
@property (nonatomic) NSString* emailRecipient;
@property (nonatomic) NSString* emailSubject;
@property (nonatomic) NSString* emailBody;
@property (nonatomic) BOOL emailIsHTML;

+ (instancetype)defaultFeedback;
- (void)ping;
- (void)promptForReview;
- (void)promptForFeedback;
- (MFMailComposeViewController*)sendFeedback:(BOOL)presentViewController;

@end
