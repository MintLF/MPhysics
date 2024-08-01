//
//  IconPickerView.swift
//  MPhysics
//
//  Created by Mint on 2024/7/30.
//

import SwiftUI

let ICONS: [String] = [
    "cube",
    "cube.fill",
    "cube.transparent",
    "cube.transparent.fill",
    "shippingbox",
    "shippingbox.fill",
    "smallcircle.circle",
    "smallcircle.filled.circle",
    "smallcircle.circle.fill",
    "smallcircle.filled.circle.fill",
    "dot.square",
    "dot.squareshape",
    "dot.viewfinder",
    "dot.square.fill",
    "dot.squareshape.fill",
    "dot.squareshape.split.2x2",
    "squareshape.split.2x2.dotted",
    "squareshape.dotted.split.2x2",
    "chart.dots.scatter",
    "point.3.connected.trianglepath.dotted",
    "point.3.filled.connected.trianglepath.dotted",
    "point.topleft.down.to.point.bottomright.curvepath.fill",
    "point.topleft.down.to.point.bottomright.filled.curvepath",
    "point.topleft.filled.down.to.point.bottomright.curvepath",
    "point.topleft.down.to.point.bottomright.curvepath",
    "point.bottomleft.forward.to.point.topright.scurvepath.fill",
    "point.bottomleft.forward.to.point.topright.filled.scurvepath",
    "point.bottomleft.filled.forward.to.point.topright.scurvepath",
    "point.bottomleft.forward.to.point.topright.scurvepath",
    "point.bottomleft.forward.to.arrowtriangle.uturn.scurvepath.fill",
    "point.bottomleft.forward.to.arrowtriangle.uturn.scurvepath",
    "scope",
    "point.forward.to.point.capsulepath.fill",
    "point.forward.to.point.capsulepath"
]

struct IconPickerView: View {
    @Binding var iconName: String
    var alignment: HorizontalAlignment = .leading
    var iconsPerRow: Int = 8
    
    var body: some View {
        LazyVGrid(columns: [GridItem](repeating: GridItem(.fixed(32), spacing: 0), count: iconsPerRow), spacing: 0) {
            ForEach(0..<ICONS.count, id: \.self) { index in
                if index == Int(ICONS.count / iconsPerRow) * iconsPerRow {
                    if alignment == .trailing {
                        ForEach(0..<(iconsPerRow - ICONS.count % iconsPerRow), id: \.self) { _ in
                            Text("")
                        }
                    }
                }
                button(ICONS[index])
            }
        }
    }
    
    @ViewBuilder func button(_ title: String) -> some View {
        Button {
            iconName = title
        } label: {
            VStack {
                Image(systemName: title)
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(Color.accentColor)
                    .padding(.all, 7)
                    .frame(width: 32, height: 32)
            }
            .background {
                if iconName == title {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(.quaternary)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    IconPickerView(iconName: .constant("cube"), alignment: .trailing, iconsPerRow: 10)
        .padding()
}
