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
    func fetchStopPoints(searchText: String) -> AnyPublisher<TflSearchResponse, TflError>
}

class TestPredictionFetcher: TflPredictionFetchable {
    private let decoder: JSONDecoder
    
    init () {
        decoder = JSONDecoder()
    }
    
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
        
        return Just(jsonData)
            .decode(type: [TflPrediction].self, decoder: decoder)
            .mapError { error in
                .parsing(description: error.localizedDescription)
        }
        .eraseToAnyPublisher()
    }
    
    func fetchStopPoints(searchText: String) -> AnyPublisher<TflSearchResponse, TflError> {
        guard let bundlePath = Bundle.main.path(forResource: "testSearch\(searchText)", ofType: "json") else {
            fatalError("Couldn't open test search data")
        }
        
        var jsonData : Data
        do {
            jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8)!
        } catch {
            fatalError(error.localizedDescription)
        }
        
        return Just(jsonData)
            .decode(type: TflSearchResponse.self, decoder: decoder)
            .mapError { error in
                .parsing(description: error.localizedDescription)
        }
        .eraseToAnyPublisher()
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
        
        return fetch(url: url)
    }
    
    func fetchStopPoints(searchText: String) -> AnyPublisher<TflSearchResponse, TflError> {
        guard let url = URL(string: "https://api.tfl.gov.uk/Stoppoint/Search/\(searchText)?modes=tube&includeHubs=false") else {
          let error = TflError.network(description: "Couldn't create URL")
          return Fail(error: error).eraseToAnyPublisher()
        }
        
        return fetch(url: url)
    }
    
    private func fetch<T: Decodable>(url: URL) -> AnyPublisher<T, TflError> {
        return session.dataTaskPublisher(for: URLRequest(url: url))
            //.subscribe(on: DispatchQueue.global()) // Not sure if this line is doing the right thing / anything so far.
            // Maybe thread switching should not be done by fetcher but by the caller? (currently in view model)
            .mapError { error in
                TflError.network(description: error.localizedDescription)
        }
        .map {
            $0.data
        }
        .decode(type: T.self, decoder: decoder)
        .mapError { error in
            .parsing(description: error.localizedDescription)
        }
        .eraseToAnyPublisher()
    }
}

/*
extension TflPredictionFetcher {
    func fetchArrivalsOld(stopPointId: String) -> AnyPublisher<[TflPrediction], TflError> {
        guard let url = URL(string: "https://api.tfl.gov.uk/Stoppoint/\(stopPointId)/Arrivals") else {
          let error = TflError.network(description: "Couldn't create URL")
          return Fail(error: error).eraseToAnyPublisher()
        }
        
        /*.flatMap(maxPublishers: .max(1)) { pair in
          decode(pair.data)
        }*/
        
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
    
    func fetchStopPointsOld(searchText: String) -> AnyPublisher<TflSearchResponse, TflError> {
        guard let url = URL(string: "https://api.tfl.gov.uk/Stoppoint/Search/\(searchText)?modes=tube&includeHubs=false") else {
          let error = TflError.network(description: "Couldn't create URL")
          return Fail(error: error).eraseToAnyPublisher()
        }
        
        /*.flatMap(maxPublishers: .max(1)) { pair in
          decode(pair.data)
        }*/
        
        return session.dataTaskPublisher(for: URLRequest(url: url))
            //.subscribe(on: DispatchQueue.global()) // Not sure if this line is doing the right thing / anything so far.
            // Maybe thread switching should not be done by fetcher but by the caller? (currently in view model)
            .mapError { error in
                TflError.network(description: error.localizedDescription)
        }
        .map {
            $0.data
        }
        .decode(type: TflSearchResponse.self, decoder: decoder)
        .mapError { error in
            .parsing(description: error.localizedDescription)
        }
        .eraseToAnyPublisher()
    }
}
*/
