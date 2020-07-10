//
//  PreferencesModel.swift
//  QsirchMac
//
//  Created by Elliot Cater on 09/07/2020.
//  Copyright © 2020 Caters. All rights reserved.
//

import Foundation

// MARK: - LoginRequest
struct LoginRequest : Codable {
    var account = String()
    var password = String()
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
// MARK: - Search Results
struct SearchResults: Codable {
    var items: [Item]
    var total: Int
}

// MARK: - Items from Search Results
struct Item: Codable {
    var size: Int
    var path, name, itemExtension, created: String
    var modified: String

    enum CodingKeys: String, CodingKey {
        case size, path, name
        case itemExtension = "extension"
        case created, modified
    }
}
// MARK: - Store User Settings in EnvironmentObject
class UserSettings: ObservableObject {
    @Published var hostname:String = UserDefaults.standard.string(forKey: "hostname") ?? ""
    @Published var username:String = UserDefaults.standard.string(forKey: "username") ?? ""
    @Published var password:String = UserDefaults.standard.string(forKey: "password") ?? ""
    @Published var port:String = UserDefaults.standard.string(forKey: "port") ?? ""
    @Published var token:String = UserDefaults.standard.string(forKey: "token") ?? ""
}




