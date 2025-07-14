//
//  RMGetAllCharactersResponse.swift
//  TestAit
//
//  Created by PEDRO MENDEZ on 14/07/25.
//

import Foundation

struct RMGetAllCharactersResponse: Codable {
    struct Info: Codable {
        let count : Int
        let pages: Int
        let next: String?
        let prev: String?
    }
    let info: Info
    let results: [RMCharacter]
    
}

