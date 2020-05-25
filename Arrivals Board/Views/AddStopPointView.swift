//
//  AddStopPointView.swift
//  Arrivals Board
//
//  Created by Simon Goldring on 5/23/20.
//  Copyright © 2020 Simon Goldring. All rights reserved.
//

import SwiftUI

struct AddStopPointView: View {
    @ObservedObject var arrivalsManager: ArrivalsManager
    
    var body: some View {
        List {
            Section() {
                TextField("Station", text: $arrivalsManager.addStopPointTextField)
            }
            Section {
                ForEach(arrivalsManager.addStopPointStationList) { model in
                    Button(action: {
                        self.arrivalsManager.isShowingAddStopPointView = false
                        self.arrivalsManager.addBoard(stopPointId: model.id)
                    }, label: {
                        MatchedStopRowView(model: model, isAlreadySelected: self.arrivalsManager.isAlreadyDisplayed(stopPointId: model.id))
                    })
                }
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle("Add Station", displayMode: .inline)
    }
}

struct AddStopPointView_Previews: PreviewProvider {
    static var previews: some View {
        AddStopPointView(arrivalsManager: ArrivalsManager())
    }
}
