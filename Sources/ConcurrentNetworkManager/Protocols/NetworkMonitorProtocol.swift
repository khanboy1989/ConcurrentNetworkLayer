//
//  NetworkMonitorProtocol.swift
//  ConcurrentNetworkManager
//
//  Created by Serhan Khan on 07/11/2025.
//

import Foundation
import Combine

/// A protocol defining the interface for a network monitor
///
/// This protocol provides method an publishers to check network connectivity status
/// Implementations should monitor the device's network state and notify subscribers
///
/// - Note: This protocol is designed to be dependenc-injected to interceptors
/// that need to make network aware decisions.
public protocol NetworkMonitorProtocol: Sendable {
    
    /// A boolean indicating whether the network is currently available.
    var isnetworkAvailable: Bool { get }
    
    /// A publisher that emits the boolean value indicating network availability changes.
    ///
    /// This publisher emits a `Bool` value whenever the network availability status changes.
    /// Subscribers can use this publisher to receive updates about network availability
    var isNetworkAvailablePublisher: AnyPublisher<Bool, Never> { get }
    
    /// Force refresh the network monitor state.
    /// This is useful when the network state detection gets stuck, especially in simulators.
    func forceRefresh()
}
