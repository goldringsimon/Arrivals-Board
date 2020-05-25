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

class ArrivalsManager : ObservableObject {
    @Published var arrivalsBoards: [ArrivalsBoardViewModel]
    @Published var addStopPointTextField = ""
    @Published var addStopPointStationList: [MatchedStopViewModel] = []
    @Published var isShowingAddStopPointView = false
    
    private var fetcher: TflPredictionFetchable
    private var disposables = Set<AnyCancellable>()
    private var pipelines = [String: AnyCancellable]()
    
    init() {
        fetcher = TflPredictionFetcher()
        arrivalsBoards = [ArrivalsBoardViewModel]()
        addBoard(stopPointId: "940GZZLUASL")
        addBoard(stopPointId: "940GZZLUKSX")
        
        $addStopPointTextField
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .sink {
                self.fetchStopPoints(searchText: $0)
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
    
    func isAlreadyDisplayed(stopPointId: String) -> Bool {
        return pipelines[stopPointId] != nil
    }
    
    func addBoard(stopPointId: String) {
        fetchArrivals(stopPointId: stopPointId)
    }
    
    func removeBoard(stopPointId: String) {
        //pipelines[stopPointId]?.cancel() // Do we need to cancel? Won't deinit be called by removing dictionary, triggering cancel?
        pipelines.removeValue(forKey: stopPointId)
        for (i,board) in arrivalsBoards.enumerated() {
            if board.id == stopPointId {
                arrivalsBoards.remove(at: i)
                break
            }
        }
    }
    
    private func fetchArrivals(stopPointId : String) {
        pipelines[stopPointId] = fetcher.fetchArrivals(stopPointId: stopPointId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] value in
                guard let self = self else { return }
                switch value {
                case .failure:
                    break
                case .finished:
                    break
                }
                },
                  receiveValue: { [weak self] response in
                    guard let self = self else { return }
                    if let newBoard = ArrivalsBoardViewModel(for: response) {
                        self.arrivalsBoards.append(newBoard)
                    } else {
                        print("Couldn't create ArrivalsBoardViewModel")
                        print(response)
                    }
            })
            //.store(in: &disposables)
    }
}
