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
        .init(
            direction: .outbound,
            plannedDeparture: nil,
            startStationName: "origin",
            destinationStationName: "destination",
            delay: nil,
            isCancelled: false
        )
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (NextDepartureTimelineEntry) -> ()) {
        completion(
            .init(
                direction: .outbound,
                plannedDeparture: nil,
                startStationName: "origin",
                destinationStationName: "destination",
                delay: nil,
                isCancelled: false
            )
        )
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let userDefaultsSuite = UserDefaults(suiteName: "group.rhein.me.wannVerbindung")!
        let homestation = userDefaultsSuite.integer(forKey: "homeStationCode")
        let workstation = userDefaultsSuite.integer(forKey: "workStationCode")
        let timelineReloadpolicy = TimelineReloadPolicy.after(Calendar.current.date(byAdding: .minute, value: 1, to: Date())!)
        Task {
            let timeline: Timeline<NextDepartureTimelineEntry>
            do {
                let journeySearchResult = try await TransportService().getJourneys(from: homestation, to: workstation)
                // TODO: currently only journey with one leg (no transfer) are supported
                // A more fitting data model should be introduced
                let nextJourneyLeg = journeySearchResult.journeys.first!.legs.first!

                // TODO: currently only one timeline entry is created and refreshed after one minute.
                // To save resources and to make the widget more reliable, more timeline entries for future
                // connections should be added
                timeline = Timeline(
                    entries: [
                        NextDepartureTimelineEntry(
                            direction: .outbound,
                            plannedDeparture: nextJourneyLeg.plannedDeparture,
                            startStationName: nextJourneyLeg.origin.name,
                            destinationStationName: nextJourneyLeg.destination.name,
                            delay: nextJourneyLeg.departureDelay,
                            isCancelled: nextJourneyLeg.cancelled ?? false
                        )
                    ],
                    policy: timelineReloadpolicy
                )
            } catch let error {
                timeline = Timeline(
                    entries: [
                        NextDepartureTimelineEntry(
                            direction: .outbound,
                            plannedDeparture: nil,
                            startStationName: "\(homestation)",
                            destinationStationName: "\(workstation)",
                            delay: nil,
                            isCancelled: true
                        )
                    ],
                    policy: timelineReloadpolicy
                )
            }

            completion(timeline)
        }
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
            Text("Next Departure from \(entry.startStationName) to \(entry.destinationStationName):")
                .multilineTextAlignment(.center)
            if
                let plannedDeparture = entry.plannedDeparture,
                !entry.isCancelled
            {
                Text(plannedDeparture, style: .time)
            } else {
                Text("⚠️")
            }
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
        NextDepartureIPhoneWidgetEntryView(
            entry: .init(
                direction: .outbound,
                plannedDeparture: nil,
                startStationName: "origin",
                destinationStationName: "destination",
                delay: nil,
                isCancelled: false
            )
        )
        .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
    }
}
