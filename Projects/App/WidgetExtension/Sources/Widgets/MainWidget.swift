import WidgetKit
import SwiftUI
import DesignSystem

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
    VStack {
      Link(destination: URL(string: "widget://CreateLedger")!) {
        HStack(alignment: .center) {
          Text("\(entry.name)에 오늘 사용한 금액 입력")
            .bold()
            .font(.system(size: 16))
            .foregroundStyle(Color(uiColor: Colors.Gray._6))
            .frame(height: 24)
            .frame(maxWidth: .infinity)
            .padding(.leading, 16)
            .padding(.vertical, 18)
          Image(uiImage: Images.mongCoin!)
            .padding(.trailing, 16)
        }
        .background(Color.white)
        .cornerRadius(12)
      }
      
      Spacer()
      HStack {
        Link(destination: URL(string: "widget://OCR")!) {
          HStack {
            Spacer()
            Text("영수증 스캔")
              .bold()
              .font(.system(size: 16))
              .foregroundStyle(Color(uiColor: Colors.Gray._5))
            Spacer()
          }
        }
        
        Divider()
          .background(Color(uiColor: Colors.Gray._5))
        Link(destination: URL(string: "widget://LedgerDetail")!) {
          HStack {
            Spacer()
            Text("회비 내역 확인")
              .bold()
              .font(.system(size: 16))
              .foregroundStyle(Color(uiColor: Colors.Gray._5))
            Spacer()
          }
        }
      }
      .frame(height: 24)
      Spacer()
    }
    .containerBackground(for: .widget) {
      Color(uiColor: Colors.Gray._1)
    }
  }
}

#Preview(as: .systemMedium, widget: {
  MainWidget()
}, timeline: {
  AgencyEntry(date: .now, name: "머니몽", amount: 1000)
})
