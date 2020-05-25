//
//  ContentView.swift
//  Arrivals Board
//
//  Created by Simon Goldring on 5/20/20.
//  Copyright © 2020 Simon Goldring. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var arrivalsManager: ArrivalsManager
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: AddStopPointView(arrivalsManager: arrivalsManager), isActive: $arrivalsManager.isShowingAddStopPointView, label: { EmptyView() })
                ScrollView {
                    ForEach(arrivalsManager.arrivalsBoards) { arrivalBoard in
                        ArrivalsBoardView(model: arrivalBoard)
//                            .onLongPressGesture {
//                                self.arrivalsManager.removeBoard(stopPointId: arrivalBoard.id)
//                        }
                        .padding()
                    }
                }
            }
        .navigationBarTitle("Arrivals")
        .navigationBarItems(trailing: addStopPointButton)
        }
    }
    
    private var addStopPointButton: some View {
        Button(action: {
            self.arrivalsManager.isShowingAddStopPointView = true
        }, label: {
            Image(systemName: "plus.circle")
                .renderingMode(.original)
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(arrivalsManager: ArrivalsManager())
    }
}

