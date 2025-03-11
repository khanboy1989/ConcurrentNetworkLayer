//
//  ImageMimeType.swift
//  ConcurrentNetworkManager
//
//  Created by Serhan Khan on 11/03/2025.
//
public enum ImageMimeType: String {
    case jpeg = "image/jpeg"
    case png = "image/png"
    case gif = "image/gif"
    case bmp = "image/bmp"
    case tiff = "image/tiff"
    case svg = "image/svg+xml"
    /// Returns the corresponding MIME type string for the image format.
    var asString: String {
        return rawValue
    }
}
