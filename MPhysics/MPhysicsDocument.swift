//
//  MPhysicsDocument.swift
//  MPhysics
//
//  Created by Mint on 2024/7/26.
//

import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static let mphysicsDocument = UTType(exportedAs: "com.example.mphysics")
}

struct MPhysicsDocument: FileDocument, Codable {
    var content: MPhysicsContent

    init(text: String = "") {
        self.content = MPhysicsContent(particles: [Particle(name: "质点1", position: Vector2D(x: 0, y: 0), displaycementMethod: .componentVelocities, velocities: [])])
    }
    
    init(particles: [Particle]) {
        self.content = MPhysicsContent(particles: particles)
    }

    static var readableContentTypes: [UTType] { [.mphysicsDocument] }

    init(configuration: ReadConfiguration) throws {
        let data = configuration.file.regularFileContents!
        self = try JSONDecoder().decode(Self.self, from: data)
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = try JSONEncoder().encode(self)
        return FileWrapper(regularFileWithContents: data)
    }
}

let TESTING_DOCUMENT: MPhysicsDocument = MPhysicsDocument(particles: [Particle(
        name: "Particle 1",
        position: Vector2D(x: 0, y: 0),
        displaycementMethod: .componentVelocities,
        velocities: [Velocity(name: "速度1", changingMode: .constant, constant: Vector2D(x: 1, y: 1))]
    )
])
