//
//  ContentViewModel.swift
//  Arrivals Board
//
//  Created by Simon Goldring on 5/21/20.
//  Copyright © 2020 Simon Goldring. All rights reserved.
//

import Foundation
import Combine

class ContentViewModel : ObservableObject {
    @Published var arrivalsBoards: [ArrivalsBoardViewModel] = []
    
    private var fetcher: TflPredictionFetchable
    private var disposables = Set<AnyCancellable>()
    
    init() {
        fetcher = TflPredictionFetcher()
        arrivalsBoards = ArrivalsBoardViewModel.testData
    }
    
    func addBoard(stopPointId : String) {
        let board = ArrivalsBoardViewModel(stopName: "New stop", arrivals: [ArrivalsBoardViewModel.testArrival2, ArrivalsBoardViewModel.testArrival3])
        arrivalsBoards.append(board)
    }
    
    func fetchLineStatus(stopPointId : String) {
        fetcher.fetchArrivals(stopPointId: stopPointId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] value in
                guard let self = self else { return }
                switch value {
                case .failure:
                    //self.dataSource = []
                    //self.lineViewModels = []
                    break
                case .finished:
                    break
                }
                },
                  receiveValue: { [weak self] response in
                    guard let self = self else { return }
                    if let newBoard = ArrivalsBoardViewModel(for: response) {
                        self.arrivalsBoards.append(newBoard)
                    }
            })
            .store(in: &disposables)
    }
}
