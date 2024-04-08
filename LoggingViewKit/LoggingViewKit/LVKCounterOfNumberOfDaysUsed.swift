//
//  LVKCounterOfNumberOfDaysUsed.swift
//  LoggingViewKit
//
//  Created by Masaki Ando on 2024/04/08.
//  Copyright © 2024 Hituzi Ando. All rights reserved.
//

import Foundation

/// The counter to count up the number of days used app.
@objc(LVKCounterOfNumberOfDaysUsed)
public class LVKCounterOfNumberOfDaysUsed: NSObject {
    private let counter: LVKCounter

    @objc
    public init(counter: LVKCounter) {
        self.counter = counter

        super.init()
    }
}

@objc
public extension LVKCounterOfNumberOfDaysUsed {
    /// The value of the counter.
    var count: Int64 {
        counter.count
    }

    /// Increases the count adding 1 value if the day is different from the last updated day.
    ///
    /// - Returns: true If this counter increases the count, otherwise false.
    @discardableResult
    func increase() -> Bool {
        let now = Date()
        let df = localDateFormat("yyyyMMdd")
        let day1 = Int(df.string(from: now))!
        let day2: Int
        if let updatedAt = counter.updatedAt {
            day2 = Int(df.string(from: updatedAt))!
        } else {
            day2 = 0
        }
        if day1 > day2 {
            return counter.increase()
        } else {
            return false
        }
    }

    /// Resets the counter to the initial value.
    ///
    /// - Parameter initialValue: The initial value. Default is zero.
    /// - Returns: true If succeeded, otherwise false.
    @discardableResult
    func reset(initialValue: Int64 = 0) -> Bool {
        counter.reset(initialValue: initialValue)
    }
}

private extension LVKCounterOfNumberOfDaysUsed {
    func localDateFormat(_ format: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = .current
        formatter.dateFormat = format
        return formatter
    }
}
