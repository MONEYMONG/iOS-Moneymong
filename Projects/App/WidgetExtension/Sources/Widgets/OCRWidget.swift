import WidgetKit
import SwiftUI

import DesignSystem

struct OCRWidget: Widget {
  let kind: String = "OCRWidget"
  
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: OCRProvider()) { entry in
      OCRWidgetEntryView()
    }
    .supportedFamilies([.systemSmall])
    .configurationDisplayName("영수증 스캔")
    .description("영수증을 스캔해서 바로 장부에 등록해보세요")
  }
}

struct OCRWidgetEntryView: View {
  var body: some View {
    VStack {
      if let image = Images.scanCircle {
        Image(uiImage: image)
          .resizable()
          .frame(width: 80, height: 80)
      }
      
      Spacer()

      Text("영수증 스캔하기")
        .foregroundColor(Color(uiColor: Colors.Gray._8))
        .font(.system(size: 16, weight: .bold))
    }
    .padding(.vertical, 20)
    .widgetURL(URL(string: "widget://OCR"))
    .containerBackground(for: .widget) {
      Color.white
    }
  }
}
