//
//  MPhysicsContent.swift
//  MPhysics
//
//  Created by Mint on 2024/7/28.
//

import Foundation
import SwiftUI

struct MPhysicsContent: Identifiable, Codable {
    var id = UUID()
    var version: String = "1.0.0"
    var particles: [Particle]
    var meter: Double = 20
}

struct Particle: Identifiable, Codable {
    var id = UUID()
    var name: String
    var icon: String = "cube"
    var color: String = "Default"
    var radius: Double = 3
    var showingPath: Bool = true
    var fadingPath: Bool = true
    var pathDuration: Double = 3
    var pathThickness: Double = 1
    var position: Vector2D
    var displayced: Bool = true
    var displaycementMethod: DisplaycementMethod
    
    var velocities: [Velocity]? = nil
}

struct Vector2D: Codable, Hashable {
    var x: Double
    var y: Double
    
    init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
    
    init(radians: Double, abs: Double) {
        self.x = sin(radians) * abs
        self.y = cos(radians) * abs
    }
    
    func abs() -> Double {
        return (pow(self.x, 2) + pow(self.y, 2)).squareRoot()
    }
    
    func radians() -> Double {
        if self.x != 0 {
            if y >= 0 {
                return atan(self.x / self.y)
            }
            return Double.pi - atan(self.x / -self.y)
        }
        if self.y >= 0 {
            return 0
        }
        return Double.pi
    }
    
    func angle() -> Angle {
        return Angle(radians: self.radians())
    }
    
    static func +(left: Vector2D, right: Vector2D) -> Vector2D {
        return Vector2D(x: left.x + right.x, y: left.y + right.y)
    }
    
    static func -(left: Vector2D, right: Vector2D) -> Vector2D {
        return Vector2D(x: left.x - right.x, y: left.y - right.y)
    }
    
    static func *(left: Vector2D, right: Double) -> Vector2D {
        return Vector2D(x: left.x * right, y: left.y * right)
    }
    
    static func /(left: Vector2D, right: Double) -> Vector2D {
        return Vector2D(x: left.x / right, y: left.y / right)
    }
}

enum DisplaycementMethod: Codable, Hashable {
    case componentVelocities
}

struct Velocity: Codable, Hashable {
    var name: String
    var changingMode: VelocityChangingMode
    var startingTime: Double? = nil
    var endingTime: Double? = nil
    
    var constant: Vector2D? = nil
    var constantAcceleration: Vector2D? = nil
    
    var constantCentripetalVelocity_centre: Vector2D? = nil
    var constantCentripetalVelocity_radians: Double? = nil
    var constantCentripetalVelocity_speed: Double? = nil
    var constantCentripetalAcceleration_centre: Vector2D? = nil
    var constantCentripetalAcceleration_radians: Double? = nil
    var constantCentripetalAcceleration_acceleration: Double? = nil
    
    var constantDynamicCentripetalVelocity_centre: UUID? = nil
    var constantDynamicCentripetalVelocity_radians: Double? = nil
    var constantDynamicCentripetalVelocity_speed: Double? = nil
    var constantDynamicCentripetalAcceleration_centre: UUID? = nil
    var constantDynamicCentripetalAcceleration_radians: Double? = nil
    var constantDynamicCentripetalAcceleration_acceleration: Double? = nil
}

enum VelocityChangingMode: Codable, Hashable {
    case constant
    case constantAcceleration
    case constantCentripetalVelocity
    case constantCentripetalAcceleration
    case constantDynamicCentripetalVelocity
    case constantDynamicCentripetalAcceleration
}
