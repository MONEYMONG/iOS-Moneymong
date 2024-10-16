import WidgetKit
import SwiftUI

struct SecondWidget: Widget {
  let kind: String = "SecondWidget"
  
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: SecondProvider()) { entry in
      SecondWidgetEntryView(entry: entry)
    }
    .supportedFamilies([.systemMedium])
    .configurationDisplayName("My Widget")
    .description("This is an example widget.")
  }
}

struct SecondWidgetEntryView: View {
  var entry: SecondProvider.Entry
  
  var body: some View {
    Text(entry.date, style: .time)
  }
}

struct SecondSimpleEntry: TimelineEntry {
  let date: Date
}

struct SecondProvider: TimelineProvider {
  func placeholder(in context: Context) -> SecondSimpleEntry {
    SecondSimpleEntry(date: Date())
  }
  
  func getSnapshot(in context: Context, completion: @escaping (SecondSimpleEntry) -> ()) {
    let entry = SecondSimpleEntry(date: Date())
    completion(entry)
  }
  
  func getTimeline(in context: Context, completion: @escaping (Timeline<SecondSimpleEntry>) -> ()) {
    var entries: [SecondSimpleEntry] = []
    let currentDate = Date()
    for hourOffset in 0..<5 {
      let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
      let entry = SecondSimpleEntry(date: entryDate)
      entries.append(entry)
    }
    let timeline = Timeline(entries: entries, policy: .atEnd)
    completion(timeline)
  }
}
