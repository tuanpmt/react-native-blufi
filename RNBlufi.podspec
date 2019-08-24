
Pod::Spec.new do |s|
  s.name         = "RNBluFi"
  s.version      = "1.0.0"
  s.summary      = "RNBlufi"
  s.description  = "The ESP32 BluFi Library for iOS"
  s.homepage     = "https://github.com/tuanpmt/react-native-blufi.git"
  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = { "Tuan PM" => "tuanpm@live.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/tuanpmt/react-native-blufi.git", :tag => s.version }
  s.source_files  = "ios/**/*.{h,m,swift}"
  s.requires_arc = true

  s.ios.framework = "Foundation"
  s.dependency "React"
  s.dependency "BluFi", "1.0.1"
  #s.dependency "others"

end

  