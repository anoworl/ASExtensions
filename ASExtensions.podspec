Pod::Spec.new do |s|
  s.name         = "ASExtensions"
  s.version      = "0.0.1"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.summary      = "Objective-C categories"
  s.homepage     = "https://github.com/ntaku/ASExtensions"
  s.author       = { "Takuto Nishioka" => "ntakuto@gmail.com" }
  s.source       = { :git => "https://github.com/ntaku/ASExtensions.git", :tag => "#{s.version}" }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.public_header_files = 'ASExtensions/*.h'
  s.source_files  = 'ASExtensions/**/*.{h,m}'
  s.exclude_files = 'ASExtensions/dummy.m'
end
