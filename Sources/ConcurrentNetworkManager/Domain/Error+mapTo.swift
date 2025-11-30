//
//  Error+mapTo.swift
//  ConcurrentNetworkManager
//
//  Created by Serhan Khan on 29/11/2025.
//

import Foundation

public extension Error {
    func mapTo<T: Error>(_ transform: (String) -> T) -> Error {
        if let apiError = self as? APIClientError,
           case let .serverMessage(message, _) = apiError {
            return transform(message)
        } else {
            return self
        }
    }
}
