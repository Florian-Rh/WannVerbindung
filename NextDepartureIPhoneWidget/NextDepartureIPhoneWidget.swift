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
        let homestation = UserDefaults(suiteName: "group.rhein.me.wannVerbindung")?.string(forKey: "homeStation") ?? "unset"

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
            policy: .after(Calendar.current.date(byAdding: .minute, value: 1, to: Date())!)
        )

        completion(timeline)
    }

    func recommendations() -> [IntentRecommendation<ConfigurationIntent>] {
        return [
            IntentRecommendation(intent: ConfigurationIntent(), description: "My Intent Widget")
        ]
    }
}

struct NextDepartureIPhoneWidgetEntryView : View {
    var entry: NextDepartureTimelineEntry

    var body: some View {
        VStack {
            Text("Next Departure from \(entry.dummy):")
                .multilineTextAlignment(.center)
            Text(entry.plannedDeparture, style: .time)
        }
    }
}

struct NextDepartureIPhoneWidget: Widget {
    let kind: String = "NextDepartureIPhoneWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            NextDepartureIPhoneWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.accessoryRectangular, .accessoryInline])
    }
}

struct NextDepartureIPhoneWidget_Previews: PreviewProvider {
    static var previews: some View {
        NextDepartureIPhoneWidgetEntryView(entry: .init(direction: .inbound, plannedDeparture: Date(), delay: 5, isCancelled: true, dummy: "preview"))
            .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
    }
}
