// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let leaderBoardModel = try? JSONDecoder().decode(LeaderBoardModel.self, from: jsonData)

import Foundation

// MARK: - LeaderBoardModel
struct LeaderBoardModel: Codable {
    let msg: String
    let categoryLeaderboard: [CategoryLeaderboard]
}

// MARK: - CategoryLeaderboard
struct CategoryLeaderboard: Codable {
    let doctorName, state: String?
    let score: Int?
}
