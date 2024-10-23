import WidgetKit

struct AgencyEntry: TimelineEntry {
  let date: Date
  let name: String
  let amount: Int
}

struct AgencyProvider: TimelineProvider {
  func placeholder(in context: Context) -> AgencyEntry {
    AgencyEntry(
      date: Date(),
      name: "머니몽 대학",
      amount: 10000
    )
  }
  
  func getSnapshot(in context: Context, completion: @escaping (AgencyEntry) -> ()) {
    let entry = AgencyEntry(
      date: Date(),
      name: "머니몽 대학",
      amount: 10000
    )
    completion(entry)
  }
  
  func getTimeline(in context: Context, completion: @escaping (Timeline<AgencyEntry>) -> ()) {
    let entry: AgencyEntry
    if let dic = UserDefaults(suiteName: "group.moneymong")?.dictionary(forKey: "test"),
       let name = dic["name"] as? String,
       let amount = dic["total"] as? Int {
     
      entry = AgencyEntry(
        date: .now,
        name: name,
        amount: amount
      )
      
    } else {
      entry = AgencyEntry(
        date: .now,
        name: "",
        amount: 0
      )
    }
    let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: .now)
    let timeline = Timeline(entries: [entry], policy: .after(nextUpdate!))
    completion(timeline)
  }
}
