//
//  DriveListModel.swift
//  QsirchMac
//
//  Created by Elliot Cater on 17/07/2020.
//  Copyright © 2020 Caters. All rights reserved.
//

import Foundation

// MARK: - DriveListReturn
struct DriveListReturn: Codable {
    var items: [Drive]
    var total: Int

    init(items: [Drive], total: Int) {
        self.items = items
        self.total = total
    }
}
// MARK: - Drive
struct Drive: Codable, Identifiable {
    var id = UUID()
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case name
    }

    init(name: String) {
        self.name = name
    }
}
