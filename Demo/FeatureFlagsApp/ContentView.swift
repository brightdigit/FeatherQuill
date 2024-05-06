//
//  ContentView.swift
//  FeatureFlagsApp
//
//  Created by Leo Dion on 5/5/24.
//

import SwiftUI
import FeatureFlagsExample

struct ContentView: View {
  @Environment(\.newDesign) var newDesign
  var body: some View {
    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundStyle(.tint)
      Text("Hello, world!")
      
      Toggle("Is Enabled", isOn: self.newDesign.isEnabled)
        .disabled(!self.newDesign.isAvailable)
        .opacity(self.newDesign.isAvailable ? 1.0 : 0.5)
    }
    .padding()
  }
}

#Preview {
  ContentView()
}
