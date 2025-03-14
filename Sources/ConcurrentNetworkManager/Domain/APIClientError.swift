//
//  APIClientError.swift
//  ConcurrentNetworkManager
//
//  Created by Serhan Khan on 11/03/2025.
//

import Foundation

/// An enumeration representing errors that can occur during API client operations.
///
/// This enum encapsulates various errors that may arise when performing network request,
/// handling responses, or decoding data.
/// 
/// Each case provides information aboit the nature of error.
///
/// - `invalidURL`: The URL is invalid or cannot be constructed.
/// - `invalidResponse(_ data: Data)`: The response is invalid, and the associated data provides additional context.
/// - `requestFailed(_ error: any Error)`: The request failed due to an underlying error, which is provided.
/// - `decodingFailed(_ error: any Error)`: Decoding the response data failed,
/// with the associated error providing details.
/// - `notExpectedHttpResponseCode(code: Int)`: The HTTP response code was not as expected,
/// with the actual code provided.
/// - `urlRequestIsEmpty`: The URLRequest could not be created.
/// - `statusCode(Int)`: The status code from the server response is provided.
/// - `networkError(any Error)`: A network error occurred, with the underlying error provided.

enum APIClientError: Error {
    case invalidURL
    case invalidResponse(_ data: Data)
    case requestFailed(_ error: any Error)
    case decodingFailed(_ error: any Error)
    case notExpectedHttpResponseCode(code: Int)
    case urlRequestIsEmpty
    case statusCode(Int)
    case networkError(any Error)
}
extension APIClientError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .invalidURL:
            return "Invalid URL: The URL could not be constructed."
        case .invalidResponse(let data):
            return "Invalid Response: The server response was not valid. Data: \(String(decoding: data, as: UTF8.self))"
        case .requestFailed(let error):
            return "Request Failed: \(error.localizedDescription)"
        case .decodingFailed(let error):
            return "Decoding Failed: \(error.localizedDescription)"
        case .notExpectedHttpResponseCode(let code):
            return "Unexpected HTTP Response Code: \(code)"
        case .urlRequestIsEmpty:
            return "Empty URL Request: The URL request could not be created."
        case .statusCode(let code):
            return "HTTP Error: Status Code \(code)"
        case .networkError(let error):
            return "Network Error: \(error.localizedDescription)"
        }
    }
}
