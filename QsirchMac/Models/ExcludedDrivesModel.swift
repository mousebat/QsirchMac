//
//  ExcludedDrivesModel.swift
//  QsirchMac
//
//  Created by Elliot Cater on 31/07/2020.
//  Copyright © 2020 Caters. All rights reserved.
//

import Foundation

// MARK: - ExcludedReturn
class ExcludedReturn: Codable {
    var items: [Item]

    init(items: [Item]) {
        self.items = items
    }
}

// MARK: - Item
class Item: Codable {
    var path: String

    init(path: String) {
        self.path = path
    }
}
