//
//  LVKLoggerSwift.swift
//  LoggingViewKit
//
//  Created by Masaki Ando on 2024/05/24.
//  Copyright © 2024 Hituzi Ando. All rights reserved.
//

import Foundation

/// A logger for Swift.
public class LVKLoggerSwift {
    private let logger: LGVRealTimeLogger

    /// Initializes a logger.
    ///
    /// - Parameters:
    ///   - identifier: An identifier of the logger.
    ///   - withDefaultDestination: If true, a Xcode console destination is added by default.
    public init(identifier: String, withDefaultDestination: Bool = true) {
        logger = LGVRealTimeLogger(identifier: identifier)

        if withDefaultDestination {
            // Add a default destination.
            add(destination: LGVXcodeConsoleDestination())
        }
    }
}

public extension LVKLoggerSwift {
    /// Log level. Default level is off.
    var logLevel: LGVLogLevel {
        get {
            logger.logLevel
        }
        set {
            logger.logLevel = newValue
        }
    }

    /// A serializer. Default is the StringSerializer.
    var serializer: LGVSerializer {
        get {
            logger.serializer
        }
        set {
            logger.serializer = newValue
        }
    }

    /// Adds a destination to output logs to the logger.
    ///
    /// - Parameter destination: A destination to output logs.
    /// - Returns: The logger.
    @discardableResult
    func add(destination: LGVDestination) -> Self {
        logger.add(destination)
        return self
    }

    /// Print detailed information about the application and the device for debug level.
    func logAppDetails() {
        let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? ""
        let appVersion = Bundle.main
            .object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
        let appBuild = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? ""
        let osVersion = ProcessInfo.processInfo.operatingSystemVersion
        let osVersionString =
            "\(osVersion.majorVersion).\(osVersion.minorVersion).\(osVersion.patchVersion)"
        let deviceLanguage = Locale.preferredLanguages.first ?? ""
        let deviceTimeZone = TimeZone.current.identifier
        let deviceLocale = Locale.current.identifier
        #if os(iOS)
        let deviceModel = UIDevice.current.model
        let deviceName = UIDevice.current.name
        let deviceSystemName = UIDevice.current.systemName
        let deviceSystemVersion = UIDevice.current.systemVersion
        let deviceScreenSize =
            "\(UIScreen.main.bounds.size.width)x\(UIScreen.main.bounds.size.height)"
        let deviceScreenScale = UIScreen.main.scale
        let deviceSummary = """
        Device Model: \(deviceModel)
        Device Name: \(deviceName)
        Device System Name: \(deviceSystemName)
        Device System Version: \(deviceSystemVersion)
        Device Screen Size: \(deviceScreenSize)
        Device Screen Scale: \(deviceScreenScale)
        """
        #endif

        debug("""
        App Name: \(appName)
        App Version: \(appVersion) (\(appBuild))
        OS Version: \(osVersionString)
        Device Language: \(deviceLanguage)
        Device Time Zone: \(deviceTimeZone)
        Device Locale: \(deviceLocale)
        """ + {
            #if os(iOS)
            return "\n\(deviceSummary)"
            #else
            return ""
            #endif
        }())
    }

    /// Outputs a debug log.
    func debug(_ message: Any? = nil, file: String = #file, function: String = #function,
               line: Int = #line)
    {
        logger.log(with: .debug,
                   function: "[\(className(from: file))] \(function)",
                   line: UInt(line),
                   message: "\(message ?? "")")
    }

    /// Outputs an info log.
    func info(_ message: Any? = nil, file: String = #file, function: String = #function,
              line: Int = #line)
    {
        logger.log(with: .info,
                   function: "[\(className(from: file))] \(function)",
                   line: UInt(line),
                   message: "\(message ?? "")")
    }

    /// Outputs a warning log.
    func warning(_ message: Any? = nil, file: String = #file, function: String = #function,
                 line: Int = #line)
    {
        logger.log(with: .warning,
                   function: "[\(className(from: file))] \(function)",
                   line: UInt(line),
                   message: "\(message ?? "")")
    }

    /// Outputs an error log.
    func error(_ message: Any? = nil, file: String = #file, function: String = #function,
               line: Int = #line)
    {
        logger.log(with: .error,
                   function: "[\(className(from: file))] \(function)",
                   line: UInt(line),
                   message: "\(message ?? "")")
    }
}

private extension LVKLoggerSwift {
    func className(from file: String) -> String {
        file.components(separatedBy: "/").last?.components(separatedBy: ".").first ?? ""
    }
}
