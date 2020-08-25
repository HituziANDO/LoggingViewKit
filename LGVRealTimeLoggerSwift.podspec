Pod::Spec.new do |s|
  s.name          = "LGVRealTimeLoggerSwift"
  s.version       = "0.3.0-beta"
  s.summary       = "LGVRealTimeLoggerSwift is a logger library in Swift."
  s.description   = <<-DESC
  LGVRealTimeLoggerSwift is a logger library in Swift.
                   DESC
  s.homepage      = "https://github.com/HituziANDO/LoggingViewKit"
  s.license       = { :type => 'MIT', :file => 'LICENSE' }
  s.platform      = :ios, "9.3"
  s.source        = { :git => "https://github.com/HituziANDO/LoggingViewKit.git", :tag => "#{s.version}" }
  s.source_files  = "LGVRealTimeLoggerSwift/LGVRealTimeLoggerSwift/**/*.{h,m,swift}"
  s.exclude_files = "LGVRealTimeLoggerSwift/build/*", "LGVRealTimeLoggerSwift/Framework/*", "LGVRealTimeLoggerSwift/LGVRealTimeLoggerSwift/Dependency/*", "LoggingViewKit/*", "Sample/*"
  s.requires_arc  = true
end
