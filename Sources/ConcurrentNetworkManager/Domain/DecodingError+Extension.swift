//
//  DecodingError+Extension.swift
//  ConcurrentNetworkManager
//
//  Created by Serhan Khan on 14/03/2025.
//

extension DecodingError {
    var errorDescription: String {
        switch self {
        case .keyNotFound(let key, let context):
            return "🛑 Key '\(key.stringValue)' not found. Context: \(context.debugDescription)"
        case .typeMismatch(let type, let context):
            let keyPath = context.codingPath.map(\.stringValue).joined(separator: ".")
            return "🔄 Type mismatch at '\(keyPath)': Expected '\(type)'. Context: \(context.debugDescription)"
        case .valueNotFound(let type, let context):
            let keyPath = context.codingPath.map(\.stringValue).joined(separator: ".")
            return "🚫 Expected '\(type)' but found nil at '\(keyPath)'. Context: \(context.debugDescription)"
        case .dataCorrupted(let context):
            return "⚠️ Data corrupted: \(context.debugDescription)"
        @unknown default:
            return "❓ Unknown decoding error."
        }
    }
}
