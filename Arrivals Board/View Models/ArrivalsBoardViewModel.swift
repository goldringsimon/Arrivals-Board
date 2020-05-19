//
//  ArrivalBoardViewModel.swift
//  Arrival Board
//
//  Created by Simon Goldring on 5/19/20.
//  Copyright © 2020 Simon Goldring. All rights reserved.
//

import Foundation

struct ArrivalsBoardViewModel : Identifiable {
    let id = UUID()
    let stopName: String
    let arrivals: [ArrivalViewModel]
}

struct ArrivalViewModel : Identifiable {
    let id = UUID()
    let destination: String
    let timeRemaining: Int
    
    var timeRemainingText: String {
        return "\(Int(round(Double(timeRemaining) / 60.0))) mins"
    }
}

extension ArrivalsBoardViewModel {
    static let testArrival1 = ArrivalViewModel(destination: "Morden", timeRemaining: 43)
    static let testArrival2 = ArrivalViewModel(destination: "Battersea Station", timeRemaining: 234)
    static let testArrival3 = ArrivalViewModel(destination: "New Cross Gate", timeRemaining: 472)
    static let testArrivals1 = [testArrival1, testArrival2, testArrival3]
    static let testArrivalBoard1 : ArrivalsBoardViewModel = ArrivalsBoardViewModel(stopName: "Archway Station", arrivals: testArrivals1)
    static let testArrivalBoard2 : ArrivalsBoardViewModel = ArrivalsBoardViewModel(stopName: "King's Cross St Pancras", arrivals: testArrivals1)
    static let testData = [testArrivalBoard1, testArrivalBoard2]
}
