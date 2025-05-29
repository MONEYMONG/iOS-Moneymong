import WidgetKit
import SwiftUI

import DesignSystem

struct SecondWidget: Widget {
  private let kind: String = "SecondWidget"
  
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: AgencyProvider()) { entry in
      if entry.name.isEmpty {
        EmptyAgencyView()
      } else {
        SecondWidgetEntryView(entry: entry)
      }
    }
    .supportedFamilies([.systemMedium])
    .configurationDisplayName("내 장부")
    .description("장부에 돈이 얼마 남앗는지 바로 확인할 수 있어요")
  }
}

struct SecondWidgetEntryView: View {
  var entry: AgencyProvider.Entry
  
  var body: some View {
    VStack {
      HStack(alignment: .top, spacing: 0) {
        VStack(alignment: .leading, spacing: 4) {
          Text("\(entry.name)에 이만큼 남았어요")
            .font(.system(size: 12, weight: .semibold))
            .foregroundColor(Color(uiColor: Colors.Gray._6))
            .frame(height: 18)
            
          Text("\(entry.amount)원")
            .font(.system(size: 28, weight: .bold))
            .foregroundColor(Color(uiColor: Colors.Gray._10))
            .frame(height: 26)
        }
        
        Spacer()
        
        Image(uiImage: Images.mongLedger!)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 98)
          .offset(y: -10)
      }

      HStack(spacing: 10) {        
        Link(destination: LinkManager.ledgerDetail.url) {
          Text("회비 내역 확인")
            .font(.system(size: 12, weight: .bold))
            .foregroundColor(Color(uiColor: Colors.Blue._4))
            .frame(height: 18)
            .frame(maxWidth: .infinity)
            .padding(10)
            .background(Color(uiColor: Colors.Blue._1))
            .cornerRadius(10)
        }
      }
    }
    .padding(.horizontal, 10)
    .padding(.vertical, 20)
    .widgetBackground(Color(uiColor: Colors.Gray._1))
  }
}
