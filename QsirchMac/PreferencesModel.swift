//
//  PreferencesModel.swift
//  QsirchMac
//
//  Created by Elliot Cater on 09/07/2020.
//  Copyright © 2020 Caters. All rights reserved.
//

import Foundation
import Combine


// MARK: - LoginRequest
struct LoginRequest : Codable {
    let account: String
    let password: String
}
// MARK: - LoginReturn
struct LoginReturn: Codable {
    let isAdmin, qqsSid, userName: String

    enum CodingKeys: String, CodingKey {
        case isAdmin = "is_admin"
        case qqsSid = "qqs_sid"
        case userName = "user_name"
    }
}
// MARK: - LoginError
struct ReturnedError: Codable {
    let error: Error
}
// MARK: - Error
struct Error: Codable {
    let message: String
    let code: Int
}
// MARK: - SearchResults
struct SearchResults: Codable, Identifiable {
    let id = UUID()
    let items: [Item]
    let total: Int
}

// MARK: - Item
struct Item: Codable, Identifiable {
    let id = UUID()
    let size: Int
    let title: String
    let content: String?
    let path, name: String
    let itemExtension: String?
    let created, modified: String
    
    enum CodingKeys: String, CodingKey {
        case id, size, title, content, path, name
        case itemExtension = "extension"
        case created, modified
    }
}
// MARK: - DrivesAvailable
struct DrivesAvailable: Codable {
    var items: [Drives]
    var total: Int
}
// MARK: - Drives
struct Drives: Codable {
    var name: String
}

// MARK: - Store User Settings in EnvironmentObject
class UserSettings: ObservableObject {
    @Published var hostname:String = UserDefaults.standard.string(forKey: "hostname") ?? ""
    @Published var username:String = UserDefaults.standard.string(forKey: "username") ?? ""
    @Published var password:String = UserDefaults.standard.string(forKey: "password") ?? ""
    @Published var port:String = UserDefaults.standard.string(forKey: "port") ?? ""
    @Published var token:String = ""
}
