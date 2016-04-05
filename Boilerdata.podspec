Pod::Spec.new do |s|
  s.name             = "Boilerdata"
  s.version          = "0.3.2"
  s.summary          = "A powerful and extensible toolkit aimed at bringing these nasty dynamic lists of data to UI."

  s.description      = 'A detailed description will be here soon. Someday.'

  s.homepage         = "https://github.com/nickynick/Boilerdata"  
  s.license          = 'MIT'
  s.author           = { "Nick Tymchenko" => "t.nick.a@gmail.com" }
  s.source           = { :git => "https://github.com/nickynick/Boilerdata.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/nickynick42'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Boilerdata/**/*.{h,m}'
  s.public_header_files = 'Boilerdata/**/*.h'

  s.frameworks = 'UIKit'

  s.dependency 'NNArrayDiff', '~> 0.3'
  s.dependency 'UIKitWorkarounds', '>= 0.2'
end
