
Pod::Spec.new do |s|
  s.name         = "RNBlufi"
  s.version      = "1.0.0"
  s.summary      = "RNBlufi"
  s.description  = "The ESP32 BluFi Library for iOS"
  s.homepage     = "https://github.com/tuanpmt/react-native-blufi.git"
  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = { "Tuan PM" => "tuanpm@live.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/tuanpmt/react-native-blufi.git", :tag => s.version }
  s.source_files  = "RNBlufi/**/*.{h,m}"
  s.requires_arc = true

  s.ios.framework = "Foundation"
  s.dependency "React"
  s.dependency "AwaitKit", "~> 5.0.0"
  s.dependency "BigInt", "~> 3.1"
  s.dependency "CryptoSwift", "0.11.0"
  s.dependency "BluFi", "1.0.0"
  #s.dependency "others"

end

  