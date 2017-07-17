
Pod::Spec.new do |s|


# 1
s.platform = :ios
s.ios.deployment_target = '8.0'
s.requires_arc = true
s.name             = 'NativeRealmBrowser'
s.summary          = 'Lightweight browser that let's you inspect which objects currently are in your realm database on your iOS device or simulator.'

# 2
s.version = "0.1.0"

# 3
s.license = { :type => "MIT", :file => "LICENSE" }

# 4 - Replace with your name and e-mail address
s.author = { "Tran Minh Quang" => "trmquang3103@gmail.com" }

# 5 - Replace this URL with your own Github page's URL (from the address bar)
s.homepage = "https://github.com/trmquang93/NativeRealmBrowser"

# 6 - Replace this URL with your own Git URL from "Quick Setup"
s.source = { :git => 'https://github.com/trmquang93/NativeRealmBrowser.git', :tag => s.version.to_s }

# 7
s.framework = "UIKit"
s.dependency 'RealmSwift'

# 8
s.source_files = 'NativeRealmBrowser/Classes/**/*'
end
