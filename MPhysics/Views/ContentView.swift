//
//  ContentView.swift
//  MPhysics
//
//  Created by Mint on 2024/7/26.
//

import SwiftUI

struct ContentView: View {
    @Binding var document: MPhysicsDocument
    @State var currentParticle: Int?
    @State var editable: Bool = true

    var body: some View {
        NavigationSplitView {
            ParticleListView(currentParticle: $currentParticle, particles: $document.content.particles)
                .disabled(!editable)
        } content: {
            if let index = currentParticle {
                if index < document.content.particles.count {
                    ParticleEditingView(particle: $document.content.particles[index], particleInfos: {
                        var array1: [UUID] = []
                        var array2: [String] = []
                        for p in document.content.particles {
                            array1.append(p.id)
                            array2.append(p.name)
                        }
                        return (array1, array2)
                    }())
                    .frame(minWidth: 420)
                    .disabled(!editable)
                } else {
                    Image(systemName: "cube.fill")
                        .resizable()
                        .frame(width: 200, height: 200)
                        .foregroundStyle(.quaternary)
                        .frame(minWidth: 420)
                }
            } else {
                Image(systemName: "cube.fill")
                    .resizable()
                    .frame(width: 200, height: 200)
                    .foregroundStyle(.quaternary)
                    .frame(minWidth: 420)
            }
        } detail: {
            ParticleMovingView(particles: document.content.particles, editable: $editable, meter: $document.content.meter)
        }
        .onDeleteCommand {
            if let index = currentParticle {
                document.content.particles.remove(at: index)
            }
        }
    }
}

#Preview {
    ContentView(document: .constant(TESTING_DOCUMENT))
}
