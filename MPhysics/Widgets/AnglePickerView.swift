//
//  AnglePickerView.swift
//  MPhysics
//
//  Created by Mint on 2024/7/31.
//

import SwiftUI

struct AnglePickerView: View {
    @State var isEditing: Bool = false
    @Binding var radians: Double
    
    var body: some View {
        VStack {
            Button {
                isEditing.toggle()
            } label: {
                Image(systemName: "location.north.fill")
                    .font(.system(size: 32))
                    .rotationEffect(Angle(radians: radians))
            }
            .buttonStyle(.plain)
            Text(String(format: "%.2f π", radians / Double.pi))
                .font(.callout)
                .foregroundStyle(.secondary)
                .padding(.top, 1)
        }
        .popover(isPresented: $isEditing) {
            VStack(alignment: .leading) {
                HStack {
                    Text("角度制")
                        .bold()
                    TextField("", text: Binding(get: {
                        return String(format: "%.2f", radians / Double.pi * 180)
                    }, set: { newValue in
                        guard let num = Double(newValue) else { return }
                        radians = num / 180 * Double.pi
                    }))
                    .frame(width: 100)
                    .textFieldStyle(.roundedBorder)
                    Text("°")
                        .foregroundStyle(.secondary)
                        .offset(y: -1)
                        .padding(.leading, -5)
                }
                HStack {
                    Text("弧度制")
                        .bold()
                    TextField("", text: Binding(get: {
                        return String(format: "%.2f", radians / Double.pi)
                    }, set: { newValue in
                        guard let num = Double(newValue) else { return }
                        radians = num * Double.pi
                    }))
                    .frame(width: 100)
                    .textFieldStyle(.roundedBorder)
                    Text("π")
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
    AnglePickerView(radians: .constant(-Double.pi))
        .padding()
}
