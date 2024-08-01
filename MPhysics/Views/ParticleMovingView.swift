//
//  ParticleMovingView.swift
//  MPhysics
//
//  Created by Mint on 2024/7/30.
//

import SwiftUI

struct ParticleInfo {
    var position: Vector2D
    var velocities: [Vector2D]
    var historicalPositions: [Vector2D]
    var times: [(Double?, Double?)]
    
    func velocity(fps: Double, timestamp: Int) -> Vector2D {
        var v = Vector2D(x: 0, y: 0)
        for i in 0..<velocities.count {
            if let start = times[i].0 {
                if start * fps > Double(timestamp) {
                    continue
                }
            }
            if let end = times[i].1 {
                if end * fps < Double(timestamp) {
                    continue
                }
            }
            v = v + velocities[i]
        }
        return v
    }
    
    var centreIndex: [Int?] = []
}

struct ParticleMovingView: View {
    var particles: [Particle]
    @Binding var editable: Bool
    @Binding var meter: Double
    @State var timestamp: Int = 0
    @State var particleInfo: [ParticleInfo] = []
    @State var isMoving: Bool = false
    @State var isOnSettingPage: Bool = false
    @State var fps: Double = 60
    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var showingTimestamp: Bool = true
    
    var body: some View {
        GeometryReader { size in
            ZStack(alignment: .center) {
                if showingTimestamp {
                    Text(String(format: "%.1f s", Double(timestamp) / fps))
                        .font(.headline)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                        .padding(.all, 5)
                }
                ForEach(0..<particles.count, id: \.self) { index in
                    if particles[index].displayced {
                        if particleInfo.count == 0 {
                            if isVisible(position: particles[index].position, size: size.size) {
                                Circle()
                                    .fill(Color(particles[index].color))
                                    .frame(width: particles[index].radius * 2)
                                    .offset(x: particles[index].position.x * meter, y: -particles[index].position.y * meter)
                            }
                        } else {
                            if particleInfo[index].historicalPositions.count > 1 {
                                if particles[index].showingPath {
                                    if particles[index].fadingPath {
                                        ForEach(0..<(particleInfo[index].historicalPositions.count - 1), id: \.self) { i in
                                            if isVisible(position: particleInfo[index].historicalPositions[i], size: size.size) && isVisible(position: particleInfo[index].historicalPositions[i + 1], size: size.size) {
                                                Path { path in
                                                    path.move(to: CGPoint(x: particleInfo[index].historicalPositions[i].x * meter, y: -particleInfo[index].historicalPositions[i].y * meter))
                                                    path.addLine(to: CGPoint(x: particleInfo[index].historicalPositions[i + 1].x * meter, y: -particleInfo[index].historicalPositions[i + 1].y * meter))
                                                }
                                                .stroke(
                                                    Color(particles[index].color)
                                                        .opacity(
                                                            (Double(i) + particles[index].pathDuration * fps -
                                                             Double(particleInfo[index].historicalPositions.count))
                                                            / fps / particles[index].pathDuration
                                                        ),
                                                    lineWidth: particles[index].pathThickness
                                                )
                                                .offset(x: size.size.width / 2, y: size.size.height / 2)
                                            }
                                        }
                                    } else {
                                        Path { path in
                                            path.move(to: CGPoint(x: particleInfo[index].historicalPositions[0].x * meter, y: -particleInfo[index].historicalPositions[0].y * meter))
                                            for i in 1..<particleInfo[index].historicalPositions.count {
                                                if isVisible(position: particleInfo[index].historicalPositions[i], size: size.size) {
                                                    path.addLine(to: CGPoint(x: particleInfo[index].historicalPositions[i].x * meter, y: -particleInfo[index].historicalPositions[i].y * meter))
                                                }
                                            }
                                        }
                                        .stroke(Color(particles[index].color), style: .init(lineWidth: particles[index].pathThickness))
                                        .offset(x: size.size.width / 2, y: size.size.height / 2)
                                    }
                                }
                            }
                            Circle()
                                .fill(Color(particles[index].color))
                                .frame(width: particles[index].radius * 2)
                                .offset(x: particleInfo[index].position.x * meter, y: -particleInfo[index].position.y * meter)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .drawingGroup()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onReceive(timer) { _ in
            if particleInfo.count != 0 {
                timestamp += 1
                for i in 0..<particles.count {
                    particleInfo[i].position = particleInfo[i].position + particleInfo[i].velocity(fps: fps, timestamp: timestamp) / fps
                    particleInfo[i].historicalPositions.append(particleInfo[i].position)
                    if Double(particleInfo[i].historicalPositions.count) > particles[i].pathDuration * fps {
                        particleInfo[i].historicalPositions.remove(at: 0)
                    }
                    for j in 0..<particleInfo[i].velocities.count {
                        if let start = particles[i].velocities![j].startingTime {
                            if start * fps > Double(timestamp) {
                                continue
                            }
                        }
                        if let end = particles[i].velocities![j].endingTime {
                            if end * fps < Double(timestamp) {
                                continue
                            }
                        }
                        switch particles[i].velocities![j].changingMode {
                        case .constant:
                            break
                        case .constantAcceleration:
                            particleInfo[i].velocities[j] = particleInfo[i].velocities[j] + particles[i].velocities![j].constantAcceleration!  / fps
                        case .constantCentripetalVelocity:
                            particleInfo[i].velocities[j] = Vector2D(
                                radians: (particles[i].velocities![j].constantCentripetalVelocity_centre! - particleInfo[i].position).radians() + particles[i].velocities![j].constantCentripetalVelocity_radians!,
                                abs: particles[i].velocities![j].constantCentripetalVelocity_speed!
                            )
                        case .constantCentripetalAcceleration:
                            particleInfo[i].velocities[j] = particleInfo[i].velocities[j] + Vector2D(
                                radians: (particles[i].velocities![j].constantCentripetalAcceleration_centre! - particleInfo[i].position).radians() + particles[i].velocities![j].constantCentripetalAcceleration_radians!,
                                abs: particles[i].velocities![j].constantCentripetalAcceleration_acceleration! / fps
                            )
                        case .constantDynamicCentripetalVelocity:
                            if let k = particleInfo[i].centreIndex[j] {
                                particleInfo[i].velocities[j] = Vector2D(
                                    radians: (particleInfo[k].position - particleInfo[i].position).radians() + particles[i].velocities![j].constantDynamicCentripetalVelocity_radians!,
                                    abs: particles[i].velocities![j].constantDynamicCentripetalVelocity_speed!
                                )
                            }
                        case .constantDynamicCentripetalAcceleration:
                            if let k = particleInfo[i].centreIndex[j] {
                                particleInfo[i].velocities[j] = particleInfo[i].velocities[j] + Vector2D(
                                    radians: (particleInfo[k].position - particleInfo[i].position).radians() + particles[i].velocities![j].constantDynamicCentripetalAcceleration_radians!,
                                    abs: particles[i].velocities![j].constantDynamicCentripetalAcceleration_acceleration!
                                )
                            }
                        }
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem {
                Button {
                    editable = true
                    isMoving = false
                    timestamp = 0
                    particleInfo = []
                    timer.upstream.connect().cancel()
                } label: {
                    Label("初始化", systemImage: "backward.end.alt")
                }
            }
            ToolbarItem {
                Button {
                    editable = false
                    if isMoving {
                        timer.upstream.connect().cancel()
                        isMoving.toggle()
                    } else {
                        if particleInfo.count == 0 {
                            for particle in particles {
                                var velocities: [Vector2D] = []
                                var centreIndex: [Int?] = []
                                var times: [(Double?, Double?)] = []
                                switch particle.displaycementMethod {
                                case .componentVelocities:
                                    for v in particle.velocities! {
                                        times.append((v.startingTime, v.endingTime))
                                        switch v.changingMode {
                                        case .constant:
                                            velocities.append(v.constant!)
                                            centreIndex.append(nil)
                                        case .constantAcceleration:
                                            velocities.append(Vector2D(x: 0, y: 0))
                                            centreIndex.append(nil)
                                        case .constantCentripetalVelocity:
                                            velocities.append(Vector2D(
                                                radians: (v.constantCentripetalVelocity_centre! - particle.position).radians() + v.constantCentripetalVelocity_radians!,
                                                abs: v.constantCentripetalVelocity_speed!
                                            ))
                                            centreIndex.append(nil)
                                        case .constantCentripetalAcceleration:
                                            velocities.append(Vector2D(x: 0, y: 0))
                                            centreIndex.append(nil)
                                        case .constantDynamicCentripetalVelocity:
                                            if let c = v.constantDynamicCentripetalVelocity_centre {
                                                if let index = particles.firstIndex(where: { $0.id == c }) {
                                                    velocities.append(Vector2D(
                                                        radians: (particles[index].position - particle.position).radians() + v.constantDynamicCentripetalVelocity_radians!,
                                                        abs: v.constantDynamicCentripetalVelocity_speed!
                                                    ))
                                                    centreIndex.append(index)
                                                } else {
                                                    velocities.append(Vector2D(x: 0, y: 0))
                                                }
                                            } else {
                                                velocities.append(Vector2D(x: 0, y: 0))
                                            }
                                        case .constantDynamicCentripetalAcceleration:
                                            if let c = v.constantDynamicCentripetalAcceleration_centre {
                                                if let index = particles.firstIndex(where: { $0.id == c }) {
                                                    centreIndex.append(index)
                                                }
                                            }
                                            velocities.append(Vector2D(x: 0, y: 0))
                                        }
                                    }
                                }
                                particleInfo.append(ParticleInfo(position: particle.position, velocities: velocities, historicalPositions: [particle.position], times: times, centreIndex: centreIndex))
                            }
                        }
                        isMoving.toggle()
                        timer = Timer.publish(every: 1 / fps, on: .main, in: .common).autoconnect()
                    }
                } label: {
                    Label(isMoving ? "暂停" : "播放", systemImage: isMoving ? "pause" : "play")
                }
            }
            ToolbarItem {
                Button {
                    isOnSettingPage.toggle()
                } label: {
                    Label("设置", systemImage: "gear")
                }
                .popover(isPresented: $isOnSettingPage) {
                    VStack {
                        HStack {
                            Text("1米的长度")
                            Spacer()
                            Text("\(String(format: "%.1f", meter)) pt")
                                .foregroundStyle(.secondary)
                            Slider(value: $meter, in: 0.1...200)
                                .frame(width: 150)
                        }
                        .disabled(!editable)
                        HStack {
                            Text("帧数")
                            Spacer()
                            Text("\(String(format: "%.0f", fps)) fps")
                                .foregroundStyle(.secondary)
                            Slider(value: $fps, in: 1...120)
                                .frame(width: 150)
                        }
                        .disabled(!editable)
                        HStack {
                            Text("显示时间")
                            Spacer()
                            Toggle("", isOn: $showingTimestamp)
                                .toggleStyle(.switch)
                        }
                    }
                    .frame(width: 300)
                    .padding()
                }
            }
        }
    }
    
    func isVisible(position: Vector2D, size: CGSize) -> Bool {
        if abs(position.x * self.meter) >= size.width / 2 + 50 {
            return false
        }
        if abs(position.y * self.meter) >= size.height / 2 + 50 {
            return false
        }
        return true
    }
}

#Preview {
    NavigationSplitView {} detail: {
        ParticleMovingView(particles: TESTING_DOCUMENT.content.particles, editable: .constant(false), meter: .constant(20))
            .frame(width: 600, height: 400)
    }
}
