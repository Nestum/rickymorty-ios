//
//  Character.swift
//  Created by Marco Castanheira on 30/01/2022.
//

struct Character: Codable {
    let id: Int
    let name: String
    let status: String // create enum
    let species: String // create enum
    let type: String?
    let gender: String // create enum
    let origin: Location
    let location: Location
    let image: String
    let episode: [String]
    let url: String
    let created: String // convert to date
}
