import SwiftUI

import DesignSystem

// 2 * 2 위젯인데 소속이 없을경우
struct SmallEmptyAgencyView: View {
  var body: some View {
    VStack {
      Image(uiImage: Images.mongLedgerWidgetMini!)
      VStack {
        (
          Text("회비 관리할 ").foregroundColor(.white) +
          Text("장부").foregroundColor(Color(uiColor: Colors.Blue._4)) +
          Text("를").foregroundColor(.white)
        )
        .font(.system(size: 16, weight: .bold))
        Text("만들어주세요!")
          .foregroundStyle(.white)
          .font(.system(size: 16, weight: .bold))
      }
    }
    .widgetBackground(GradientBackgroundView())
  }
}
