

import Foundation
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let categoriesWithQuestions = try? JSONDecoder().decode(CategoriesWithQuestions.self, from: jsonData)

import Foundation

// MARK: - CategoriesWithQuestions
struct CategoriesWithQuestions: Codable {
    let formattedCategories: [FormattedCategory]
    let multipleQuestions: [QuizModelElement]
    let onlyFourActiveQuestions: [[QuizModelElement]]
    let onlyActiveCategories: [OnlyActiveCategory]

    enum CodingKeys: String, CodingKey {
        case formattedCategories
        case multipleQuestions = "MultipleQuestions"
        case onlyFourActiveQuestions = "onlyFourActiveQuestions"
        case onlyActiveCategories = "OnlyActiveCategories"
    }
}

// MARK: - FormattedCategory
struct FormattedCategory: Codable {
    let categoryName: String
    let isPlayed: Bool
    let totalPoints: Int

    enum CodingKeys: String, CodingKey {
        case categoryName, isPlayed
        case totalPoints = "TotalPoints"
    }
}

//// MARK: - Question
//struct Question: Codable {
//    let id, question, category: String
//    let answerOptions: [AnswerOption]
//    let v: Int?
//    let level: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id = "_id"
//        case question, category, answerOptions
//        case v = "__v"
//        case level
//    }
//}

// MARK: - OnlyActiveCategory
struct OnlyActiveCategory: Codable {
    let id, name, description: String
    let isActive: Bool
    let v: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, description, isActive
        case v = "__v"
    }
}

enum VUnion: Codable {
    case integer(Int)
    case vClass(VClass)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(VClass.self) {
            self = .vClass(x)
            return
        }
        throw DecodingError.typeMismatch(VUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for VUnion"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .vClass(let x):
            try container.encode(x)
        }
    }
}

// MARK: - VClass
struct VClass: Codable {
    let numberInt: String
}
