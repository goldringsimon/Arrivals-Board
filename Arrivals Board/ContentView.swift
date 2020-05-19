//
//  ContentView.swift
//  Arrivals Board
//
//  Created by Simon Goldring on 5/20/20.
//  Copyright © 2020 Simon Goldring. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            ForEach(ArrivalsBoardViewModel.testData) { arrivalBoard in
                ArrivalsBoardView(model: arrivalBoard)
                .padding()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
