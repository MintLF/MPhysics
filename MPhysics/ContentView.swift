//
//  ContentView.swift
//  MPhysics
//
//  Created by Mint on 2024/7/26.
//

import SwiftUI

struct ContentView: View {
    @Binding var document: MPhysicsDocument

    var body: some View {
        TextEditor(text: $document.text)
    }
}

#Preview {
    ContentView(document: .constant(MPhysicsDocument()))
}
