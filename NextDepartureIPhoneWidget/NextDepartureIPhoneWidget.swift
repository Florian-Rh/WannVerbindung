//
//  NextDepartureIPhoneWidget.swift
//  NextDepartureIPhoneWidget
//
//  Created by Florian Rhein on 14.10.22.
//

import WidgetKit
import SwiftUI
import Intents
import WannVerbindungServices

struct NextDepartureIPhoneWidgetEntryView : View {
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

struct NextDepartureIPhoneWidget: Widget {
    let kind: String = "NextDepartureIPhoneWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration<ConfigurationIntent, NextDepartureIPhoneWidgetEntryView>(
            kind: kind,
            intent: ConfigurationIntent.self,
            provider: NextDepartureTimelineProvider<ConfigurationIntent>(),
            content: (NextDepartureIPhoneWidgetEntryView.init)
        )
        .configurationDisplayName("Show next departure")
        .description("This widget displays the next departure on your configured commute.")
    }
}

struct NextDepartureIPhoneWidget_Previews: PreviewProvider {
    static var previews: some View {
        NextDepartureIPhoneWidgetEntryView(
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
