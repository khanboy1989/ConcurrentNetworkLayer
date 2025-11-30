//
//  NetworkSessionProtocol.swift
//  ConcurrentNetworkManager
//
//  Created by Serhan Khan on 10/11/2025.
//

import Foundation

/// A protocol defining a network session that can perform data tasks asynchronously.
///
/// This protocol abstracts `URLSession` to enable dependency injection and improve testability.
///
/// - Note: Conforming types must implement `data(for:)` to execute network requests and return the response data

public protocol NetworkSessionProtocol: Sendable {
        
    /// Perform a network request returns the response data.
    ///
    /// - Parameter request: The `URLRequest` to be executed.
    /// - Returns: A tuple containing the response `Data` and associated `URLResponse`.
    /// - Throws: An error if the  network request fails.
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
    
}
