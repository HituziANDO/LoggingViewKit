Pod::Spec.new do |s|
  s.name         = "LoggingViewKit"
  s.version      = "0.3.0-beta"
  s.summary      = "LoggingViewKit is simple view logging library."
  s.description  = <<-DESC
  LoggingViewKit is a library tracking a user operation.
                   DESC
  s.homepage     = "https://github.com/HituziANDO/LoggingViewKit"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.platform     = :ios, "9.3"
  s.source       = { :git => "https://github.com/HituziANDO/LoggingViewKit.git", :tag => "#{s.version}" }
  s.source_files  = "LoggingViewKit/LoggingViewKit/**/*.{h,m}"
  s.exclude_files = "LoggingViewKit/build/*", "LoggingViewKit/Framework/*", "Sample/*"
  s.requires_arc = true
end
