//
//  LVKCounter.swift
//  LoggingViewKit
//
//  Created by Masaki Ando on 2024/04/08.
//  Copyright © 2024 Hituzi Ando. All rights reserved.
//

import Foundation

@objc(LVKCounter)
public class LVKCounter: NSObject {
    /// The name of the counter.
    @objc
    public let name: String
    /// The value of the counter.
    @objc
    public private(set) var count: Int64
    /// The date that is created to use the counter.
    @objc
    public let createdAt: Date
    /// The date that the counter was updated at.
    var updatedAt: Date?
    /// The date last updated.
    @objc
    public var lastUpdatedAt: Date {
        updatedAt ?? createdAt
    }

    private let db: LGVDatabase

    /// Initializes with default values. The value of the counter is 0.
    ///
    /// - Parameters:
    ///   - name: The name of the counter.
    ///   - db: The database.
    @objc
    public convenience init(name: String, database db: LGVDatabase) {
        self.init(name: name, count: 0, createdAt: Date(), updatedAt: nil, database: db)
    }

    /// Initializes using arguments.
    ///
    /// - Parameters:
    ///   - name: The name of the counter.
    ///   - count: The value of the counter.
    ///   - createdAt: The date that is started to use the counter.
    ///   - updatedAt: The date that the counter was updated at.
    ///   - db: The database.
    @objc
    public init(name: String, count: Int64, createdAt: Date, updatedAt: Date?,
                database db: LGVDatabase)
    {
        self.name = name
        self.count = count
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.db = db

        super.init()
    }

    override public var description: String {
        "LVKCounter(name: \(name), count: \(count), createdAt: \(createdAt), updatedAt: \(lastUpdatedAt))"
    }
}

@objc
public extension LVKCounter {
    /// Increases the count adding 1 value.
    ///
    /// - Returns: true If this counter increases the count, otherwise false.
    @discardableResult
    func increase() -> Bool {
        increase(withCondition: .anyTime)
    }

    /// Increases the count adding 1 value if the condition is met.
    ///
    /// - Parameter condition: The condition to increase the count.
    /// - Returns: true If this counter increases the count, otherwise false.
    @discardableResult
    func increase(withCondition condition: LVKIncrementCondition) -> Bool {
        switch condition {
            case .onceADay:
                let df = localDateFormat("yyyyMMdd")
                let day1 = Int(df.string(from: Date()))!
                let day2: Int
                if let updatedAt {
                    day2 = Int(df.string(from: updatedAt))!
                } else {
                    day2 = 0
                }
                if day1 > day2 {
                    addOne()
                    return save()
                } else {
                    return false
                }
            default:
                addOne()
                return save()
        }
    }

    /// Resets the counter to zero.
    ///
    /// - Returns: true If succeeded, otherwise false.
    @discardableResult
    func reset() -> Bool {
        reset(initialValue: 0)
    }

    /// Resets the counter to the initial value.
    ///
    /// - Parameter initialValue: The initial value. Default is zero.
    /// - Returns: true If succeeded, otherwise false.
    @discardableResult
    func reset(initialValue: Int64) -> Bool {
        count = initialValue
        return save()
    }
}

private extension LVKCounter {
    func addOne() {
        // If the count is max, the counter stops because it crashes when added to the maximum
        // value.
        if count < Int64.max {
            count = count + 1
        }
    }

    func save() -> Bool {
        updatedAt = Date()
        return db.save?(self) ?? false
    }

    func localDateFormat(_ format: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = .current
        formatter.dateFormat = format
        return formatter
    }
}
