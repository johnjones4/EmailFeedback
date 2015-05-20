//
//  EmailFeedback.h
//  Pods
//
//  Created by John Jones on 5/19/15.
//
//

#import <UIKit/UIKit.h>

extern NSTimeInterval const EFDefaultReviewInterval;
extern NSString* const EFUserDetaultsMarkerDate;
extern NSString* const EFUserDetaultsReviewPromptDate;

@interface EmailFeedback : NSObject <UIAlertViewDelegate>

@property (nonatomic) BOOL sendUserDetails;
@property (nonatomic) NSTimeInterval promptReviewAfter;
@property (nonatomic) BOOL repeatPrompt;
@property (nonatomic) NSString* promptTitle;
@property (nonatomic) NSString* promptMessage;
@property (nonatomic) NSString* promptCancelLabel;
@property (nonatomic) NSString* promptReviewLabel;
@property (nonatomic) NSString* promptSendFeedbackLabel;
@property (nonatomic) NSURL* reviewURL;

+ (instancetype)defaultFeedback;
- (void)ping;
- (void)promptForReview;
- (void)sendFeedback;

@end
