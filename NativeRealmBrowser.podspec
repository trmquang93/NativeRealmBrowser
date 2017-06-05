Pod::Spec.new do |s|

# 1
s.platform = :ios
s.ios.deployment_target = '8.0'
s.name = "NativeRealmBrowser"
s.summary = "Lightweight browser that let's you inspect which objects currently are in your realm database on your iOS device or simulator."
s.requires_arc = true

# 2
s.version = "0.1.0"

# 3
s.license = { :type => "MIT", :file => "LICENSE" }

# 4 - Replace with your name and e-mail address
s.author = { "Tran Minh Quang" => "trmquang3103@gmail.com" }


# 5 - Replace this URL with your own Github page's URL (from the address bar)
s.homepage = "https://github.com/trmquang93/NativeRealmBrowser"

# For example,
# s.homepage = "https://github.com/JRG-Developer/RWPickFlavor"


# 6 - Replace this URL with your own Git URL from "Quick Setup"
s.source = { :git => "https://github.com/trmquang93/NativeRealmBrowser.git", :tag => "#{s.version}"}

# For example,
# s.source = { :git => "https://github.com/JRG-Developer/RWPickFlavor.git", :tag => "#{s.version}"}


# 7
s.framework = "UIKit"
s.dependency 'RealmSwift'

# 8
s.source_files = "NativeRealmBrowser/**/*.{swift}"

# 9
# s.resources = "NativeRealmBrowser/**/*.{png,jpeg,jpg,storyboard,xib}"
end
