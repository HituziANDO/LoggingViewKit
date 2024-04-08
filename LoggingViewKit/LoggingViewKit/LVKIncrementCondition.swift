//
//  LVKIncrementCondition.swift
//  LoggingViewKit
//
//  Created by Masaki Ando on 2024/04/08.
//  Copyright © 2024 Hituzi Ando. All rights reserved.
//

import Foundation

@objc(LVKIncrementCondition)
public enum LVKIncrementCondition: Int {
    /// Can be incremented at any time.
    case anyTime
    /// Can be incremented once a day. If the execution day of the counter is greater than the last
    /// updated day, the counter can be increased.
    case onceADay
}
