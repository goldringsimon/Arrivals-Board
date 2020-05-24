//
//  ContentViewModel.swift
//  Arrivals Board
//
//  Created by Simon Goldring on 5/21/20.
//  Copyright © 2020 Simon Goldring. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class ContentViewModel : ObservableObject {
    @Published var arrivalsBoards: [ArrivalsBoardViewModel] = []

    @Published var addStopPointTextField = ""
    @Published var addStopPointStationList: [MatchedStopViewModel] = []
    
    private var fetcher: TflPredictionFetchable
    private var disposables = Set<AnyCancellable>()
    
    init() {
        fetcher = TflPredictionFetcher()
        arrivalsBoards = ArrivalsBoardViewModel.testData
        
        $addStopPointTextField
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .sink {
                self.fetchStopPoints(searchText: $0)
                //self.addStopPointStationList = [$0]
        }
            .store(in: &disposables)
    }
    
    private func fetchStopPoints(searchText: String) {
        fetcher.fetchStopPoints(searchText: searchText)
            .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: {
            [weak self] value in
            guard let self = self else { return }
            switch value {
            case .failure:
                break
            case .finished:
                break
            }
        }, receiveValue: { [weak self] response in
            guard let self = self else { return }
            self.addStopPointStationList = response.matches.map({ matchedStop in
                MatchedStopViewModel(for: matchedStop)
            })
        })
        .store(in: &disposables)
    }
    
    func addBoard(stopPointId : String) {
        //let board = ArrivalsBoardViewModel(stopName: "New stop", arrivals: [ArrivalsBoardViewModel.testArrival2, ArrivalsBoardViewModel.testArrival3])
        //arrivalsBoards.append(board)
        fetchLineStatus(stopPointId: stopPointId)
    }
    
    private func fetchLineStatus(stopPointId : String) {
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
