Pod::Spec.new do |s|

  s.name         = "YZNotificationView"
  s.version      = "0.0.1"
  s.summary      = "A short description of YZNotificationView."

  s.description  = "This is UIView like a VK notification view"

  s.homepage     = "https://bitbucket.org/YLincoln/yznotificationview/src/master/"

  s.license      = "MIT"

  s.author             = { "Yaroslav" => "yaroslavzavyalov1@gmail.com" }

  s.platform     = :ios, "11.0"

  s.source       = { :git => "http://EXAMPLE/YZNotificationView.git", :tag => "#{s.version}" }

  s.source_files  = "Classes", "Classes/**/*.{h,m}"
  s.exclude_files = "Classes/Exclude"

  s.swift_version = "4.2"

end
