import SwiftUI

import DesignSystem

struct MiniNotSelectedAgencyView: View {
  var body: some View {
    VStack {
      Image(uiImage: Images.mongLedgerWidgetMini!)
      VStack {
        (
          Text("회비 관리할 ").foregroundStyle(.white) +
          Text("장부").foregroundStyle(Color(uiColor: Colors.Blue._4)) +
          Text("를").foregroundStyle(.white)
        )
        .font(.system(size: 16, weight: .bold))
        Text("만들어주세요!")
          .foregroundStyle(.white)
          .font(.system(size: 16, weight: .bold))
      }
    }
    .containerBackground(for: .widget) {
      GradientView()
    }
  }
}
