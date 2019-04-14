//
//  LoggingViewKit - LGVRealTimeLoggerSwift
//
//  MIT License
//
//  Copyright (c) 2019-present Hituzi Ando. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation
import LoggingViewKit

/// The LGVRealTimeLogger wrapper class in Swift.
public class RealTimeLogger {

    /// The RealTimeLogger singleton instance.
    public static let shared = RealTimeLogger()

    /// Log level.  Default level is "off".
    public var logLevel:     LGVLogLevel {
        get {
            return LGVRealTimeLogger.shared().logLevel
        }
        set(logLevel) {
            LGVRealTimeLogger.shared().logLevel = logLevel
        }
    }

    /// A serializer. Default is JSON serializer.
    public var serializer:   LGVSerializer {
        get {
            return LGVRealTimeLogger.shared().serializer
        }
        set(serializer) {
            LGVRealTimeLogger.shared().serializer = serializer
        }
    }

    /// Returns added destinations.
    public var destinations: [LGVDestination] {
        return LGVRealTimeLogger.shared().destinations
    }

    /// Adds a destination outputting logs to the logger.
    ///
    /// - Parameters:
    ///   - destination: A destination outputting logs.
    public func add(destination: LGVDestination) {
        LGVRealTimeLogger.shared().addDestination(destination)
    }

    /// Adds a debug log.
    ///
    /// - Parameters:
    ///   - message: A message.
    public func d(_ message: String = "", file: String = #file, function: String = #function, line: UInt = #line) {
        d(dictionary: ["message": message], file: file, function: function, line: line)
    }

    /// Adds an info log.
    ///
    /// - Parameters:
    ///   - message: A message.
    public func i(_ message: String = "", file: String = #file, function: String = #function, line: UInt = #line) {
        i(dictionary: ["message": message], file: file, function: function, line: line)
    }

    /// Adds a warning log.
    ///
    /// - Parameters:
    ///   - message: A message.
    public func w(_ message: String = "", file: String = #file, function: String = #function, line: UInt = #line) {
        w(dictionary: ["message": message], file: file, function: function, line: line)
    }

    /// Adds an error log.
    ///
    /// - Parameters:
    ///   - message: A message.
    public func e(_ message: String = "", file: String = #file, function: String = #function, line: UInt = #line) {
        e(dictionary: ["message": message], file: file, function: function, line: line)
    }

    /// Adds a debug log.
    ///
    /// - Parameters:
    ///   - point: A point.
    ///   - comment: A comment.
    public func d(point: CGPoint, comment: String = "", file: String = #file, function: String = #function, line: UInt = #line) {
        d(dictionary: ["x": point.x,
                       "y": point.y,
                       "comment": comment],
          file: file, function: function, line: line)
    }

    /// Adds an info log.
    ///
    /// - Parameters:
    ///   - point: A point.
    ///   - comment: A comment.
    public func i(point: CGPoint, comment: String = "", file: String = #file, function: String = #function, line: UInt = #line) {
        i(dictionary: ["x": point.x,
                       "y": point.y,
                       "comment": comment],
          file: file, function: function, line: line)
    }

    /// Adds a warning log.
    ///
    /// - Parameters:
    ///   - point: A point.
    ///   - comment: A comment.
    public func w(point: CGPoint, comment: String = "", file: String = #file, function: String = #function, line: UInt = #line) {
        w(dictionary: ["x": point.x,
                       "y": point.y,
                       "comment": comment],
          file: file, function: function, line: line)
    }

    /// Adds an error log.
    ///
    /// - Parameters:
    ///   - point: A point.
    ///   - comment: A comment.
    public func e(point: CGPoint, comment: String = "", file: String = #file, function: String = #function, line: UInt = #line) {
        e(dictionary: ["x": point.x,
                       "y": point.y,
                       "comment": comment],
          file: file, function: function, line: line)
    }

    /// Adds a debug log.
    ///
    /// - Parameters:
    ///   - size: A size.
    ///   - comment: A comment.
    public func d(size: CGSize, comment: String = "", file: String = #file, function: String = #function, line: UInt = #line) {
        d(dictionary: ["width": size.width,
                       "height": size.height,
                       "comment": comment],
          file: file, function: function, line: line)
    }

    /// Adds an info log.
    ///
    /// - Parameters:
    ///   - size: A size.
    ///   - comment: A comment.
    public func i(size: CGSize, comment: String = "", file: String = #file, function: String = #function, line: UInt = #line) {
        i(dictionary: ["width": size.width,
                       "height": size.height,
                       "comment": comment],
          file: file, function: function, line: line)
    }

