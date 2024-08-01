//
//  ColorPickerView.swift
//  MPhysics
//
//  Created by Mint on 2024/7/30.
//

import SwiftUI

let COLORS = [
    "Default",
    "MRed",
    "MOrange",
    "MYellow",
    "MGreen",
    "MBlue",
    "MPurple"
]

let COLOR_NAMES = [
    "Default": "默认",
    "MRed": "红色",
    "MOrange": "橙色",
    "MYellow": "黄色",
    "MGreen": "绿色",
    "MBlue": "蓝色",
    "MPurple": "紫色"
]

struct ColorPickerView: View {
    @Binding var color: String
    @State var isEditingColor: Bool = false
    
    var body: some View {
        HStack {
            Text(COLOR_NAMES[color] ?? "Undefined")
                .bold()
                .foregroundStyle(.secondary)
            Button {
                isEditingColor.toggle()
            } label: {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color(color))
                    .frame(width: 24, height: 24)
                    .overlay {
                        Image(systemName: isEditingColor ? "chevron.up.circle.fill" : "chevron.down.circle.fill")
                            .font(.system(size: 11))
                            .bold()
                            .scaledToFit()
                            .foregroundStyle(Color("IconDefault").opacity(isEditingColor ? 0.8 : 0.6))
                            .padding(.all, 2.5)
                            .offset(x: 4, y: 4)
                    }
                    .popover(isPresented: $isEditingColor) {
                        HStack {
                            ForEach(COLORS, id: \.self) { name in
                                VStack {
                                    Button {
                                        color = name
                                    } label: {
                                        RoundedRectangle(cornerRadius: 5)
                                            .fill(Color(name))
                                            .frame(width: 24, height: 24)
                                            .overlay {
                                                if name == color {
                                                    Image(systemName: "checkmark")
                                                        .bold()
                                                        .foregroundStyle(Color("IconDefault"))
                                                }
                                            }
                                    }
                                    .buttonStyle(.plain)
                                    Text(COLOR_NAMES[name] ?? "Undefined")
                                        .font(.system(size: 10.5, weight: .regular))
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .padding()
                    }
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    ColorPickerView(color: .constant("Default"))
        .padding()
}
