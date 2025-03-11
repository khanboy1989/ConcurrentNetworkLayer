//
//  ApiClient.swift
//  ConcurrentNetworkManager
//
//  Created by Serhan Khan on 11/03/2025.
//

import Foundation

/// A protocol defining the methods for making API requests.
public protocol IApiClient {
    /// Sends a request to the specified endpoint and decodes the response into a given type.
    ///
    /// - Parameters:
    ///  - endpoint: The endpoint to request
    ///  - decoder: The `JSONDecoder` to use for decoding the response.
    /// - Returns: The decoded response of the type `T`.
    /// - Throws: An error if the request fails or if decoding fails
    /// - Note: The type `T` must conform to `Codable` and `Sendable`
    func request<T: Codable & Sendable>(
        _ endpoint: any IApiClient,
        decoder: JSONDecoder
    ) async throws -> T
    
    /// Sends a request that does not return the response body
    ///
    /// - Parameters:
    ///  - endpoint: The endpoint to request
    ///  - decoder: The `JSONDecoder` to use for decoding the response.
    ///  - Returns: The decoded response of the type `T`
    ///  - Throws: An error if the request fails or if decoding fails
    ///  - This method can be used for various HTTP Method that we are not interested in the
    ///   response/return value but only if it succeed or fails, such as `POST`, `DELETE`, and `PATCH` and more.
    func requestVoid(_ endpoint: any IApiClient) async throws
    
    /// Sends a request to the specified endpoint and returns the raw data with upload progress
    ///
    /// - Parameters:
    ///     - endpoint: The endpoint to request
    ///     - progressDelegate: An optional delegate for tracking upload progress
    /// - Returns: The raw `Data` received from the request, or `nil` if no data is received
    /// - Throws : An error if the request fails.
    @discardableResult
    func requestWithProgress(_ endpoint: any IApiClient, progressDelegate: (any Upload))
}
