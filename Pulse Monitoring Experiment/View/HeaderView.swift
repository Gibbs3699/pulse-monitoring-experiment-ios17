//
//  HeaderView.swift
//  Pulse Monitoring Experiment
//
//  Created by TheGIZzz on 8/10/2566 BE.
//

import SwiftUI

struct HeaderView: View {
    @State private var beatAnimation: Bool = true
    @State private var showPusles: Bool = true
    @State private var pulsedHearts: [HeartParticle] = []
    @State private var heartBeat: Int = 85
    @State private var currentRate: Int = 0
    @State private var elapsedSeconds: Int = 0
    let dataPoints: [HeartRateData]
    
    var body: some View {
        VStack {
            HStack {
                // The information related to current BPM and duration
                VStack(alignment: .leading, spacing: 5, content: {
                    Text("Current")
                        .font(.title3.bold())
                        .foregroundStyle(.white)

                    HStack(alignment: .bottom, spacing: 6, content: {
                        if beatAnimation {
                            TimelineView(.animation(minimumInterval: 1, paused: false)) { timeline in
                                Text("\(currentRate)")
                                    .font(.system(size: 45).bold())
                                    .contentTransition(.numericText(value: Double(dataPoints.last?.rate ?? 0)))
                                    .foregroundStyle(.white)
                                    .onChange(of: timeline.date) { oldValue, newValue in
                                        withAnimation(.bouncy) {
                                            currentRate = dataPoints.last?.rate ?? 0
                                        }
                                    }
                            }
                        } else {
                            Text("\(heartBeat)")
                                .font(.system(size: 45).bold())
                                .foregroundStyle(.white)
                        }

                        Text("BPM")
                            .font(.callout.bold())
                            .foregroundStyle(Color(hex: "D63F51").gradient)
                    })

                    TimelineView(.animation(minimumInterval: 1, paused: false)) { timeline in
                        Text("Duration: \(elapsedSeconds)s")
                            .font(.callout)
                            .foregroundStyle(.gray)
                            .onChange(of: timeline.date) { _ in
                                elapsedSeconds += 1
                            }
                    }
                })
                .padding(.leading, 30)

                Spacer()

                // The heart beating view
                ZStack {
                    if showPusles {
                        TimelineView(.animation(minimumInterval: 0.5, paused: false)) { timeline in
                            ZStack {
                                ForEach(pulsedHearts) { _ in
                                    PulseHeartView()
                                }
                            }
                            .onChange(of: timeline.date) { oldValue, newValue in
                                if beatAnimation {
                                    addPulsedHeart()
                                }
                            }
                        }
                    }

                    Image(systemName: "suit.heart.fill")
                        .font(.system(size: 100))
                        .foregroundStyle(Color(hex: "D63F51").gradient)
                        .symbolEffect(.bounce, options: !beatAnimation ? .default : .repeating.speed(1), value: beatAnimation)
                }
                .frame(maxWidth: 350, maxHeight: 350)
                .padding(.trailing, 30)
            }
            .background(.bar, in: .rect(cornerRadius: 30))

//            Toggle("Beat Animation", isOn: $beatAnimation)
//                .padding(15)
//                .frame(maxWidth: 350)
//                .background(.bar, in: .rect(cornerRadius: 15))
//                .padding(.top, 20)
//                .onChange(of: beatAnimation) { oldValue, newValue in
//                    if pulsedHearts.isEmpty {
//                        showPusles = true
//                    }
//
//                    if newValue && pulsedHearts.isEmpty {
//                        addPulsedHeart()
//                    }
//                }
//                .disabled(!beatAnimation && !pulsedHearts.isEmpty)
        }
    }
    
    func addPulsedHeart() {
        let pulsedHeart = HeartParticle()
        pulsedHearts.append(pulsedHeart)
        
        /// Removing After the pusle animation was Finished
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            pulsedHearts.removeAll(where: { $0.id == pulsedHeart.id })
            
            if pulsedHearts.isEmpty {
                showPusles = false
            }
        }
    }
}

struct PulseHeartView: View {
    @State private var startAnimation: Bool = false
    var body: some View {
        Image(systemName: "suit.heart.fill")
            .font(.system(size: 100))
            .foregroundStyle(Color(hex: "D63F51"))
            .background(content: {
                Image(systemName: "suit.heart.fill")
                    .font(.system(size: 100))
                    .foregroundStyle(.black)
                    .blur(radius: 5, opaque: false)
                    .scaleEffect(startAnimation ? 1.1 : 0)
                    .animation(.linear(duration: 1.5), value: startAnimation)
            })
            .scaleEffect(startAnimation ? 2 : 1)
            .opacity(startAnimation ? 0 : 0.7)
            .onAppear(perform: {
                withAnimation(.linear(duration: 3)) {
                    startAnimation = true
                }
            })
    }
}

struct HeartParticle: Identifiable {
    var id: UUID = .init()
}


struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(dataPoints: dev.mockDataPoints).preferredColorScheme(.dark)
    }
}
