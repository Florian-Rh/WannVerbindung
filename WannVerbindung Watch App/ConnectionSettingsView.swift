//
//  ContentView.swift
//  WannVerbindung Watch App
//
//  Created by Florian Rhein on 14.10.22.
//

import SwiftUI
import WannVerbindungServices

struct ConnectionSettingsView: View {
    @ObservedObject fileprivate var viewModel: ConnectionSettingsViewModel = ConnectionSettingsViewModel()

    var body: some View {
        VStack {
            if let configuration = viewModel.configuration {
                Text(
                    """
                    Home station:
                    \(configuration.origin.name)
                    Destination station:
                    \(configuration.destination.name)

                    To change the configuration, open the iPhone app
                    """
                ).frame(maxWidth: .infinity, alignment: .leading)
            } else {
                Text("Configure your connection in the iPhone app")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ConnectionSettingsViewModel()
        viewModel.configuration = .init(
            origin: .init(id: "", name: "home"),
            destination: .init(id: "", name: "destination")
        )

        var view = ConnectionSettingsView()
        view.viewModel = viewModel

        return view
    }
}
