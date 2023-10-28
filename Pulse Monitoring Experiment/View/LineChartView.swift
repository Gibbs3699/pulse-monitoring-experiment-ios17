//
//  LineChartView.swift
//  Pulse Monitoring Experiment
//
//  Created by TheGIZzz on 8/10/2566 BE.
//

import SwiftUI

struct LineChartView: View {
    let dataPoints: [HeartRateData]
    let title: String
    let yAxisLabel: String
    let xAxisLabel: String
    let yAxisValues = [50, 100, 150, 200]

    @State private var animate = false
    
    var last30SecondsDataPoints: [HeartRateData] {
        guard let lastDate = dataPoints.last?.time else {
            return []
        }
        let cutOffDate = Calendar.current.date(byAdding: .second, value: -30, to: lastDate)!
        return dataPoints.filter { $0.time >= cutOffDate }
    }
    
    var xLabels: [Int] {
        guard let lastTime = dataPoints.last?.time else {
            return [0, 15, 30]
        }

        let maxSecond = Calendar.current.component(.second, from: lastTime)
        if maxSecond <= 30 {
            return [0, 15, 30]
        }
        
        let baseValue = (maxSecond / 30) * 30
        return [baseValue, baseValue + 15, baseValue + 30]
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text(title)
                    .font(.headline)

                ZStack(alignment: .topLeading) {
                    Color(hex: "0A0820")

                    // Grid lines
                    Gridlines(dataPoints: dataPoints, geometry: geometry)

                    VStack {
                        ZStack {
                            // Line chart
                            LineChartPath(dataPoints: dataPoints, geometry: geometry)

                            // Y-axis labels
                            VStack {
                                ForEach(yAxisValues.reversed(), id: \.self) { value in
                                    Text("\(value)")
                                        .font(.caption)
                                        .alignmentGuide(.leading) { $0[.leading] }
                                    Spacer()
                                }
                            }
                            .frame(height: geometry.size.height, alignment: .leading)
                            .padding(.leading, 10)

                            // X-axis labels
                            VStack {
                                Spacer()
                                HStack(alignment: .bottom) {
                                    Text("\(xLabels[0])s")
                                        .font(.caption)
                                        .frame(width: geometry.size.width / 3, alignment: .leading)
                                    
                                    Text("\(xLabels[1])s")
                                        .font(.caption)
                                        .frame(width: geometry.size.width / 3, alignment: .center)
                                    
                                    Text("\(xLabels[2])s")
                                        .font(.caption)
                                        .frame(width: geometry.size.width / 3, alignment: .trailing)
                                }
                                .frame(width: geometry.size.width)
                            }
                            .frame(width: geometry.size.width)
                            .padding(.top, 10)
                        }
                    }
                }
            }
        }
    }
}

struct Gridlines: View {
    let dataPoints: [HeartRateData]
    let geometry: GeometryProxy
    
    var body: some View {
        ZStack {
            // Horizontal grid lines
            ForEach(0..<5) { index in
                let y = CGFloat(index) * (geometry.size.height / 4)
                Path { path in
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: y))
                }
                .stroke(Color.gray, style: StrokeStyle(lineWidth: 0.5, dash: [5]))
            }

            // Vertical grid lines
            ForEach(0..<3) { index in
                let x = CGFloat(index) * (geometry.size.width / 2)
                Path { path in
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: geometry.size.height))
                }
                .stroke(Color.gray, style: StrokeStyle(lineWidth: 0.5, dash: [5]))
            }
        }
    }
}

struct LineChartPath: View {
    let dataPoints: [HeartRateData]
    let geometry: GeometryProxy
    @State private var animate = false

    var body: some View {
        Path { path in
            for (index, dataPoint) in dataPoints.enumerated() {
                let x = CGFloat(index) * (geometry.size.width / CGFloat(dataPoints.count - 1))
                // Adjusted the line chart plotting for correct y-values
                let y = (1 - CGFloat(dataPoint.rate) / 200.0) * geometry.size.height
                if index == 0 {
                    path.move(to: CGPoint(x: x, y: y))
                } else {
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
        }
        .trim(from: animate ? 0 : 1, to: 1)
        .stroke(LinearGradient(
            gradient: Gradient(colors: [Color.red, Color.pink]),
            startPoint: .top,
            endPoint: .bottom
        ), style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
        .shadow(color: .red, radius: 10, x: 0.0, y: 10)
        .shadow(color: .red.opacity(0.5), radius: 10, x: 0.0, y: 10)
        .shadow(color: .red.opacity(0.2), radius: 10, x: 0.0, y: 10)
        .shadow(color: .red.opacity(0.1), radius: 10, x: 0.0, y: 10)
        .animation(.easeInOut(duration: 1))
        .onAppear() {
            self.animate.toggle()
        }
    }
}

struct LineChartView_Previews: PreviewProvider {
    static var previews: some View {
        LineChartView(
            dataPoints: dev.mockDataPoints,
            title: "Heart Rate (bpm)",
            yAxisLabel: "Rate",
            xAxisLabel: "Time"
        )
    }
}
