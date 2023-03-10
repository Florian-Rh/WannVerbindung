//
//  ContentView.swift
//  WannVerbindung
//
//  Created by Florian Rhein on 14.10.22.
//

import SwiftUI

struct ConnectionSettingsView: View {
    @ObservedObject private var viewModel: ConnectionSettingsViewModel = ConnectionSettingsViewModel()

    var body: some View {
        VStack {
            Text("Wann Verbindung?!").font(.title)
            Form {
                Section(header: Text("Verbindung")) {
                    TextField("Zuhause", text: self.$viewModel.homeStation, onCommit: {
                        self.viewModel.seachStop(ofType: .home)
                    })
                    TextField("Zielort", text: self.$viewModel.workStation, onCommit: {
                        self.viewModel.seachStop(ofType: .destination)
                    })
                }

                Section(header: Text("Hinfahrt")) {
                    DatePicker(selection: self.$viewModel.inboundStart, displayedComponents: [.hourAndMinute], label: { Text("Von") })
                    DatePicker(selection: self.$viewModel.inboundEnd, displayedComponents: [.hourAndMinute], label: { Text("Bis") })
                }

                Section(header: Text("Rückfahrt")) {
                    DatePicker(selection: self.$viewModel.outboundStart, displayedComponents: [.hourAndMinute], label: { Text("Von") })
                    DatePicker(selection: self.$viewModel.outboundEnd, displayedComponents: [.hourAndMinute], label: { Text("Bis") })
                }

                Section {
                    Button("Verbindungen anzeigen") {
                        self.viewModel.searchConnections()
                    }
                }
            }
            .cornerRadius(15)
            .padding()

            Button("Einstellungen speichern") {
                self.viewModel.saveConfiguration()
            }
        }
        .alert(isPresented: self.$viewModel.isShowingAlert) {
            Alert(
                title: Text("Ein Fehler ist aufgetreten"),
                message: Text(self.viewModel.alertMessage)
            )
        }
    }
}

struct ConnectionSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionSettingsView()
    }
}
