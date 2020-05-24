//
//  AddStopPointView.swift
//  Arrivals Board
//
//  Created by Simon Goldring on 5/23/20.
//  Copyright © 2020 Simon Goldring. All rights reserved.
//

import SwiftUI

struct AddStopPointView: View {
    @ObservedObject var contentViewModel: ContentViewModel
    
    var body: some View {
        List {
            Section() {
                TextField("Station", text: $contentViewModel.addStopPointTextField)
            }
            Section {
                ForEach(contentViewModel.addStopPointStationList) { item in
                    Text(item.name)
                }
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle("Add Station", displayMode: .inline)
    }
}

struct AddStopPointView_Previews: PreviewProvider {
    static var previews: some View {
        AddStopPointView(contentViewModel: ContentViewModel())
    }
}
