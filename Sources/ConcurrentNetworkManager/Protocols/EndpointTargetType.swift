//
//  APIEndpointProtocol.swift
//  ConcurrentNetworkManager
//
//  Created by Serhan Khan on 11/03/2025.
//

import Foundation

/// A proEndpointTargetTypetocol defining the requirements for an API endpoint.
///
/// This protocol specifies the necessary components to construct a URL request for an API endpoint.
/// It includes details such as the HTTP method, path, base URL, headers, URL parameters, body, and API version.
/// Conforming types must provide these components to enable API requests.
///
/// - `method`: The HTTP method to be used for the request (e.g., GET, POST).
/// - `path`: The specific path for the endpoint relative to the base URL.
/// - `baseURL`: The base URL for the API.
/// - `headers`: A dictionary of HTTP headers to include in the request.
/// - `urlParams`: A dictionary of query parameters to include in the URL.
///    The values must conform to `CustomStringConvertible`.
/// - `body`: The body of the request, if any, as `Data`.
/// - `urlRequest`: A computed `URLRequest` based on the provided components.
///    Returns `nil` if the URL cannot be constructed.
/// - `apiVersion`: The version of the API being used.
public protocol EndpointTargetType {
    /// HTTP method used by endpoint
    var method: HTTPMethod { get }
    /// Path for endpoint
    var path: String { get }
    /// Base URL for the API
    var baseURL: String { get }
    /// Headers for request
    var headers: [String: String] { get }
    /// URL parameters for the request
    var urlParameters: [String: any CustomStringConvertible] { get }
    /// Body data for the request
    var body: Data? { get }
    /// URLRequest representation of the endpoint
    var urlRequest: URLRequest? { get }
    /// API version used by the endpoint
    var apiVersion: String { get }
}
