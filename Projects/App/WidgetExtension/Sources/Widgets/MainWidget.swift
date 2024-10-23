import WidgetKit
import SwiftUI

struct MainWidget: Widget {
  private let kind: String = "MainWidget"
  
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: AgencyProvider()) { entry in
      MainWidgetEntryView(entry: entry)
    }
    .supportedFamilies([.systemMedium])
    .configurationDisplayName("My Widget")
    .description("This is an example widget.")
  }
}

struct MainWidgetEntryView: View {
  var entry: AgencyProvider.Entry
  
  
  var body: some View {
    Text(String(entry.amount))
  }
}
