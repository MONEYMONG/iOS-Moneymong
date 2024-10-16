import WidgetKit
import SwiftUI

struct MainWidget: Widget {
  let kind: String = "MainWidget"
  
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: MainProvider()) { entry in
      MainWidgetEntryView(entry: entry)
    }
    .supportedFamilies([.systemMedium])
    .configurationDisplayName("My Widget")
    .description("This is an example widget.")
  }
}

struct MainWidgetEntryView: View {
  var entry: MainProvider.Entry
  
  var body: some View {
    Text(entry.date, style: .time)
  }
}

struct MainSimpleEntry: TimelineEntry {
  let date: Date
}

struct MainProvider: TimelineProvider {
  func placeholder(in context: Context) -> MainSimpleEntry {
    MainSimpleEntry(date: Date())
  }
  
  func getSnapshot(in context: Context, completion: @escaping (MainSimpleEntry) -> ()) {
    let entry = MainSimpleEntry(date: Date())
    completion(entry)
  }
  
  func getTimeline(in context: Context, completion: @escaping (Timeline<MainSimpleEntry>) -> ()) {
    var entries: [MainSimpleEntry] = []
    let currentDate = Date()
    for hourOffset in 0..<5 {
      let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
      let entry = MainSimpleEntry(date: entryDate)
      entries.append(entry)
    }
    let timeline = Timeline(entries: entries, policy: .atEnd)
    completion(timeline)
  }
}
