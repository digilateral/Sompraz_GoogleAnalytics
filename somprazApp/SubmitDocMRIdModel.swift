// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let submitDocMRID = try? JSONDecoder().decode(SubmitDocMRID.self, from: jsonData)

import Foundation

// MARK: - SubmitDocMRIDElement
struct SubmitDocMRIDElement: Codable {
    let id, doctorName, scCode: String
    let locality: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case doctorName, scCode, locality
    }
}

typealias SubmitDocMRID = [SubmitDocMRIDElement]
