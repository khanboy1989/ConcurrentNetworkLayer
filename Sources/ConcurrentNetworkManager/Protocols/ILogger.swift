//
//  ILogger.swift
//  ConcurrentNetworkManager
//
//  Created by Serhan Khan on 14/03/2025.
//

import Foundation
import Logging

protocol ILogger: Sendable {
    func log(level: LogLevel,
             message: @autoclosure () -> String)
}

struct Logger: ILogger {
    private let logger: Logging.Logger

    public init(label: String) {
        logger = Logging.Logger(label: label)
    }

    public func log(level: LogLevel, message: @autoclosure () -> String) {
        logger.log(level: level.toLoggingLevel(), .init(stringLiteral: message()))
    }
}

struct NoLogger: ILogger {
    private let logger: Logging.Logger

    init(label: String) {
        logger = Logging.Logger(label: label)
    }

    func log(level _: LogLevel, message _: @autoclosure () -> String) {
        // Do nothing
    }
}

public enum LogLevel {
    case trace
    case debug
    case info
    case notice
    case warning
    case error
    case critical

    func toLoggingLevel() -> Logging.Logger.Level {
        switch self {
        case .trace:
            return .trace
        case .debug:
            return .debug
        case .info:
            return .info
        case .notice:
            return .notice
        case .warning:
            return .warning
        case .error:
            return .error
        case .critical:
            return .critical
        }
    }
}
