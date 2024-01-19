//
//  SelectDoctorModel.swift
//  somprazApp
//
//  Created by digiLATERAL on 18/10/23.
//

import Foundation
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let selectDoctorModel = try? JSONDecoder().decode(SelectDoctorModel.self, from: jsonData)


// MARK: - SelectDoctorModelElement
struct SelectDoctorModelElement: Codable {
    let id: String
    let doctorName: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case doctorName
    }
}

typealias SelectDoctorModel = [SelectDoctorModelElement]
