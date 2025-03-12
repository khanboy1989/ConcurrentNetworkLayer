//
//  ApiClientImpl.swift
//  ConcurrentNetworkManager
//
//  Created by Serhan Khan on 12/03/2025.
//
import Foundation

public final class ApiClientImpl: IApiClient {
    private let token: String?
    private let session: URLSession
    
    init(token: String? = nil, session: URLSession = .shared) {
        self.token = token
        self.session = session
    }
    
    
}
