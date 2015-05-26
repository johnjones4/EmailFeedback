Pod::Spec.new do |s|
  s.name             = "EmailFeedback"
  s.version          = "0.1.1"
  s.summary          = "Yet another feedback prompt. This one directs users to submit email feedback or write a review."
  s.description      = <<-DESC
                       Yet another feedback prompt. This one directs users to submit email feedback or write a review. The app will ask users of the after a set period of time (30 days by default) to review the app. If the user declines, the user is then asked if he or she prefers to just send feedback directly. Selecting this option opens an email composer view with some information about the app and device preloaded. All of the strings and time intervals used in this Pod are customizable.
                       DESC
  s.homepage         = "https://github.com/johnjones4/EmailFeedback"
  s.screenshots      = "https://raw.githubusercontent.com/johnjones4/EmailFeedback/master/screenshot.png"
  s.license          = 'MIT'
  s.author           = { "John Jones" => "johnjones4@gmail.com" }
  s.source           = { :git => "https://github.com/johnjones4/EmailFeedback.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/johnjones4'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'

  s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'MessageUI'
end
