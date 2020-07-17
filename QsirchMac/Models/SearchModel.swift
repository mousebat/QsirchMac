//
//  SearchModel.swift
//  QsirchMac
//
//  Created by Elliot Cater on 17/07/2020.
//  Copyright © 2020 Caters. All rights reserved.
//

import Foundation

// MARK: - SearchReturn
struct SearchReturn: Codable {
    var items: [SearchItem]
    var total: Int

    init(items: [SearchItem], total: Int) {
        self.items = items
        self.total = total
    }
}
// MARK: - SearchItem
struct SearchItem: Codable, Identifiable {
    var id: String
    var size: Int
    var content: String?
    var path, name: String
    var itemExtension: String?
    var created, modified: String

    enum CodingKeys: String, CodingKey {
        case id, size, content, path, name
        case itemExtension = "extension"
        case created, modified
    }

    init(id: String, size: Int, content: String?, path: String, name: String, itemExtension: String?, created: String, modified: String) {
        self.id = id
        self.size = size
        self.content = content
        self.path = path
        self.name = name
        self.itemExtension = itemExtension
        self.created = created
        self.modified = modified
    }
}
