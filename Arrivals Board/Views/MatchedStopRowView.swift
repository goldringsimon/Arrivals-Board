//
//  MatchedStopPointRowView.swift
//  Arrivals Board
//
//  Created by Simon Goldring on 5/24/20.
//  Copyright © 2020 Simon Goldring. All rights reserved.
//

import SwiftUI

struct MatchedStopRowView: View {
    let model: MatchedStopViewModel
    let isAlreadySelected: Bool
    
    var body: some View {
        Text(model.name)
            .foregroundColor(isAlreadySelected ? Color.gray : Color.black) // This isn't a permanent fix because e.g. dark mode. Need to get default foreground color without list making it blue
    }
}

struct MatchedStopRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(MatchedStopViewModel.testData) { model in
                MatchedStopRowView(model: model, isAlreadySelected: false)
            }
        }
        .previewLayout(.sizeThatFits)
    }
}
