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
    func placeholder(in context: Context) -> NextDepartureEntry {
        NextDepartureEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (NextDepartureEntry) -> ()) {
        let entry = NextDepartureEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let currentDate = Date()
        let entry = NextDepartureEntry(date: currentDate, configuration: configuration)
        let nextTimelineDate = Calendar.current.date(byAdding: .minute, value: 1, to: currentDate)!
        let timeline = Timeline(entries: [entry], policy: .after(nextTimelineDate))

        completion(timeline)
    }
}

struct NextDepartureEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct NextDepartureIPhoneWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        Text(entry.date, style: .time)
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
        NextDepartureIPhoneWidgetEntryView(entry: NextDepartureEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
    }
}
