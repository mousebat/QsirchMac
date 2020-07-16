// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let driveListReturn = try DriveListReturn(json)

import Foundation

// MARK: - DriveListReturn
class DriveListReturn: Codable {
    var items: [Drive]
    var total: Int

    init(items: [Drive], total: Int) {
        self.items = items
        self.total = total
    }
}

// MARK: DriveListReturn convenience initializers and mutators

extension DriveListReturn {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(DriveListReturn.self, from: data)
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
        items: [Drive]? = nil,
        total: Int? = nil
    ) -> DriveListReturn {
        return DriveListReturn(
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

// MARK: - Drive
class Drive: Codable {
    var name: String

    init(name: String) {
        self.name = name
    }
}

// MARK: Drive convenience initializers and mutators

extension Drive {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Drive.self, from: data)
        self.init(name: me.name)
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
        name: String? = nil
    ) -> Drive {
        return Drive(
            name: name ?? self.name
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
