//
//  TaskWidget.swift
//  TaskWidget
//
//  Created by Daria Eremina on 28.02.2021.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(dueDate: "01.03.2021\n23:59", heading: "Here will be your nearest task", configuration: ConfigurationIntent())
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), dueDate: "01.03.2021\n23:59", heading: "Here will be your nearest task", configuration: configuration)
        completion(entry)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        let userDefaults = UserDefaults(suiteName: "group.taskTrackerApp")
        let heading = userDefaults?.value(forKey: "heading") ?? "Here will be your nearest task"
        let date = userDefaults?.value(forKey: "date") ?? ""
        let entry = SimpleEntry(dueDate: date as! String, heading: heading as! String, configuration: configuration)
        entries.append(entry)
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    var date: Date = Date()
    let dueDate: String
    let heading: String
    let configuration: ConfigurationIntent
}

struct TaskWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image("clock")
                    .resizable()
                    .frame(width: 50, height: 50)
                
                Text(entry.dueDate)
                    .font(Font.system(size: 16, weight: .semibold, design: .default))
                    .foregroundColor(Color.black)
            }
            Text(entry.heading)
                .font(Font.system(size: 18, weight: .semibold, design: .default))
                .foregroundColor(Color.gray)
        }
    }
}

@main
struct TaskWidget: Widget {
    let kind: String = "TaskWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            TaskWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct TaskWidget_Previews: PreviewProvider {
    static var previews: some View {
        TaskWidgetEntryView(entry: SimpleEntry(dueDate: "01.03.2021\n23:59", heading: "Here will be your nearest task", configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
