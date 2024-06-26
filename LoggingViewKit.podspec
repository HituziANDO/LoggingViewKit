Pod::Spec.new do |s|
  s.name                  = "LoggingViewKit"
  s.version               = "6.1.6"
  s.summary               = "LoggingViewKit is a framework for logging and debugging."
  s.description           = <<-DESC
  LoggingViewKit is a framework that can record user click events, etc. All records are stored in a local database and the framework does not send any data externally.
                            DESC
  s.homepage              = "https://github.com/HituziANDO/LoggingViewKit"
  s.license               = { :type => 'MIT', :text => 'Copyright © Hituzi Ando. All rights reserved.' }
  s.author                = "Hituzi Ando"
  s.ios.deployment_target = '13.0'
  s.osx.deployment_target = '10.15'
  s.source                = { :git => "https://github.com/HituziANDO/LoggingViewKit.git", :tag => "#{s.version}" }
  s.source_files          = "LoggingViewKit/LoggingViewKit/**/*.{h,m,swift}"
  s.ios.exclude_files     = "Frameworks/*", "Sample/*"
  s.osx.exclude_files     = "Frameworks/*", "Sample/*", "LoggingViewKit/LoggingViewKit/iOS/*", "LoggingViewKit/LoggingViewKit/LVKLogViewController.swift"
  s.resource_bundles      = {"LoggingViewKit" => ["LoggingViewKit/PrivacyInfo.xcprivacy"]}
  s.requires_arc          = true
  s.swift_versions        = ['5.0']
  s.ios.framework         = 'UIKit'
end
