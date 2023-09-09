//
//  NextDepartureWatchWidget.swift
//  NextDepartureWatchWidget
//
//  Created by Florian Rhein on 14.10.22.
//

import WidgetKit
import SwiftUI
import Intents
import WannVerbindungServices

struct NextDepartureWatchWidgetEntryView : View {
    var entry: NextDepartureTimelineEntry

    var body: some View {
        VStack {
            Text("Next Departure from \(entry.startStationName) to \(entry.destinationStationName):")
                .multilineTextAlignment(.leading)
            if let plannedDeparture = entry.plannedDeparture, !entry.isCancelled {
                HStack {
                    Text(plannedDeparture, style: .time)
                    if let delay = entry.delay {
                        Text("+ \(delay)").bold().foregroundColor(.red)
                    }
                }
            } else {
                Text("⚠️")
            }
        }
    }
}

@main
struct NextDepartureWatchWidget: Widget {
    let kind: String = "NextDepartureWatchWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration<ConfigurationIntent, NextDepartureWatchWidgetEntryView>(
            kind: kind,
            intent: ConfigurationIntent.self,
            provider: NextDepartureTimelineProvider<ConfigurationIntent>(),
            content: (NextDepartureWatchWidgetEntryView.init)
        )
        .configurationDisplayName("Show next departure")
        .description("This widget displays the next departure on your configured commute.")
    }
}

struct NextDepartureWatchWidget_Previews: PreviewProvider {
    static var previews: some View {
        NextDepartureWatchWidgetEntryView(
            entry: .init(
                direction: .outbound,
                plannedDeparture: .now.addingTimeInterval(300),
                startStationName: "Mainz",
                destinationStationName: "Frankfurt",
                delay: 5,
                isCancelled: false
            )

        )
        .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
    }
}
