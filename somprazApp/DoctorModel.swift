//
//  DoctorModel.swift
//  somprazApp
//
//  Created by digiLATERAL on 17/10/23.
//

import Foundation


struct DoctorModelElement: Codable {
    let category: String
    let isPlayed: Bool
    let totalPoints: Int?
//    let mrid: String? // Add this line for the "MRID" field

    enum CodingKeys: String, CodingKey {
        case category, isPlayed
        case totalPoints = "TotalPoints"
//        case mrid = "MRID"
    }
}

typealias DoctorModel = [DoctorModelElement]


// MARK: - DoctorInsert
struct DoctorInsert: Codable {
    let message, id: String

    enum CodingKeys: String, CodingKey {
        case message
        case id = "Id"
    }
}

struct syncDict: Codable {
    
    let totalPoints : Int
    let categoryName : String
    let userId : String
    let date: Date 
}

typealias syncModel = [syncDict]


//RESPONSE
//
//
//[{"category":"Entertainment","isPlayed":false},
//{"category" :"Astronomy","isPlayed":true,"TotalPoints":10},
//{"category" :"History","isPlayed":true,"TotalPoints":10},
//{"category" :"Science","isPlayed":true,"TotalPoints":10},
//{"category" :"Literature","isPlayed":true,"TotalPoints":10},
//{"category" :"Geography","isPlayed":true,"TotalPoints":20},
//{"category" :"Wildlife","isPlayed":true,"TotalPoints":10},
//{"category" :"Technology","isPlayed":true,"TotalPoints":20},
//{"category" :"Mathematics","isPlayed":true,"TotalPoints":30}]
