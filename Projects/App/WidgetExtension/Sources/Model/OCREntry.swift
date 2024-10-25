import WidgetKit

struct OCREntry: TimelineEntry {
  let date: Date
}

struct OCRProvider: TimelineProvider {
  func placeholder(in context: Context) -> OCREntry {
    OCREntry(date: Date())
  }
  
  func getSnapshot(in context: Context, completion: @escaping (OCREntry) -> ()) {
    let entry = OCREntry(date: Date())
    completion(entry)
  }
  
  func getTimeline(in context: Context, completion: @escaping (Timeline<OCREntry>) -> ()) {
    let timeline = Timeline(entries: [OCREntry(date: .now)], policy: .never)
    completion(timeline)
  }
}
