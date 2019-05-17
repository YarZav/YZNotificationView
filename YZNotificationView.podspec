Pod::Spec.new do |s|

   s.platform = :ios
   s.ios.deployment_target = '11.0'
   s.name = "YZNotificationView"
   s.summary = "Short description of YZNotificationView."
   s.requires_arc = true

   s.version = "1.0.0"

   s.author = { "Yaroslav Zavyalov" => "yaroslavzavyalov1@gmail.com" }

   s.homepage = "https://github.com/YarZav/YZNotificationView"

   s.source = { :git => "https://github.com/YarZav/YZNotificationView.git", :tag => "#{s.version}"}

   s.framework = "UIKit"

   s.source_files = "YZNotificationView/**/*.{swift}"

   s.resources = "YZNotificationView/**/*.{png,jpeg,jpg,storyboard,xib}"
   s.resource_bundles = {
      'YZNotificationView' => ['YZNotificationView/**/*.xcassets']
   }
end