    /// Adds a warning log.
    ///
    /// - Parameters:
    ///   - size: A size.
    ///   - comment: A comment.
    public func w(size: CGSize, comment: String = "", file: String = #file, function: String = #function, line: UInt = #line) {
        w(dictionary: ["width": size.width,
                       "height": size.height,
                       "comment": comment],
          file: file, function: function, line: line)
    }

    /// Adds an error log.
    ///
    /// - Parameters:
    ///   - size: A size.
    ///   - comment: A comment.
    public func e(size: CGSize, comment: String = "", file: String = #file, function: String = #function, line: UInt = #line) {
        e(dictionary: ["width": size.width,
                       "height": size.height,
                       "comment": comment],
          file: file, function: function, line: line)
    }

    /// Adds a debug log.
    ///
    /// - Parameters:
    ///   - rect: A rect.
    ///   - comment: A comment.
    public func d(rect: CGRect, comment: String = "", file: String = #file, function: String = #function, line: UInt = #line) {
        d(dictionary: ["x": rect.origin.x,
                       "y": rect.origin.y,
                       "width": rect.size.width,
                       "height": rect.size.height,
                       "comment": comment],
          file: file, function: function, line: line)
    }

    /// Adds an info log.
    ///
    /// - Parameters:
    ///   - rect: A rect.
    ///   - comment: A comment.
    public func i(rect: CGRect, comment: String = "", file: String = #file, function: String = #function, line: UInt = #line) {
        i(dictionary: ["x": rect.origin.x,
                       "y": rect.origin.y,
                       "width": rect.size.width,
                       "height": rect.size.height,
                       "comment": comment],
          file: file, function: function, line: line)
    }

    /// Adds a warning log.
    ///
    /// - Parameters:
    ///   - rect: A rect.
    ///   - comment: A comment.
    public func w(rect: CGRect, comment: String = "", file: String = #file, function: String = #function, line: UInt = #line) {
        w(dictionary: ["x": rect.origin.x,
                       "y": rect.origin.y,
                       "width": rect.size.width,
                       "height": rect.size.height,
                       "comment": comment],
          file: file, function: function, line: line)
    }

    /// Adds an error log.
    ///
    /// - Parameters:
    ///   - rect: A rect.
    ///   - comment: A comment.
    public func e(rect: CGRect, comment: String = "", file: String = #file, function: String = #function, line: UInt = #line) {
        e(dictionary: ["x": rect.origin.x,
                       "y": rect.origin.y,
                       "width": rect.size.width,
                       "height": rect.size.height,
                       "comment": comment],
          file: file, function: function, line: line)
    }

    /// Adds a debug log.
    ///
    /// - Parameters:
    ///   - dictionary: A dictionary.
    public func d(dictionary: [String: Any], file: String = #file, function: String = #function, line: UInt = #line) {
        let fileName = ((file as NSString).lastPathComponent as NSString).deletingPathExtension
        LGVRealTimeLogger.shared().log(with: .debug, function: "\(fileName) \(function)", line: line, dictionary: dictionary)
    }

    /// Adds an info log.
    ///
    /// - Parameters:
    ///   - dictionary: A dictionary.
    public func i(dictionary: [String: Any], file: String = #file, function: String = #function, line: UInt = #line) {
        let fileName = ((file as NSString).lastPathComponent as NSString).deletingPathExtension
        LGVRealTimeLogger.shared().log(with: .info, function: "\(fileName) \(function)", line: line, dictionary: dictionary)
    }

    /// Adds a warning log.
    ///
    /// - Parameters:
    ///   - dictionary: A dictionary.
    public func w(dictionary: [String: Any], file: String = #file, function: String = #function, line: UInt = #line) {
        let fileName = ((file as NSString).lastPathComponent as NSString).deletingPathExtension
        LGVRealTimeLogger.shared().log(with: .warning, function: "\(fileName) \(function)", line: line, dictionary: dictionary)
    }

    /// Adds an error log.
    ///
    /// - Parameters:
    ///   - dictionary: A dictionary.
    public func e(dictionary: [String: Any], file: String = #file, function: String = #function, line: UInt = #line) {
        let fileName = ((file as NSString).lastPathComponent as NSString).deletingPathExtension
        LGVRealTimeLogger.shared().log(with: .error, function: "\(fileName) \(function)", line: line, dictionary: dictionary)
    }
}
