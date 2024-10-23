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
    var entries: [OCREntry] = []
    let currentDate = Date()
    for hourOffset in 0..<5 {
      let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
      let entry = OCREntry(date: entryDate)
      entries.append(entry)
    }
    let timeline = Timeline(entries: entries, policy: .atEnd)
    completion(timeline)
  }
}
