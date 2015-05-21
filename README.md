# EmailFeedback

[![CI Status](http://img.shields.io/travis/John Jones/EmailFeedback.svg?style=flat)](https://travis-ci.org/John Jones/EmailFeedback)
[![Version](https://img.shields.io/cocoapods/v/EmailFeedback.svg?style=flat)](http://cocoapods.org/pods/EmailFeedback)
[![License](https://img.shields.io/cocoapods/l/EmailFeedback.svg?style=flat)](http://cocoapods.org/pods/EmailFeedback)
[![Platform](https://img.shields.io/cocoapods/p/EmailFeedback.svg?style=flat)](http://cocoapods.org/pods/EmailFeedback)

Yet another feedback prompt. This one directs users to submit email feedback or write a review. The app will ask users of the after a set period of time (30 days by default) to review the app. If the user declines, the user is then asked if he or she prefers to just send feedback directly. Selecting this option opens an email composer view with some information about the app and device preloaded. All of the strings and time intervals used in this Pod are customizable.

![Screenshot of EmailFeedback in action](https://raw.githubusercontent.com/johnjones4/EmailFeedback/master/screenshot.png)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

EmailFeedback is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "EmailFeedback"
```

In your app delegate, add the following:

```objectivec
[EmailFeedback defaultFeedback].reviewURL = [NSURL URLWithString:@“URL to iTunes Store page”];
[EmailFeedback defaultFeedback].emailRecipient = @“test@example.com”;
[[EmailFeedback defaultFeedback] ping]
```

## Customization

The following properties of EmailFeedback are customizable: 

* *`Type propertyName` (defaultValue)*
* `BOOL sendUserDetails` (YES)
* `NSTimeInterval promptReviewAfter` (2592000)
* `BOOL repeatPrompt` (NO)
* `NSString* reviewPromptTitle` (Review Us?)
* `NSString* reviewPromptMessage` (If you like this app, would you mind writing a review for us?)
* `NSString* feedbackPromptTitle` (Feedback)
* `NSString* feedbackPromptMessage` (Would you prefer to send us feedback directly to help us improve the app?)
* `NSString* promptCancelLabel` (No Thanks)
* `NSString* promptReviewLabel` (Write Review)
* `NSString* promptSendFeedbackLabel` (Send Feedback)
* `NSURL* reviewURL` (nil)
* `NSString* emailRecipient` (nil)
* `NSString* emailSubject` (App Feedback)
* `NSString* emailBody` (Anonymous user data)
* `BOOL emailIsHTML` (NO)

## Author

John Jones, johnjones4@gmail.com

## License

EmailFeedback is available under the MIT license. See the LICENSE file for more info.
