//
//  submitPWModel.swift
//  somprazApp
//
//  Created by digiLATERAL on 19/12/23.
//

import Foundation
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let submitPWModel = try? JSONDecoder().decode(SubmitPWModel.self, from: jsonData)



// MARK: - SubmitPWModel
struct SubmitPWModel: Codable {
       let success: Bool?
       let mrMail: String?
       let msg: String
}
