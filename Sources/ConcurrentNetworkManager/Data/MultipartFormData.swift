//
//  MultipartFormData.swift
//  ConcurrentNetworkManager
//
//  Created by Serhan Khan on 12/03/2025.
//
import Foundation

/// A model representing multipart form data configuration
public struct MultipartFormData {
    /// Boundary string used to separate parts.
    let boundary: String
    /// Data of the file to upload
    let fileData: Data
    /// Name of the file
    let fileName: String
    /// MIME type of the file
    let mimeType: String
    /// Parameters to include in the multipart form data.
    let parameters: [String: String]
}

public extension MultipartFormData {
    var asHttpBodyData: Data {
        var body = Data()

        // Add parameters
        for (key, value) in parameters {
            body.append(Data("--\(boundary)\r\n".utf8))
            body.append(Data("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".utf8))
            body.append(Data("\(value)\r\n".utf8))
        }
        // Add file data
        body.append(Data("--\(boundary)\r\n".utf8))
        body.append(Data("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\r\n".utf8))
        body.append(Data("Content-Type: \(mimeType)\r\n\r\n".utf8))
        body.append(fileData)
        body.append(Data("\r\n".utf8))
        // End boundary
        body.append(Data("--\(boundary)--\r\n".utf8))
        return body
    }
}
