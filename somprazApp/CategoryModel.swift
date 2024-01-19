// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let categoryModel = try? JSONDecoder().decode(CategoryModel.self, from: jsonData)

import Foundation

// MARK: - CategoryModelElement
struct CategoryModelElement: Codable {
    let category: String
    let isPlayed: Bool
    let totalPoints: Int

    enum CodingKeys: String, CodingKey {
        case category, isPlayed
        case totalPoints = "TotalPoints"
    }
}

typealias CategoryModel = [CategoryModelElement]
