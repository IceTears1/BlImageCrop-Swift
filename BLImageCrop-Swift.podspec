
Pod::Spec.new do |s|

s.name         = "BLImageCrop-Swift"
s.version      = "1.0.0"
s.summary      = "图片剪裁swift 版本"
s.description  = "轻量级的 图片剪裁 swift 版本"
s.homepage     = "https://github.com/IceTears1/BlImageCrop-Swift"
s.license      = { :type => "MIT", :file => "LICENSE" }
s.author             = { "冰" => "642203775@qq.com" }
s.platform     = :ios, "8.0"
s.source       = { :git => "https://github.com/IceTears1/BlImageCrop-Swift.git", :tag => s.version }
s.source_files  = "BLImageCropView/BLImageCropView/BLImageCrop/*.{swift}"
s.requires_arc = true
s.swift_version = '4.0'

end
