import WidgetKit
import SwiftUI
import DesignSystem

struct MainWidget: Widget {
  private let kind: String = "MainWidget"
  
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: AgencyProvider()) { entry in
      if entry.name.isEmpty {
        EmptyAgencyView()
      } else {
        MainWidgetEntryView(entry: entry)
      }
    }
    .supportedFamilies([.systemMedium])
    .configurationDisplayName("회비 내역 등록")
    .description("등록할 회비 내역을 바로 입력할 수 있어요")
  }
}

struct MainWidgetEntryView: View {
  var entry: AgencyProvider.Entry
  
  var body: some View {
    VStack {
      Link(destination: LinkManager.createLedger.url) {
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
        Link(destination: LinkManager.ledgerDetail.url) {
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
    .widgetBackground(Color(uiColor: Colors.Gray._1))
  }
}
