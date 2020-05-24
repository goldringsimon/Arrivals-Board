//
//  MatchedStopViewModel.swift
//  Arrivals Board
//
//  Created by Simon Goldring on 5/24/20.
//  Copyright © 2020 Simon Goldring. All rights reserved.
//

import Foundation

struct MatchedStopViewModel: Identifiable {
    let id: String
    let name: String
}

extension MatchedStopViewModel {
    init(for matchedStop: TflMatchedStop) {
        self.id = matchedStop.id
        self.name = matchedStop.name
    }
}
