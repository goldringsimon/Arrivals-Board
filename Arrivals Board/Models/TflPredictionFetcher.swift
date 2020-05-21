//
//  TflPredictionFetcher.swift
//  Arrivals Board
//
//  Created by Simon Goldring on 5/20/20.
//  Copyright © 2020 Simon Goldring. All rights reserved.
//

import Foundation
import Combine

enum TflError: Error {
  case parsing(description: String)
  case network(description: String)
}

protocol TflPredictionFetchable {
    func fetchArrivals(stopPointId: String) -> AnyPublisher<[TflPrediction], TflError>
}

class TestPredictionFetcher: TflPredictionFetchable {
    private let arsenalData: [TflPrediction]
    private let decoder: JSONDecoder
    
    func fetchArrivals(stopPointId: String) -> AnyPublisher<[TflPrediction], TflError> {
        return Just(arsenalData)
            .mapError { error in
                .parsing(description: error.localizedDescription)
        }
        .eraseToAnyPublisher()
        /*guard let bundlePath = Bundle.main.path(forResource: "testDataArsenal", ofType: "json") else {
            fatalError("Couldn't open Arsenal test data")
        }
        return URLSession.shared.dataTaskPublisher(for: bundlePath)
        .mapError { $0 as Error }
        .map { $0.data }
        .decode(type: [TflPrediction].self, decoder: JSONDecoder())
        .eraseToAnyPublisher()*/
    }
    
    init () {
        guard let bundlePath = Bundle.main.path(forResource: "testData940GZZLUASL", ofType: "json") else {
            fatalError("Couldn't open Arsenal test data")
        }
        
        var jsonData : Data
        do {
            jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8)!
        } catch {
            fatalError(error.localizedDescription)
        }
        
        decoder = JSONDecoder()
        do {
            try arsenalData = decoder.decode([TflPrediction].self, from: jsonData)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
/*
class TflPredictionFetcher: TflPredictionFetchable {
    func fetchLineStatus(stopPointId: String) -> AnyPublisher<[TflPrediction], TflError> {
        guard let url = URL(string: "https://api.tfl.gov.uk/Stoppoint/arrivals/\(stopPointId)") else {
          let error = TflError.network(description: "Couldn't create URL")
          return Fail(error: error).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: URLRequest(url: url))
          .mapError { error in
            .network(description: error.localizedDescription)
          }
          .flatMap(maxPublishers: .max(1)) { pair in
            decode(pair.data)
          }
          .eraseToAnyPublisher()
    }
}*/
