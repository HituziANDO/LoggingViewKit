Pod::Spec.new do |s|
  s.name                  = "LoggingViewKit"
  s.version               = "6.0.0"
  s.summary               = "LoggingViewKit is simple view logging library."
  s.description           = <<-DESC
  LoggingViewKit is a library tracking a user operation.
                            DESC
  s.homepage              = "https://github.com/HituziANDO/LoggingViewKit"
  s.license               = { :type => 'MIT', :file => 'LICENSE' }
  s.author                = "Hituzi Ando"
  s.ios.deployment_target = '13.0'
  s.osx.deployment_target = '10.15'
  s.source                = { :git => "https://github.com/HituziANDO/LoggingViewKit.git", :tag => "#{s.version}" }
  s.vendored_frameworks   = "Frameworks/LoggingViewKit.xcframework"
  s.requires_arc          = true
  s.swift_versions        = '5.0'
end
