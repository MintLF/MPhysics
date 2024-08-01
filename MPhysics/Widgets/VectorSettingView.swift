//
//  VectorSettingView.swift
//  MPhysics
//
//  Created by Mint on 2024/7/30.
//

import SwiftUI

struct VectorSettingView: View {
    @Binding var vector: Vector2D
    @State var isEditing: Bool = false
    var dimension: String = "m/s"
    
    var body: some View {
        VStack {
            Button {
                isEditing.toggle()
            } label: {
                Image(systemName: vector.x == 0 && vector.y == 0 ? "location.slash.fill" : "location.north.fill")
                    .font(.system(size: 32))
                    .rotationEffect(vector.angle())
            }
            .buttonStyle(.plain)
            Text(String(format: "%.2f ", vector.abs()) + dimension)
                .font(.callout)
                .foregroundStyle(.secondary)
                .padding(.top, 1)
        }
        .popover(isPresented: $isEditing) {
            VStack {
                HStack {
                    Text("X")
                        .bold()
                    TextField("", text: Binding(get: {
                        return String(format: "%.2f", vector.x)
                    }, set: { newValue in
                        guard let num = Double(newValue) else { return }
                        vector.x = num
                    }))
                    .frame(width: 100)
                    .textFieldStyle(.roundedBorder)
                    Text(dimension)
                        .foregroundStyle(.secondary)
                        .offset(y: -1)
                        .padding(.leading, -5)
                }
                HStack {
                    Text("Y")
                        .bold()
                    TextField("", text: Binding(get: {
                        return String(format: "%.2f", vector.y)
                    }, set: { newValue in
                        guard let num = Double(newValue) else { return }
                        vector.y = num
                    }))
                    .frame(width: 100)
                    .textFieldStyle(.roundedBorder)
                    Text(dimension)
                        .foregroundStyle(.secondary)
                        .offset(y: -1)
                        .padding(.leading, -5)
                }
            }
            .padding()
        }
    }
}

#Preview {
    VStack {
        VectorSettingView(vector: .constant(Vector2D(x: 1, y: 1)))
            .padding()
        VectorSettingView(vector: .constant(Vector2D(x: -1, y: 1)))
            .padding()
        VectorSettingView(vector: .constant(Vector2D(x: -1, y: -1)))
            .padding()
        VectorSettingView(vector: .constant(Vector2D(x: 1, y: -1)))
            .padding()
    }
}
