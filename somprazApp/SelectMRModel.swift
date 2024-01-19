//
//  SelectMRModel.swift
//  somprazApp
//
//  Created by digiLATERAL on 30/11/23.
//

import Foundation

// MARK: - SelectMRModel
struct SelectMRModel: Codable {
    let success: Bool
    let mrId: String
    let MRID: String
    let PASSWORD: String?

    private enum CodingKeys: String, CodingKey {
        case success
        case mrId
        case MRID
        case PASSWORD
    }
}
