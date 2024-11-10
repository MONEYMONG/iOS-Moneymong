import SwiftUI
import WidgetKit

import DesignSystem

// 4 * 2 위젯일때 소속이 없을경우
struct EmptyAgencyView: View {
  var body: some View {
    VStack {
      Image(uiImage: Images.mongLedgerWidget!)
      (
        Text("회비 관리할 ").foregroundColor(.white) +
        Text("장부").foregroundColor(Color(uiColor: Colors.Blue._4)) +
        Text("를 만들어주세요!").foregroundColor(.white)
      )
      .font(.system(size: 16, weight: .bold))
      
    }
    .widgetBackground(GradientBackgroundView())
  }
}
