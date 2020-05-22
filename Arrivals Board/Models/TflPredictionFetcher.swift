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
    //private let arsenalData: [TflPrediction]
    private let decoder: JSONDecoder
    
    func fetchArrivals(stopPointId: String) -> AnyPublisher<[TflPrediction], TflError> {
        guard let bundlePath = Bundle.main.path(forResource: "testData\(stopPointId)", ofType: "json") else {
            fatalError("Couldn't open Arsenal test data")
        }
        
        var jsonData : Data
        do {
            jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8)!
        } catch {
            fatalError(error.localizedDescription)
        }
        //return jsonData.publisher
        return Just(jsonData)
            .decode(type: [TflPrediction].self, decoder: decoder)
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
        decoder = JSONDecoder()
    }
}

class TflPredictionFetcher: TflPredictionFetchable {
    private let decoder = JSONDecoder()
    private let session: URLSession = .shared
    
    func fetchArrivals(stopPointId: String) -> AnyPublisher<[TflPrediction], TflError> {
        
        guard let url = URL(string: "https://api.tfl.gov.uk/Stoppoint/\(stopPointId)/Arrivals") else {
          let error = TflError.network(description: "Couldn't create URL")
          return Fail(error: error).eraseToAnyPublisher()
        }
        
        /*.flatMap(maxPublishers: .max(1)) { pair in
          decode(pair.data)
        }*/
        
        sleep(5)
        
        return session.dataTaskPublisher(for: URLRequest(url: url))
            //.subscribe(on: DispatchQueue.global()) // Not sure if this line is doing the right thing / anything so far.
            // Maybe thread switching should not be done by fetcher but by the caller? (currently in view model)
            .mapError { error in
                TflError.network(description: error.localizedDescription)
        }
        .map {
            $0.data
        }
        .decode(type: [TflPrediction].self, decoder: decoder)
        .mapError { error in
            .parsing(description: error.localizedDescription)
        }
        .eraseToAnyPublisher()
    }
}
