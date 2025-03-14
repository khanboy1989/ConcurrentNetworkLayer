//
//  ApiClientImpl.swift
//  ConcurrentNetworkManager
//
//  Created by Serhan Khan on 12/03/2025.
//
import Foundation

public final class ApiClientImpl: IApiClient {
    // MARK: - Properties
    private let token: String?
    private let session: URLSession
    private let logger: ILogger
    // MARK: Initialization
    public init(
        token: String? = nil,
        session: URLSession = .shared,
        appName: String? = nil
    ) {
        self.token = token
        self.session = session
        self.logger = appName == nil ? NoLogger(label: "") : Logger(label: appName!)
    }
    // MARK: - Methods
    public func request<T: Decodable & Sendable>(
        _ endpoint: any EndpointTargetType,
        decoder: JSONDecoder
    ) async throws -> T {
        guard let request = endpoint.urlRequest else {
            throw APIClientError.invalidURL
        }

        // Perform the network request and decode the data
        let data = try await performRequest(request)

        do {
            return try decoder.decode(T.self, from: data)
        } catch let decodingError as DecodingError {
            let errorMessage = decodingError.errorDescription
            self.logger.log(level: .error, message: "Decoding Error: \(errorMessage)")
            throw APIClientError.decodingFailed(decodingError)
        } catch {
            self.logger.log(level: .error, message: "Unknown Decoding Error: \(error.localizedDescription)")
            throw APIClientError.decodingFailed(error)
        }
    }
    public func requestVoid(_ endpoint: EndpointTargetType) async throws {
        guard let request = endpoint.urlRequest else {
            throw APIClientError.invalidURL
        }
        try await performRequest(request)
    }
    @discardableResult
    public func requestWithProgress(
        _ endpoint: EndpointTargetType,
        progressDelegate: (
            any UploadProgressDelegate
        )?) async throws -> Data? {
        guard let request = endpoint.urlRequest else {
            throw APIClientError.invalidURL
        }
        do {
            let data = try await performRequest(request, progressDelegate: progressDelegate)
            return data
        } catch {
            throw error
        }
    }
}

// MARK: - Private Extension
private extension ApiClientImpl {
    /// This extension is for main request logic
    @discardableResult
    private func performRequest(
        _ request: URLRequest,
        progressDelegate: (
            any UploadProgressDelegate
        )? = nil
    ) async throws -> Data {
        // Inject Token
        self.logger.log(request: request)
        if let token = token {
            var mutableRequest = request
            mutableRequest.addValue(.tokenWithSpace + String(token), forHTTPHeaderField: .authorization)
            self.logger.log(level: .info, message: "Token: \(String(token))")
        }
        // Configure session
        let session: URLSession
        if let progressDelegate {
            session = URLSession(configuration: .default, delegate: progressDelegate, delegateQueue: nil)
        } else {
            session = self.session
        }
        do {
            // Perform Network Request
            let (data, response) = try await session.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                self.logger.log(level: .error, message: APIClientError.invalidResponse(data).description)
                throw APIClientError.invalidResponse(data)
            }
            self.logger.log(data: data, response: httpResponse)
            // Log the HTTP response
            guard (200...299).contains(httpResponse.statusCode) else {
                self.logger.log(level: .error, message: APIClientError.statusCode(httpResponse.statusCode).description)
                throw APIClientError.statusCode(httpResponse.statusCode)
            }
            return data
        } catch {
            if let urlError = error as? URLError {
                self.logger.log(level: .error, message: APIClientError.networkError(urlError).description)
                throw APIClientError.networkError(urlError)
            } else {
                self.logger.log(level: .error, message: APIClientError.requestFailed(error).description)
                throw APIClientError.requestFailed(error)
            }
        }
    }
}

// MARK: String Extension
private extension String {
    static let tokenWithSpace = "Token "
    static let authorization = "Authorization"
}

// MARK: - Log Extension
private extension ApiClientImpl {
    private func log(_ string: String) {
        #if DEBUG
        print(string)
        #endif
    }
}
