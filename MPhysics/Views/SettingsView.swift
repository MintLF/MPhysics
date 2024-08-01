//
//  SettingsView.swift
//  MPhysics
//
//  Created by Mint on 2024/8/1.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        TabView {
            ZStack(alignment: .center) {
                Image(systemName: "cube.fill")
                    .resizable()
                    .frame(width: 200, height: 200)
                    .foregroundStyle(.quaternary)
                    .frame(minWidth: 420)
                    .padding()
                Text("没有设置项")
                    .font(.title2)
                    .bold()
                    .foregroundStyle(.secondary)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .tabItem {
                Label("通用", systemImage: "gearshape.fill")
            }
            VStack {
                HStack {
                    Image("Physics")
                        .resizable()
                        .frame(width: 120, height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                        .shadow(radius: 2, x: 0, y: 2)
                        .padding(.trailing, 6)
                    Image("Mint")
                        .resizable()
                        .frame(width: 120, height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                        .shadow(radius: 2, x: 0, y: 2)
                }
                Text("MPhysics")
                    .font(.title2)
                    .bold()
                    .padding(.top, 20)
                Text("版本1.0.0    遵循GNU GPL协议")
                    .foregroundStyle(.secondary)
                Text("Copyleft © 2024 MintLF")
                    .foregroundStyle(.secondary)
                    .padding(.top, 3)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .tabItem {
                Label("关于", systemImage: "person.2.fill")
            }
        }
    }
}

#Preview {
    SettingsView()
}
