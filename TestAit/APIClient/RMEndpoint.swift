//
//  RMEndpoint.swift
//  TestAit
//
//  Created by PEDRO MENDEZ on 14/07/25.
//

import Foundation

//Represents unique API endpoint

@frozen enum RMEndpoint: String, CaseIterable, Hashable {
    
    // Endpoint to get character info
    case character
    //Endpoint to get location info
    case location
    
    //Endopint to get espisode info
    case episode
}
