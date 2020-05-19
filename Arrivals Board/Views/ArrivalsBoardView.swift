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
    
    var body: some View {
        VStack {
            Text(model.stopName)
                .font(.headline)
                .padding(.top, 5.0)
            VStack{
                ForEach(model.arrivals) { arrival in
                    HStack{
                        Text(arrival.destination)
                        Spacer()
                        Text(arrival.timeRemainingText)
                    }
                }
            }
            .padding([.leading, .bottom, .trailing], 10.0)
        }
        .frame(width: 340.0)
            //.padding(20)
            .background(Color.gray)
            .cornerRadius(20)
            .shadow(radius: 20)
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
