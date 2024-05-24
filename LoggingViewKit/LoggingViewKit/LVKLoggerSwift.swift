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

    /// Outputs a debug log.
    func debug(_ message: Any?, file: String = #file, function: String = #function,
               line: Int = #line)
    {
        logger.log(with: .debug,
                   function: "[\(className(from: file))] \(function)",
                   line: UInt(line),
                   message: "\(message ?? "")")
    }

    /// Outputs an info log.
    func info(_ message: Any?, file: String = #file, function: String = #function,
              line: Int = #line)
    {
        logger.log(with: .info,
                   function: "[\(className(from: file))] \(function)",
                   line: UInt(line),
                   message: "\(message ?? "")")
    }

    /// Outputs a warning log.
    func warning(_ message: Any?, file: String = #file, function: String = #function,
                 line: Int = #line)
    {
        logger.log(with: .warning,
                   function: "[\(className(from: file))] \(function)",
                   line: UInt(line),
                   message: "\(message ?? "")")
    }

    /// Outputs an error log.
    func error(_ message: Any?, file: String = #file, function: String = #function,
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
