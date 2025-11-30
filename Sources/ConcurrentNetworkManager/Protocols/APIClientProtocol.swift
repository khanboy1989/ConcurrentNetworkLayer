//
//  APIClientProtocol.swift
//  ConcurrentNetworkManager
//
//  Created by Serhan Khan on 29/11/2025.
//

import Foundation

/// A protocol defining an API client for making network requests.
///
/// `APIClientProtocol` provides methods for sending requests to API endpoints and decoding responses.
/// It supports standard requests, void requests, and requests with progress tracking.
///
/// All methods are asynchronous and throw errors if the request fails.
///
/// - Note: Conforming types must be `Sendable` to ensure thread safety.
public protocol APIClientProtocol: Sendable {
    var interceptors: [any NetworkInterceptorProtocol] { get }
    var session: NetworkSessionProtocol { get }

    /// Sends a request to the specified endpoint and decodes the response into the specified type.
    ///
    /// - Parameters:
    ///   - endpoint: The API endpoint to send the request to.
    ///   - decoder: A `JSONDecoder` instance used for decoding the response. Defaults to `JSONDecoder()`.
    ///   - id: A unique identifier for the request. Defaults to `UUID()`.
    /// - Returns: A decoded instance of type `T`.
    /// - Throws: An error if the request fails or if decoding the response data is unsuccessful.
    /// - Note: The type `T` must conform to `Decodable` and `Sendable`.
    ///
    func request<T: Decodable & Sendable>(
        _ endpoint: any APIEndpointProtocol,
        decoder: JSONDecoder,
        id: String
    ) async throws -> T

    /// Sends a request that does not return the response body.
    ///
    /// - Parameters:
    ///   - endpoint: The endpoint to request.
    ///   - id: A unique identifier for the request. Defaults to `UUID()`.
    /// - Throws: An error if the request fails or if decoding fails.
    /// - This method can be used for various HTTP methods that we are not interested in the response/return value but only if it succeed or fails, such as `POST`, `DELETE`, and `PATCH` and more.
    ///
    func request(
        _ endpoint: any APIEndpointProtocol,
        id: String
    ) async throws

    /// Sends a request to the specified endpoint and returns the raw data with the upload progress.
    ///
    /// - Parameters:
    ///   - endpoint: The endpoint to request.
    ///   - progressDelegate: An optional delegate for tracking upload progress.
    ///   - id: A unique identifier for the request. Defaults to `UUID()`.
    /// - Returns: The raw `Data` received from the request, or `nil` if no data is received.
    /// - Throws: An error if the request fails.
    ///
    @discardableResult
    func request(
        _ endpoint: any APIEndpointProtocol,
        progressDelegate: (any UploadProgressDelegateProtocol)?,
        id: String
    ) async throws -> Data?

    /// Cancels an ongoing request with the specified identifier.
    ///
    /// - Parameter id: The unique identifier of the request to cancel.
    func cancelRequest(with id: String)

    /// Cancels all ongoing requests.
    func cancelAllRequests()
}

public extension APIClientProtocol {
    /// Sends a request to the specified endpoint and decodes the response into the specified type,
    /// using a default `JSONDecoder()`.
    ///
    /// - Parameter endpoint: The API endpoint to send the request to.
    /// - Returns: A decoded instance of type `T`.
    /// - Throws: An error if the request fails or if decoding the response data is unsuccessful.
    ///
    func request<T: Decodable & Sendable>(
        _ endpoint: any APIEndpointProtocol
    ) async throws -> T {
        try await request(
            endpoint,
            decoder: JSONDecoder(),
            id: UUID().uuidString
        )
    }

    func request(
        _ endpoint: any APIEndpointProtocol
    ) async throws {
        try await request(
            endpoint,
            id: UUID().uuidString
        )
    }

    @discardableResult
    func request(
        _ endpoint: any APIEndpointProtocol,
        progressDelegate: (any UploadProgressDelegateProtocol)?
    ) async throws -> Data? {
        try await request(
            endpoint,
            progressDelegate: progressDelegate,
            id: UUID().uuidString
        )
    }
}

