// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let errorReturn = try ErrorReturn(json)

import Foundation

// MARK: - ErrorReturn
class ErrorReturn: Codable {
    var error: Errors

    init(error: Errors) {
        self.error = error
    }
}

// MARK: ErrorReturn convenience initializers and mutators

extension ErrorReturn {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(ErrorReturn.self, from: data)
        self.init(error: me.error)
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
        error: Errors? = nil
    ) -> ErrorReturn {
        return ErrorReturn(
            error: error ?? self.error
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Errors
class Errors: Codable {
    var message: String
    var code: Int

    init(message: String, code: Int) {
        self.message = message
        self.code = code
    }
}

// MARK: Errors convenience initializers and mutators

extension Errors {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Errors.self, from: data)
        self.init(message: me.message, code: me.code)
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
        message: String? = nil,
        code: Int? = nil
    ) -> Errors {
        return Errors(
            message: message ?? self.message,
            code: code ?? self.code
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
