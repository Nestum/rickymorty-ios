//
//  Characters.swift
//  Created by Marco Castanheira on 30/01/2022.
//

struct Characters: Codable, Equatable {
    let info: Info
    let characterArray: [Character]   // rename this
}

extension Characters {
    private enum CodingKeys: String, CodingKey {
        case info
        case characterArray = "results"
    }
}
