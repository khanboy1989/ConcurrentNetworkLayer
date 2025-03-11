//
//  UploadProgressDelegate.swift
//  ConcurrentNetworkManager
//
//  Created by Serhan Khan on 11/03/2025.
//

import Foundation

/// A protocol to handle upload progress with URLSession task
protocol UploadProgressDelegate: URLSessionDelegate, Sendable { }

/// A delegate class for handling upload progress.
final class UploadProgressDelegateImpl: NSObject, UploadProgressDelegate {
    
    /// A closure to handle the progress updates. This closure will be called on the main thread
    private let progressHandler: (@Sendable (Double) -> Void)?
    
    
}
