//
//  PreviewProvider.swift
//  Pulse Monitoring Experiment
//
//  Created by TheGIZzz on 8/10/2566 BE.
//

import Foundation
import SwiftUI

extension PreviewProvider {
    
    static var dev: DeveloperPreview {
        return DeveloperPreview.instance
    }
    
}

class DeveloperPreview {
    static let instance = DeveloperPreview()
    
    let mockDataPoints: [HeartRateData] = [
        HeartRateData(time: Date(), rate: 60),
        HeartRateData(time: Date(), rate: 65),
        HeartRateData(time: Date(), rate: 62),
        HeartRateData(time: Date(), rate: 68),
        HeartRateData(time: Date(), rate: 60),
        HeartRateData(time: Date(), rate: 65),
        HeartRateData(time: Date(), rate: 62),
        HeartRateData(time: Date(), rate: 68),
        HeartRateData(time: Date(), rate: 60),
        HeartRateData(time: Date(), rate: 65),
        HeartRateData(time: Date(), rate: 62),
        HeartRateData(time: Date(), rate: 68),        
        HeartRateData(time: Date(), rate: 60),
        HeartRateData(time: Date(), rate: 65),
        HeartRateData(time: Date(), rate: 62),
        HeartRateData(time: Date(), rate: 68),        
        HeartRateData(time: Date(), rate: 60),
        HeartRateData(time: Date(), rate: 65),
        HeartRateData(time: Date(), rate: 62),
        HeartRateData(time: Date(), rate: 68),        
        HeartRateData(time: Date(), rate: 60),
        HeartRateData(time: Date(), rate: 65),
        HeartRateData(time: Date(), rate: 62),
        HeartRateData(time: Date(), rate: 68),
        // ... add more mock data as needed
    ]
    
}
