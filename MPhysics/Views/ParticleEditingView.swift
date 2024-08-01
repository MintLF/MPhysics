//
//  ParticleEditingView.swift
//  MPhysics
//
//  Created by Mint on 2024/7/29.
//

import SwiftUI

struct ParticleEditingView: View {
    @State var isEditingVelocities: Bool = false
    @State var velocitySelection: Int? = nil
    @Binding var particle: Particle
    var particleInfos: ([UUID], [String])
    
    var body: some View {
        Form {
            Section("基本信息") {
                TextField("质点名称", text: $particle.name)
                HStack {
                    Text("UID")
                    Spacer()
                    Text("\(particle.id)")
                        .foregroundStyle(.secondary)
                }
                HStack(alignment: .top) {
                    Text("图标")
                        .padding(.top, 7.5)
                    Spacer()
                    IconPickerView(iconName: $particle.icon, alignment: .trailing, iconsPerRow: 10)
                }
            }
            Section("外观") {
                Toggle("显示", isOn: $particle.displayced)
                if particle.displayced {
                    HStack {
                        Text("颜色")
                        Spacer()
                        ColorPickerView(color: $particle.color)
                    }
                    Slider(value: $particle.radius, in: 1...20.0) {
                        HStack {
                            Text("半径")
                            Spacer()
                            Text(String(format: "%.1f", particle.radius) + " pt")
                                .bold()
                                .foregroundStyle(.secondary)
                        }
                        .offset(x: 0, y: 1)
                    }
                    Toggle("显示路径", isOn: $particle.showingPath)
                }
            }
            if particle.displayced && particle.showingPath {
                Section {
                    Toggle(isOn: $particle.fadingPath) {
                        VStack(alignment: .leading) {
                            Text("路径渐隐")
                            if particle.fadingPath {
                                HStack(spacing: 0) {
                                    Image(systemName: "exclamationmark.triangle")
                                        .font(.callout)
                                        .foregroundStyle(.secondary)
                                        .padding(.leading, -2)
                                        .padding(.trailing, 2)
                                    Text("这可能导致严重的卡顿")
                                        .font(.callout)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                    Slider(value: $particle.pathThickness, in: 0.5...5) {
                        HStack {
                            Text("路径粗细")
                            Spacer()
                            Text(String(format: "%.1f", particle.pathThickness) + " pt")
                                .bold()
                                .foregroundStyle(.secondary)
                        }
                        .offset(x: 0, y: 1)
                    }
                    Slider(value: $particle.pathDuration, in: 1...30) {
                        HStack {
                            Text("路径显示时间")
                            Spacer()
                            Text(String(format: "%.1f", particle.pathDuration) + " s")
                                .bold()
                                .foregroundStyle(.secondary)
                        }
                        .offset(x: 0, y: 1)
                    }
                }
            }
            Section("运动") {
                HStack {
                    Text("初始位置")
                    Spacer()
                    VectorSettingView(vector: $particle.position, dimension: "m")
                }
                Picker("定义方式", selection: $particle.displaycementMethod) {
                    Text("分速度")
                        .tag(DisplaycementMethod.componentVelocities)
                }
            }
            switch particle.displaycementMethod {
            case .componentVelocities:
                Section {
                    if particle.velocities!.count != 0 {
                        VelocityEditingView(velocities: $particle.velocities, id: particle.id, particleIDs: particleInfos.0, particleNames: particleInfos.1, index: 0)
                    }
                } header: {
                    HStack {
                        Text("分速度")
                        Spacer()
                        Button {
                            isEditingVelocities.toggle()
                        } label: {
                            Image(systemName: "list.bullet")
                                .font(.headline.weight(.regular))
                        }
                        .buttonStyle(.plain)
                        .popover(isPresented: $isEditingVelocities) {
                            List(selection: $velocitySelection) {
                                ForEach(0..<particle.velocities!.count, id: \.self) { index in
                                    Text(particle.velocities![index].name)
                                        .tag(index)
                                }
                                .onMove { from, to in
                                    particle.velocities!.move(fromOffsets: from, toOffset: to)
                                }
                            }
                            .onDeleteCommand {
                                if let s = velocitySelection {
                                    particle.velocities!.remove(at: s)
                                }
                            }
                            .scrollContentBackground(.hidden)
                        }
                        Button {
                            particle.velocities!.append(Velocity(name: "速度\(particle.velocities!.count + 1)", changingMode: .constant, constant: Vector2D(x: 0, y: 0)))
                        } label: {
                            Image(systemName: "plus")
                                .font(.headline.weight(.regular))
                        }
                        .buttonStyle(.plain)
                    }
                }
                if particle.velocities!.count > 1 {
                    ForEach(1..<particle.velocities!.count, id: \.self) { index in
                        Section {
                            VelocityEditingView(velocities: $particle.velocities, id: particle.id, particleIDs: particleInfos.0, particleNames: particleInfos.1, index: index)
                        }
                    }
                }
            }
        }
        .formStyle(.grouped)
    }
}

struct VelocityEditingView: View {
    @Binding var velocities: [Velocity]?
    @State var isEditingUUID: Bool = false
    var id: UUID
    var particleIDs: [UUID]
    var particleNames: [String]
    var index: Int
    
    var body: some View {
        HStack {
            TextField("", text: Binding(get: {
                return velocities![index].name
            }, set: { newValue in
                velocities![index].name = newValue
            }))
            .labelsHidden()
            Spacer()
            Button {
                velocities!.remove(at: index)
            } label: {
                Image(systemName: "trash")
                    .foregroundStyle(.red)
            }
            .buttonStyle(.plain)
        }
        Picker("类型", selection: Binding(get: {
            return velocities![index].changingMode
        }, set: { newValue in
            switch newValue {
            case .constant:
                velocities![index].constant = velocities![index].constant ?? Vector2D(x: 0, y: 0)
            case .constantAcceleration:
                velocities![index].constantAcceleration = velocities![index].constantAcceleration ?? Vector2D(x: 0, y: 0)
            case .constantCentripetalVelocity:
                velocities![index].constantCentripetalVelocity_speed = velocities![index].constantCentripetalVelocity_speed ?? 0
                velocities![index].constantCentripetalVelocity_centre = velocities![index].constantCentripetalVelocity_centre ?? Vector2D(x: 0, y: 0)
                velocities![index].constantCentripetalVelocity_radians = velocities![index].constantCentripetalVelocity_radians ?? 0
            case .constantCentripetalAcceleration:
                velocities![index].constantCentripetalAcceleration_acceleration = velocities![index].constantCentripetalAcceleration_acceleration ?? 0
                velocities![index].constantCentripetalAcceleration_centre = velocities![index].constantCentripetalAcceleration_centre ?? Vector2D(x: 0, y: 0)
                velocities![index].constantCentripetalAcceleration_radians = velocities![index].constantCentripetalAcceleration_radians ?? 0
            case .constantDynamicCentripetalVelocity:
                velocities![index].constantDynamicCentripetalVelocity_speed = velocities![index].constantDynamicCentripetalVelocity_speed ?? 0
                velocities![index].constantDynamicCentripetalVelocity_centre = velocities![index].constantDynamicCentripetalVelocity_centre
                velocities![index].constantDynamicCentripetalVelocity_radians = velocities![index].constantDynamicCentripetalVelocity_radians ?? 0
            case .constantDynamicCentripetalAcceleration:
                velocities![index].constantDynamicCentripetalAcceleration_acceleration = velocities![index].constantDynamicCentripetalAcceleration_acceleration ?? 0
                velocities![index].constantDynamicCentripetalAcceleration_centre = velocities![index].constantDynamicCentripetalAcceleration_centre
                velocities![index].constantDynamicCentripetalAcceleration_radians = velocities![index].constantDynamicCentripetalAcceleration_radians ?? 0
            }
            velocities![index].changingMode = newValue
        })) {
            Text("常速度")
                .tag(VelocityChangingMode.constant)
            Text("加速度")
                .tag(VelocityChangingMode.constantAcceleration)
            Text("向心速度")
                .tag(VelocityChangingMode.constantCentripetalVelocity)
            Text("向心加速度")
                .tag(VelocityChangingMode.constantCentripetalAcceleration)
            Text("向动点速度")
                .tag(VelocityChangingMode.constantDynamicCentripetalVelocity)
            Text("向动点加速度")
                .tag(VelocityChangingMode.constantDynamicCentripetalAcceleration)
        }
        switch velocities![index].changingMode {
        case .constant:
            HStack {
                Text("速度大小")
                Spacer()
                VectorSettingView(vector: Binding(get: {
                    return velocities![index].constant!
                }, set: { newValue in
                    velocities![index].constant = newValue
                }))
            }
        case .constantAcceleration:
            HStack {
                Text("加速度大小")
                Spacer()
                VectorSettingView(vector: Binding(get: {
                    return velocities![index].constantAcceleration!
                }, set: { newValue in
                    velocities![index].constantAcceleration = newValue
                }), dimension: "m/s^2")
            }
        case .constantCentripetalVelocity:
            HStack {
                TextField("速率", text: Binding(get: {
                    return String(format: "%.2f", velocities![index].constantCentripetalVelocity_speed!)
                }, set: { newValue in
                    guard let num = Double(newValue) else { return }
                    velocities![index].constantCentripetalVelocity_speed = num
                }))
                .padding(.all, -10)
                Text("m/s")
                    .foregroundStyle(.secondary)
                    .padding(.leading, -5)
            }
            HStack {
                Text("中心位置")
                Spacer()
                VectorSettingView(vector: Binding(get: {
                    return velocities![index].constantCentripetalVelocity_centre!
                }, set: { newValue in
                    velocities![index].constantCentripetalVelocity_centre = newValue
                }), dimension: "m")
            }
            HStack {
                Text("偏转角度")
                Spacer()
                AnglePickerView(radians: Binding(get: {
                    return velocities![index].constantCentripetalVelocity_radians!
                }, set: { newValue in
                    velocities![index].constantCentripetalVelocity_radians = newValue
                }))
            }
        case .constantCentripetalAcceleration:
            HStack {
                TextField("速率变化率", text: Binding(get: {
                    return String(format: "%.2f", velocities![index].constantCentripetalAcceleration_acceleration!)
                }, set: { newValue in
                    guard let num = Double(newValue) else { return }
                    velocities![index].constantCentripetalAcceleration_acceleration = num
                }))
                .padding(.all, -10)
                Text("m/s^2")
                    .foregroundStyle(.secondary)
                    .padding(.leading, -5)
            }
            HStack {
                Text("中心位置")
                Spacer()
                VectorSettingView(vector: Binding(get: {
                    return velocities![index].constantCentripetalAcceleration_centre!
                }, set: { newValue in
                    velocities![index].constantCentripetalAcceleration_centre = newValue
                }), dimension: "m")
            }
            HStack {
                Text("偏转角度")
                Spacer()
                AnglePickerView(radians: Binding(get: {
                    return velocities![index].constantCentripetalAcceleration_radians!
                }, set: { newValue in
                    velocities![index].constantCentripetalAcceleration_radians = newValue
                }))
            }
        case .constantDynamicCentripetalVelocity:
            HStack {
                TextField("速率", text: Binding(get: {
                    return String(format: "%.2f", velocities![index].constantDynamicCentripetalVelocity_speed!)
                }, set: { newValue in
                    guard let num = Double(newValue) else { return }
                    velocities![index].constantDynamicCentripetalVelocity_speed = num
                }))
                .padding(.all, -10)
                Text("m/s")
                    .foregroundStyle(.secondary)
                    .padding(.leading, -5)
            }
            HStack {
                Text("中心质点")
                Spacer()
                Group {
                    if let c = velocities![index].constantDynamicCentripetalVelocity_centre {
                        if let i = particleIDs.firstIndex(of: c) {
                            Text(particleNames[i])
                        } else {
                            Text("无")
                        }
                    } else {
                        Text("无")
                    }
                }
                .bold()
                .foregroundStyle(.secondary)
                .offset(x: 5, y: 0)
                Button {
                    isEditingUUID.toggle()
                } label: {
                    Image(systemName: isEditingUUID ? "chevron.up.circle.fill" : "chevron.down.circle.fill")
                }
                .buttonStyle(.plain)
                .popover(isPresented: $isEditingUUID) {
                    List(selection: Binding(get: {
                        return velocities![index].constantDynamicCentripetalVelocity_centre
                    }, set: { newValue in
                        velocities![index].constantDynamicCentripetalVelocity_centre = newValue
                    })) {
                        ForEach(0..<particleIDs.count, id: \.self) { index in
                            if particleIDs[index] != id {
                                Text(particleNames[index])
                                    .tag(particleIDs[index])
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            HStack {
                Text("偏转角度")
                Spacer()
                AnglePickerView(radians: Binding(get: {
                    return velocities![index].constantDynamicCentripetalVelocity_radians!
                }, set: { newValue in
                    velocities![index].constantDynamicCentripetalVelocity_radians = newValue
                }))
            }
        case .constantDynamicCentripetalAcceleration:
            HStack {
                TextField("速率变化率", text: Binding(get: {
                    return String(format: "%.2f", velocities![index].constantDynamicCentripetalAcceleration_acceleration!)
                }, set: { newValue in
                    guard let num = Double(newValue) else { return }
                    velocities![index].constantDynamicCentripetalAcceleration_acceleration = num
                }))
                .padding(.all, -10)
                Text("m/s^2")
                    .foregroundStyle(.secondary)
                    .padding(.leading, -5)
            }
            HStack {
                Text("中心质点")
                Spacer()
                Group {
                    if let c = velocities![index].constantDynamicCentripetalAcceleration_centre {
                        if let i = particleIDs.firstIndex(of: c) {
                            Text(particleNames[i])
                        } else {
                            Text("无")
                        }
                    } else {
                        Text("无")
                    }
                }
                .bold()
                .foregroundStyle(.secondary)
                .offset(x: 5, y: 0)
                Button {
                    isEditingUUID.toggle()
                } label: {
                    Image(systemName: isEditingUUID ? "chevron.up.circle.fill" : "chevron.down.circle.fill")
                }
                .buttonStyle(.plain)
                .popover(isPresented: $isEditingUUID) {
                    List(selection: Binding(get: {
                        return velocities![index].constantDynamicCentripetalAcceleration_centre
                    }, set: { newValue in
                        velocities![index].constantDynamicCentripetalAcceleration_centre = newValue
                    })) {
                        ForEach(0..<particleIDs.count, id: \.self) { index in
                            if particleIDs[index] != id {
                                Text(particleNames[index])
                                    .tag(particleIDs[index])
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            HStack {
                Text("偏转角度")
                Spacer()
                AnglePickerView(radians: Binding(get: {
                    return velocities![index].constantDynamicCentripetalAcceleration_radians!
                }, set: { newValue in
                    velocities![index].constantDynamicCentripetalAcceleration_radians = newValue
                }))
            }
        }
        HStack {
            Text("起始时间")
            Toggle("", isOn: Binding(get: {
                return velocities![index].startingTime != nil
            }, set: { newValue in
                if newValue {
                    velocities![index].startingTime = 0
                } else {
                    velocities![index].startingTime = nil
                }
            }))
            .toggleStyle(.checkbox)
            .labelsHidden()
            TextField("", text: Binding(get: {
                return String(format: "%.2f", velocities![index].startingTime ?? 0)
            }, set: { newValue in
                if let num = Double(newValue) {
                    velocities![index].startingTime = num
                }
            }))
            .disabled(velocities![index].startingTime == nil)
            .padding(.all, -10)
            Text("s")
                .foregroundStyle(.secondary)
                .padding(.leading, -5)
        }
        HStack {
            Text("截止时间")
            Toggle("", isOn: Binding(get: {
                return velocities![index].endingTime != nil
            }, set: { newValue in
                if newValue {
                    velocities![index].endingTime = 0
                } else {
                    velocities![index].endingTime = nil
                }
            }))
            .toggleStyle(.checkbox)
            .labelsHidden()
            TextField("", text: Binding(get: {
                return String(format: "%.2f", velocities![index].endingTime ?? 0)
            }, set: { newValue in
                if let num = Double(newValue) {
                    velocities![index].endingTime = num
                }
            }))
            .disabled(velocities![index].endingTime == nil)
            .padding(.all, -10)
            Text("s")
                .foregroundStyle(.secondary)
                .padding(.leading, -5)
        }
    }
}

#Preview {
    ParticleEditingView(particle: .constant(TESTING_DOCUMENT.content.particles[0]), particleInfos: ([UUID()], ["质点1"]))
        .frame(height: 900)
}
