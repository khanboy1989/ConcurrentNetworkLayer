//
//  HTTPBody.swift
//  ConcurrentNetworkManager
//
//  Created by Serhan Khan on 22/10/2025.
//

import Foundation

/// Represents different types of HTTP request bodies.
public enum HTTPBody {
   
    /// A raw data HTTP body.
    case data(Data)
    
    /// A JSON-encoded HTTP body
    case json(Data)
    
    ///
}
