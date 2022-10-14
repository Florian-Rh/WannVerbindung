//
//  ContentView.swift
//  WannVerbindung Watch App
//
//  Created by Florian Rhein on 14.10.22.
//

import SwiftUI
import WannVerbindungServices

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, worldy!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
