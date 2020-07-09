//
//  PreferencesModel.swift
//  QsirchMac
//
//  Created by Elliot Cater on 09/07/2020.
//  Copyright © 2020 Caters. All rights reserved.
//

import Foundation

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
struct LoginError: Codable {
    let error: LError
}

// MARK: - Error
struct LError: Codable {
    let message: String
    let code: Int
}
// MARK: - Search Results
struct SearchResults: Codable {
    var items: [Item]
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



class UserSettings: ObservableObject {
    @Published var hostname:String?
    @Published var username:String?
    @Published var password:String?
    @Published var port:String?
}


