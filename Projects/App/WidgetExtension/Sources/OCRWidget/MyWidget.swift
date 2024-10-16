import WidgetKit
import SwiftUI

struct OCRWidget: Widget {
  let kind: String = "OCRWidget"
  
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: OCRProvider()) { entry in
      OCRWidgetEntryView(entry: entry)
    }
    .supportedFamilies([.systemSmall])
    .configurationDisplayName("My Widget")
    .description("This is an example widget.")
  }
}

struct OCRWidgetEntryView: View {
  var entry: OCRProvider.Entry
  
  var body: some View {
    Text(entry.date, style: .time)
  }
}

struct OCRSimpleEntry: TimelineEntry {
  let date: Date
}

struct OCRProvider: TimelineProvider {
  func placeholder(in context: Context) -> OCRSimpleEntry {
    OCRSimpleEntry(date: Date())
  }
  
  func getSnapshot(in context: Context, completion: @escaping (OCRSimpleEntry) -> ()) {
    let entry = OCRSimpleEntry(date: Date())
    completion(entry)
  }
  
  func getTimeline(in context: Context, completion: @escaping (Timeline<OCRSimpleEntry>) -> ()) {
    var entries: [OCRSimpleEntry] = []
    let currentDate = Date()
    for hourOffset in 0..<5 {
      let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
      let entry = OCRSimpleEntry(date: entryDate)
      entries.append(entry)
    }
    let timeline = Timeline(entries: entries, policy: .atEnd)
    completion(timeline)
  }
}
