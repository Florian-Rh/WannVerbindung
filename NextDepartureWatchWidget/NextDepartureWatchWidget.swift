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

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> NextDepartureTimelineEntry {
        .init(direction: .inbound, plannedDeparture: Date(), delay: 5, isCancelled: true, dummy: "placeholder")
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (NextDepartureTimelineEntry) -> ()) {
        completion(
            .init(direction: .inbound, plannedDeparture: Date(), delay: 5, isCancelled: true, dummy: "snapshot")
        )
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let homestation = UserDefaults(suiteName: "group.rhein.me.wannVerbindung")?.string(forKey: "homeStationCode") ?? "unset"
        
        let timeline = Timeline(
            entries: [
                NextDepartureTimelineEntry(
                    direction: .inbound,
                    plannedDeparture: Date(),
                    delay: 5,
                    isCancelled: true,
                    dummy: homestation
                )
            ],
            policy: .atEnd
        )

        completion(timeline)
    }

    func recommendations() -> [IntentRecommendation<ConfigurationIntent>] {
        return [
            IntentRecommendation(intent: ConfigurationIntent(), description: "My Intent Widget")
        ]
    }
}

struct NextDepartureWatchWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Next Departure from:")
            Text(entry.dummy)
            Text(entry.date, style: .time)
        }
    }
}

@main
struct NextDepartureWatchWidget: Widget {
    let kind: String = "NextDepartureWatchWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            NextDepartureWatchWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct NextDepartureWatchWidget_Previews: PreviewProvider {
    static var previews: some View {
        NextDepartureWatchWidgetEntryView(entry: .init(direction: .inbound, plannedDeparture: Date(), delay: 5, isCancelled: true, dummy: "preview"))
            .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
    }
}
