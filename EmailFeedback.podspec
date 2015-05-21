Pod::Spec.new do |s|
  s.name             = "EmailFeedback"
  s.version          = "0.1.0"
  s.summary          = "Yet another feedback prompt. This one directs users to submit email feedback or write a review."
  s.description      = <<-DESC
                       Yet another feedback prompt. This one directs users to submit email feedback or write a review.
                       DESC
  s.homepage         = "https://github.com/johnjones4/EmailFeedback"
  s.screenshots      = "https://raw.githubusercontent.com/johnjones4/EmailFeedback/master/screenshot.png"
  s.license          = 'MIT'
  s.author           = { "John Jones" => "johnjones4@gmail.com" }
  s.source           = { :git => "git@github.com:johnjones4/EmailFeedback.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/johnjones4'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'

  s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'MessageUI'
end
