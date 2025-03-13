//
//  MockAPIEndpoint.swift
//  ConcurrentNetworkManager
//
//  Created by Serhan Khan on 13/03/2025.
//

import XCTest
import Foundation
@testable import ConcurrentNetworkManager

// Define a mock endpoint to test
private struct MockAPIEndpoint: EndpointTargetType {
    var method: HTTPMethod
    var path: String
    var baseURL: String
    var headers: [String: String]
    var urlParameters: [String: any CustomStringConvertible]
    var body: Data?
    var apiVersion: String
}

// Mock MultipartFormData for testing
struct MockMultipartFormData {
    let boundary: String
    let fileData: Data
    let fileName: String
    let mimeType: String
    let parameters: [String: String]
    
    var asHttpBodyData: Data? {
        // Mock implementation for testing purposes
        return fileData // Simplified for example
    }
}

@MainActor private func isValidURL(_ url: URL) -> Bool {
    #if PLATFORM_IOS
    return UIApplication.shared.canOpenURL(url)
    #else
    return false
    #endif
}

final class APIEndpointTests: XCTestCase {
    
    func testURLRequestConstruction_success() {
        // Given
        let endpoint = MockAPIEndpoint(
            method: .get,
            path: "users",
            baseURL: "https://api.example.com",
            headers: ["Authorization": "Bearer token"],
            urlParameters: ["include": "details"],
            body: nil,
            apiVersion: "v1"
        )
        
        // When
        let request = endpoint.urlRequest
        
        // Then
        XCTAssertNotNil(request)
        XCTAssertEqual(request?.httpMethod, "GET")
        XCTAssertEqual(request?.url?.absoluteString, "https://api.example.com/api/v1/users?include=details")
        XCTAssertEqual(request?.allHTTPHeaderFields?["Authorization"], "Bearer token")
        XCTAssertNil(request?.httpBody)
    }
    
    func testURLRequestConstruction_withBody() {
        // Given
        let requestBody = "{\"name\":\"John\"}".data(using: .utf8)
        let endpoint = MockAPIEndpoint(
            method: .post,
            path: "users",
            baseURL: "https://api.example.com",
            headers: ["Authorization": "Bearer token", "Content-Type": "application/json"],
            urlParameters: [:],
            body: requestBody,
            apiVersion: "v1"
        )
        
        // When
        let request = endpoint.urlRequest
        
        // Then
        XCTAssertNotNil(request)
        XCTAssertEqual(request?.httpMethod, "POST")
        XCTAssertEqual(request!.url!.absoluteString, "https://api.example.com/api/v1/users?")
        XCTAssertEqual(request?.allHTTPHeaderFields?["Authorization"], "Bearer token")
        XCTAssertEqual(request?.allHTTPHeaderFields?["Content-Type"], "application/json")
        XCTAssertEqual(request?.httpBody, requestBody)
    }
    
    func testURLRequestConstruction_noURLParams() {
        // Given
        let endpoint = MockAPIEndpoint(
            method: .delete,
            path: "users/1",
            baseURL: "https://api.example.com",
            headers: [:],
            urlParameters: [:],
            body: nil,
            apiVersion: "v1"
        )
        
        // When
        let request = endpoint.urlRequest
        
        // Then
        XCTAssertNotNil(request)
        XCTAssertEqual(request?.httpMethod, "DELETE")
        XCTAssertEqual(request?.url?.absoluteString, "https://api.example.com/api/v1/users/1?")
        XCTAssertNil(request?.httpBody)
    }
    
    func testURLRequestConstruction_invalidURL() async {
        // Given
        let endpoint = MockAPIEndpoint(
            method: .get,
            path: "/users",
            baseURL: "invalid-url", // Invalid URL
            headers: [:],
            urlParameters: [:],
            body: nil,
            apiVersion: "v1"
        )
        
        // When
        let request = endpoint.urlRequest
        
        // Then
        XCTAssertNotNil(request, "Expected URLRequest to be non-nil")
        
        // Additional validation
        // Ensure that the URL is invalid
        if let url = request?.url {
            await MainActor.run {
                XCTAssertFalse(isValidURL(url), "Expected URL to be invalid but got a valid URL")
            }
        } else {
            XCTFail("URLRequest URL should not be nil")
        }
    }
    
    func testURLRequestConstruction_withEmptyPath() {
        // Given
        let endpoint = MockAPIEndpoint(
            method: .get,
            path: "",
            baseURL: "https://api.example.com",
            headers: [:],
            urlParameters: [:],
            body: nil,
            apiVersion: "v1"
        )
        
        // When
        let request = endpoint.urlRequest
        
        // Then
        XCTAssertNotNil(request)
        XCTAssertEqual(request?.url?.absoluteString, "https://api.example.com/api/v1/?")
    }
}
