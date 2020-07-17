//
//  LoginModel.swift
//  QsirchMac
//
//  Created by Elliot Cater on 17/07/2020.
//  Copyright © 2020 Caters. All rights reserved.
//

import Foundation

// MARK: - LoginRequest
struct LoginRequest : Codable {
    let account: String
    let password: String
}
// MARK: - LoginReturn
struct LoginReturn: Codable {
    var isAdmin, qqsSid, userName: String

    enum CodingKeys: String, CodingKey {
        case isAdmin = "is_admin"
        case qqsSid = "qqs_sid"
        case userName = "user_name"
    }

    init(isAdmin: String, qqsSid: String, userName: String) {
        self.isAdmin = isAdmin
        self.qqsSid = qqsSid
        self.userName = userName
    }
}
