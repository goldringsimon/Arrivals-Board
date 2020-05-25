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
    @State private var isShowingOptions = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(model.stopName)
                .font(.headline)
                .padding([.leading, .top], 10.0)
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
            
            /*if (isExpanded) {
                Text("More info")
            }*/
        }
        .frame(width: 340.0)
            //.padding(20)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 20)
            .offset(x: isShowingOptions ? -100 : 0)
            .gesture(
                ExclusiveGesture(TapGesture()
                    .onEnded({ gesture in
                        withAnimation(.easeInOut(duration: 0.2)) {
                            self.isExpanded.toggle()
                        }
                    }), DragGesture()
                        .onEnded({ gesture in
                            if self.isShowingOptions {
                                if gesture.translation.width > 50 {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        self.isShowingOptions.toggle()
                                    }
                                }
                            } else {
                                if gesture.translation.width < -50 {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        self.isShowingOptions.toggle()
                                    }
                                }
                            }
                        })))
    }
}

struct ArrivalBoardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(ArrivalsBoardViewModel.testData) { arrivalBoard in
                ArrivalsBoardView(model: arrivalBoard)
                .padding()
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
