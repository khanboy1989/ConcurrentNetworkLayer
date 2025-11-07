//
//  NMLoggerProtocol.swift
//  ConcurrentNetworkManager
//
//  Created by Serhan Khan on 07/11/2025.
//

import Foundation

/// A protocol that defines a logger used for tracking and recording events within the application.
/// Implementers of this protocol should handle logging messages with different levels of severity.
public protocol NMLoggerProtocol {
    /// Logs a message with a specified type.
    ///
    /// - Parameters:
    ///   - message: The content of the log message.
    ///   - type: The severity level of the log message.
    func log(message: String, type: NMLoggerType)
}
