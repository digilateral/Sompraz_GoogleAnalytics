// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let addDocModel = try? JSONDecoder().decode(AddDocModel.self, from: jsonData)

import Foundation

// MARK: - AddDocModel
struct AddDocModel: Codable {
    let message, id: String

    enum CodingKeys: String, CodingKey {
        case message
        case id = "Id"
    }
}
