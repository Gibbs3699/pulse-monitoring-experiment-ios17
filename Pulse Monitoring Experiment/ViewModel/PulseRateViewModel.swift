//
//  PulseRateViewModel.swift
//  Pulse Monitoring Experiment
//
//  Created by TheGIZzz on 7/10/2566 BE.
//

import Foundation
import SwiftUI
import Combine

struct HeartRateData {
    let time: Date
    let rate: Int
}

class MockHeartRateDataSource: ObservableObject { // Conform to ObservableObject
    var timer: Timer?
    
    @Published var dataPoints: [HeartRateData] = [] {
        didSet {
            // Keep only the latest 100 data points
            if dataPoints.count > 30 {
                dataPoints.removeFirst(dataPoints.count - 30)
                print(dataPoints.count)
            }
        }
    }
    
    init() {
        // Generate random mock data points every 0.1 seconds
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            let randomRate = Int.random(in: 60...170)
            self.dataPoints.append(HeartRateData(time: Date(), rate: randomRate))
        }
    }
}
