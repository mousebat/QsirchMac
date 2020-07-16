// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let loginReturn = try LoginReturn(json)

import Foundation

// MARK: - LoginReturn
class LoginReturn: Codable {
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

// MARK: LoginReturn convenience initializers and mutators

extension LoginReturn {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(LoginReturn.self, from: data)
        self.init(isAdmin: me.isAdmin, qqsSid: me.qqsSid, userName: me.userName)
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
        isAdmin: String? = nil,
        qqsSid: String? = nil,
        userName: String? = nil
    ) -> LoginReturn {
        return LoginReturn(
            isAdmin: isAdmin ?? self.isAdmin,
            qqsSid: qqsSid ?? self.qqsSid,
            userName: userName ?? self.userName
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
