// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let searchReturn = try SearchReturn(json)

import Foundation

// MARK: - SearchReturn
class SearchReturn: Codable {
    var items: [SearchItem]
    var total: Int

    init(items: [SearchItem], total: Int) {
        self.items = items
        self.total = total
    }
}

// MARK: SearchReturn convenience initializers and mutators

extension SearchReturn {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(SearchReturn.self, from: data)
        self.init(items: me.items, total: me.total)
    }

    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    convenience init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        items: [SearchItem]? = nil,
        total: Int? = nil
    ) -> SearchReturn {
        return SearchReturn(
            items: items ?? self.items,
            total: total ?? self.total
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - SearchItem
class SearchItem: Codable {
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

// MARK: SearchItem convenience initializers and mutators

extension SearchItem {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(SearchItem.self, from: data)
        self.init(id: me.id, size: me.size, content: me.content, path: me.path, name: me.name, itemExtension: me.itemExtension, created: me.created, modified: me.modified)
    }

    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    convenience init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        id: String? = nil,
        size: Int? = nil,
        content: String?? = nil,
        path: String? = nil,
        name: String? = nil,
        itemExtension: String?? = nil,
        created: String? = nil,
        modified: String? = nil
    ) -> SearchItem {
        return SearchItem(
            id: id ?? self.id,
            size: size ?? self.size,
            content: content ?? self.content,
            path: path ?? self.path,
            name: name ?? self.name,
            itemExtension: itemExtension ?? self.itemExtension,
            created: created ?? self.created,
            modified: modified ?? self.modified
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}
