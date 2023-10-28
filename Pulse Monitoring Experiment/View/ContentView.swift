//
//  ContentView.swift
//  Pulse Monitoring Experiment
//
//  Created by TheGIZzz on 7/10/2566 BE.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var dataSource = MockHeartRateDataSource()
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Heart Rate")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            HeaderView(dataPoints: dataSource.dataPoints)
                .preferredColorScheme(.dark)

            LineChartView(
                dataPoints: dataSource.dataPoints,
                title: "Heart Rate (bpm)",
                yAxisLabel: "Rate",
                xAxisLabel: "Time"
            )
            .frame(maxHeight: UIScreen.main.bounds.height * 0.5) // Setting max height to half of the screen
            .foregroundColor(.white)
            .padding(.bottom) // Adds padding to the bottom for better positioning
            
            Spacer()
            
            Text("Keep your finger in the same place for accurate results")
                .font(.subheadline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .center)
            
        }
        .padding()  // Adds padding around the entire VStack
        .background(Color(hex: "0A0820")) // Set the background color of the entire view
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgb: UInt64 = 0

        scanner.scanHexInt64(&rgb)

        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue)
    }
}
