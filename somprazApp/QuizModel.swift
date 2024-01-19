//
//  QuizModel.swift
//  somprazApp
//
//  Created by digiLATERAL on 15/10/23.
//

import Foundation
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let quizModel = try? JSONDecoder().decode(QuizModel.self, from: jsonData)

// MARK: - QuizModelElement

struct QuizModelElement: Codable {
    let id, question: String
    let category: String
    let answerOptions: [AnswerOption]
    let v: VUnion?
    let level: Level?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case question, category, answerOptions
        case v = "__v"
        case level
    }
}

enum Level: String, Codable {
    case easy = "easy"
    case hard = "hard"
    case medium = "medium"
}

// MARK: - AnswerOption
struct AnswerOption: Codable {
    let answer: String
    let isCorrect: Bool
    let id: String

    enum CodingKeys: String, CodingKey {
        case answer, isCorrect
        case id = "_id"
    }
}

enum Category: String, Codable {
    case astronomy = "Astronomy"
    case categoryHistory = "History "
    case entertainment = "Entertainment"
    case geography = "Geography"
    case history = "History"
    case literature = "Literature"
    case science = "Science"
    case wildlife = "Wildlife"
}

typealias QuizModel = [QuizModelElement]
