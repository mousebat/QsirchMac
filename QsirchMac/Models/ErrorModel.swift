//
//  ErrorModel.swift
//  QsirchMac
//
//  Created by Elliot Cater on 17/07/2020.
//  Copyright © 2020 Caters. All rights reserved.
//

import Foundation

// MARK: - ErrorReturn
struct ErrorReturn: Codable {
    var error: Errors

    init(error: Errors) {
        self.error = error
    }
}
// MARK: - Errors
struct Errors: Codable {
    var message: String
    var code: Int

    init(message: String, code: Int) {
        self.message = message
        self.code = code
    }
}
