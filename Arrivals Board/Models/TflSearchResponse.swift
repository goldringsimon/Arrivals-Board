//
//  TflStopPoint.swift
//  Arrivals Board
//
//  Created by Simon Goldring on 5/24/20.
//  Copyright © 2020 Simon Goldring. All rights reserved.
//

import Foundation

struct TflSearchResponse: Codable {
    let query: String
    let total: Int
    let matches: [TflMatchedStop]
}

struct TflMatchedStop: Codable {
    let icsId: String
    let modes: [String]
    let zone: String
    let id: String
    let name: String
    let lat: Double
    let lon: Double
}
