//
//  ContentView.swift
//  WannVerbindung Watch App
//
//  Created by Florian Rhein on 14.10.22.
//

import SwiftUI
import WannVerbindungServices

struct ConnectionSettingsView: View {
    @ObservedObject private var viewModel: ConnectionSettingsViewModel = ConnectionSettingsViewModel()

    var body: some View {
        VStack {
            Text("Wann Verbindung?!").font(.title)
            Form {
                Section(header: Text("Verbindung")) {
                    TextField("Zuhause", text: self.$viewModel.homeStation)
                    TextField("Zielort", text: self.$viewModel.workStation)
                }

                Section(header: Text("Hinfahrt")) {
//                    DatePicker(selection: self.$viewModel.inboundStart, displayedComponents: [.hourAndMinute], label: { Text("Von") })
//                    DatePicker(selection: self.$viewModel.inboundEnd, displayedComponents: [.hourAndMinute], label: { Text("Bis") })
                }

                Section(header: Text("Rückfahrt")) {
//                    DatePicker(selection: self.$viewModel.outboundStart, displayedComponents: [.hourAndMinute], label: { Text("Von") })
//                    DatePicker(selection: self.$viewModel.outboundEnd, displayedComponents: [.hourAndMinute], label: { Text("Bis") })
                }

                Section {
                    Button("Verbindungen anzeigen") {}
                }
            }
            .cornerRadius(15)
            .padding()

            Button("Einstellungen speichern") {
                self.viewModel.saveConfiguration()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionSettingsView()
    }
}
