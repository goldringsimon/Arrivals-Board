//
//  ArrivalBoardView.swift
//  Arrival Board
//
//  Created by Simon Goldring on 5/19/20.
//  Copyright © 2020 Simon Goldring. All rights reserved.
//

import SwiftUI

struct ArrivalsBoardView: View {
    let model : ArrivalsBoardViewModel
    @State private var isExpanded = false
    
    var body: some View {
        VStack {
            Text(model.stopName)
                .font(.headline)
                .padding(.top, 5.0)
            VStack{
                if (isExpanded) {
                ForEach(model.arrivals) { arrival in
                    ArrivalRow(arrival: arrival)
                }
                } else {
                    ForEach(model.arrivals.prefix(2)) { arrival in
                        ArrivalRow(arrival: arrival)
                    }
                }
            }
            .padding([.leading, .bottom, .trailing], 10.0)
            
            if (isExpanded) {
                Text("More info")
            }
        }
        .frame(width: 340.0)
            //.padding(20)
            .background(Color.gray)
            .cornerRadius(20)
            .shadow(radius: 20)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.2)) {
                self.isExpanded.toggle()
            }
        }
    }
}

struct ArrivalBoardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(ArrivalsBoardViewModel.testData) { arrivalBoard in
                ArrivalsBoardView(model: arrivalBoard)
            }
        }
        .previewLayout(.sizeThatFits)
    }
}

struct ArrivalRow: View {
    let arrival : ArrivalViewModel
    
    var body: some View {
        HStack{
            Text(arrival.destination)
            Spacer()
            Text(arrival.timeRemainingText)
        }
    }
}
