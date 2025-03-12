//
//  UploadProgressDelegate.swift
//  ConcurrentNetworkManager
//
//  Created by Serhan Khan on 11/03/2025.
//

import Foundation

/// A protocol to handle upload progress with URLSession task
public protocol UploadProgressDelegate: URLSessionDelegate, Sendable { }

/// A delegate class for handling upload progress.
public final class UploadProgressDelegateImpl: NSObject, UploadProgressDelegate {
    /// A closure to handle the progress updates. This closure will be called on the main thread
    private let progressHandler: (@Sendable (Double) -> Void)?
    /// Initializes the delegate with progress handler
    ///
    /// - Parameter progressHandler: A closure that will be called to handle progress updateds
    init(progressHandler: (@Sendable (Double) -> Void)?) {
        self.progressHandler = progressHandler
    }
    /// This method is called by the URLSession whenever data is sent during an upload task.
    nonisolated func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didSendBodyData bytesSent: Int64,
        totalBytesSent: Int64,
        totalBytesExpectedToSend: Int64
    ) {
        let progress = Double(totalBytesSent) / Double(totalBytesExpectedToSend)
        progressHandler?(progress)
    }
}
