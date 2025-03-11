// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

open class UserInfo: @unchecked Sendable {
    var name: String
    init(name: String) {
        self.name = name
    }
}

actor SwiftDataRaceManager {
    var userInfo: UserInfo = .init(name: "")
    func updateDatabase(_ userInfo: UserInfo) async throws {
        self.userInfo = userInfo
    }
}

