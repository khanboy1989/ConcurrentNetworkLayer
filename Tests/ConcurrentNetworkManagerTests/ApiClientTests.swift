//
//  EndpointTargetType.swift
//  ConcurrentNetworkManager
//
//  Created by Serhan Khan on 13/03/2025.
//

import XCTest

@testable import ConcurrentNetworkManager

// Define a mock endpoint to test
private struct MockEndpointTarget: EndpointTargetType {
    var method: HTTPMethod
    var path: String
    var baseURL: String
    var headers: [String : String]
    var urlParameters: [String : any CustomStringConvertible]
    var body: Data?
    var apiVersion: String
}

private struct MockApiClient: IApiClient {
    var mockedData: Data?
    var mockedError: Error?
    var shouldSimulateRequestError: Bool = false
    
    func request<T: Codable & Sendable>(_ endpoint: any EndpointTargetType, decoder: JSONDecoder) async throws -> T {
        
        if shouldSimulateRequestError {
            throw URLError(.badServerResponse)
        }
        
        if let error = mockedError {
            throw error
        }
        
        guard let data = mockedData else {
            throw NSError(domain: "MockErrorDomain", code: 0, userInfo: nil)
        }
        
        return try decoder.decode(T.self, from: data)
    }
    
    
    func requestVoid(_ endpoint: any EndpointTargetType) async throws {
        if shouldSimulateRequestError {
            throw URLError(.badServerResponse)
        }
        
        if let error = mockedError {
            throw error
        }
    }
    
    @discardableResult
    func requestWithProgress(_ endpoint: any EndpointTargetType, progressDelegate: (any UploadProgressDelegate)?) async throws -> Data? {
        
        if shouldSimulateRequestError {
            throw URLError(.badServerResponse)
        }
        
        if let error = mockedError {
            throw error
        }
        
        return mockedData
    }
}

// Given
private struct User: Codable, Sendable {
    let id: Int
    let name: String
}

final class ApiClientTests: XCTest {
    private var apiClient: MockApiClient!
    
    override func setUp() {
        super.setUp()
        apiClient = MockApiClient()
    }
    
    func testRequest_success() async throws {
        let jsonData = "{\"id\":1,\"name\":\"John\"}".data(using: .utf8)
        apiClient.mockedData = jsonData
        
        // When
        let user: User = try await apiClient.request(
            MockEndpointTarget(
                method: .get,
                path: "/users/1",
                baseURL: "https://api.example.com",
                headers: [:],
                urlParameters: [:],
                body: nil,
                apiVersion: "v1"
            ), decoder: JSONDecoder())
        
        // Then
        XCTAssertEqual(user.id, 1)
        XCTAssertEqual(user.name, "John")
    }
    
    func testRequest_failure() async {
        // Given
        let expectedError = NSError(domain: "MockErrorDomain", code: 1, userInfo: nil)
        apiClient.mockedError = expectedError
        
        // When
        do {
            let _: User = try await apiClient.request(MockEndpointTarget(
                method: .get,
                path: "/users/1",
                baseURL: "https://api.example.com",
                headers: [:],
                urlParameters: [:],
                body: nil,
                apiVersion: "v1"
            ), decoder: JSONDecoder())
            XCTFail("Expected error to be thrown")
        } catch let error as NSError {
            // Then
            XCTAssertEqual(error.domain, expectedError.domain)
            XCTAssertEqual(error.code, expectedError.code)
        }
    }
    
    func testRequestData_success() async throws {
        // Given
        let responseData = "some data".data(using: .utf8)
        apiClient.mockedData = responseData
        
        // When
        let data = try await apiClient.requestData(MockEndpointTarget(
            method: .get,
            path: "/files",
            baseURL: "https://api.example.com",
            headers: [:],
            urlParameters: [:],
            body: nil,
            apiVersion: "v1"
        ))
        
        // Then
        XCTAssertEqual(data, responseData)
    }
    
    func testRequestDatat_failure() async {
        let expectedError = NSError(domain: "MockErrorDomain", code: 1, userInfo: nil)
        apiClient.mockedError = expectedError
        
        // When
        do {
            _ = try await apiClient.requestData(MockEndpointTarget(
                method: .get,
                path: "/files",
                baseURL: "https://api.example.com",
                headers: [:],
                urlParameters: [:],
                body: nil,
                apiVersion: "v1"
            ))
            XCTFail("Expected error to be thrown")
        } catch let error as NSError {
            // Then
            XCTAssertEqual(error.domain, expectedError.domain)
            XCTAssertEqual(error.code, expectedError.code)
        }
    }
    
    func testRequest_defaultDecoder() async throws {
        // Given
        struct User: Codable, Sendable {
            let id: Int
            let name: String
        }
        
        let jsonData = "{\"id\":1,\"name\":\"John\"}".data(using: .utf8)
        apiClient.mockedData = jsonData
        
        // When
        let user: User = try await apiClient.request(MockEndpointTarget(
            method: .get,
            path: "/users/1",
            baseURL: "https://api.example.com",
            headers: [:],
            urlParameters: [:],
            body: nil,
            apiVersion: "v1"
        ))
        
        // Then
        XCTAssertEqual(user.id, 1)
        XCTAssertEqual(user.name, "John")
    }
    
    func testRequestData_validRequest() async throws {
        // Given
        let expectedData = "some data".data(using: .utf8)
        apiClient.mockedData = expectedData
        
        let endpoint = MockEndpointTarget(
            method: .get,
            path: "/users",
            baseURL: "https://api.example.com",
            headers: [:],
            urlParameters: [:],
            body: nil,
            apiVersion: "v1"
        )
        
        // When
        let data = try await apiClient.requestWithProgress(endpoint, progressDelegate: nil)
        
        // Then
        XCTAssertNotNil(data, "Expected data to be not nil")
        XCTAssertEqual(data, expectedData, "Expected data to match the mocked data")
    }
    
    func testRequestData_performRequestError() async {
        // Given
        let endpoint = MockEndpointTarget(
            method: .get,
            path: "/users",
            baseURL: "https://api.example.com",
            headers: [:],
            urlParameters: [:],
            body: nil,
            apiVersion: "v1"
        )
        
        // Set up MockAPIClient to simulate an error
        apiClient = MockApiClient(shouldSimulateRequestError: true)
        
        // When/Then
        do {
            _ = try await apiClient.requestWithProgress(endpoint, progressDelegate: nil)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual((error as? URLError)?.code, .badServerResponse)
        }
    }
    
}
