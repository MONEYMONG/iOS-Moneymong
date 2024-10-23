import WidgetKit
import SwiftUI

struct SecondWidget: Widget {
  let kind: String = "SecondWidget"
  
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: AgencyProvider()) { entry in
      SecondWidgetEntryView(entry: entry)
    }
    .supportedFamilies([.systemMedium])
    .configurationDisplayName("My Widget")
    .description("This is an example widget.")
  }
}

struct SecondWidgetEntryView: View {
  var entry: AgencyProvider.Entry
  
  var body: some View {
    Text(entry.date, style: .time)
  }
}
