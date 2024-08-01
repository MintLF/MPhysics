//
//  ParticleListView.swift
//  MPhysics
//
//  Created by Mint on 2024/7/29.
//

import SwiftUI

struct ParticleListView: View {
    @State var isRenaming: Int? = nil
    @Binding var currentParticle: Int?
    @Binding var particles: [Particle]
    
    var body: some View {
        List(selection: $currentParticle) {
            ForEach(0..<particles.count, id: \.self) { index in
                Label(particles[index].name, systemImage: particles[index].icon)
                    .tag(index)
                    .contextMenu {
                        Button {
                            particles.remove(at: index)
                        } label: {
                            Label("删除", systemImage: "trash")
                                .labelStyle(.titleAndIcon)
                        }
                        Button {
                            isRenaming = index
                        } label: {
                            Label("重命名", systemImage: "pencil.line")
                                .labelStyle(.titleAndIcon)
                        }
                    }
                    .popover(isPresented: Binding(get: { index == isRenaming }, set: { if !$0 { isRenaming = nil } })){
                        VStack(alignment: .leading) {
                            HStack {
                                Text("质点名称：")
                                    .bold()
                                TextField("", text: $particles[index].name)
                                    .onSubmit {
                                        isRenaming = nil
                                    }
                            }
                            HStack(alignment: .top) {
                                Text("图标：")
                                    .bold()
                                    .padding(.top, 7.5)
                                IconPickerView(iconName: $particles[index].icon)
                            }
                        }
                        .padding()
                    }
            }
            .onMove { from, to in
                particles.move(fromOffsets: from, toOffset: to)
            }
        }
        .frame(minWidth: 200)
        .toolbar {
            ToolbarItem {
                Button {
                    particles.append(
                        Particle(name: "质点\(particles.count + 1)", position: Vector2D(x: 0, y: 0), displaycementMethod: .componentVelocities, velocities: [])
                    )
                } label: {
                    Label("新建质点", systemImage: "plus")
                }
            }
        }
    }
}

#Preview {
    ParticleListView(currentParticle: .constant(1), particles: .constant(TESTING_DOCUMENT.content.particles))
}
