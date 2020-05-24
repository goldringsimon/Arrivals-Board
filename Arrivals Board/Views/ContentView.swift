//
//  ContentView.swift
//  Arrivals Board
//
//  Created by Simon Goldring on 5/20/20.
//  Copyright © 2020 Simon Goldring. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var model: ContentViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(model.arrivalsBoards) { arrivalBoard in
                    ArrivalsBoardView(model: arrivalBoard)
                    .padding()
                }
                Button(action: {
                    self.model.addBoard(stopPointId: "940GZZLUASL")
                }, label: {
                    Text("Add example stopPoint")
                })
            }
        .navigationBarTitle("Arrivals")
        .navigationBarItems(trailing: addStopPointButton)
        }
    }
    
    private var addStopPointButton: some View {
        NavigationLink(destination: AddStopPointView(contentViewModel: model)) {
            Text("Add")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(model: ContentViewModel())
    }
}

