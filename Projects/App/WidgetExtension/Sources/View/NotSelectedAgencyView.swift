import SwiftUI
import WidgetKit

import DesignSystem

struct NotSelectedAgencyView: View {
  var body: some View {
    VStack {
      Image(uiImage: Images.mongLedgerWidget!)
      (
        Text("회비 관리할 ").foregroundStyle(.white) +
        Text("장부").foregroundStyle(Color(uiColor: Colors.Blue._4)) +
        Text("를 만들어주세요!").foregroundStyle(.white)
      )
      .font(.system(size: 16, weight: .bold))
      
    }
    .containerBackground(for: .widget) {
      GradientView()
    }
  }
}
