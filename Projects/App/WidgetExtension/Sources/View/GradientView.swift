import SwiftUI

public struct GradientView: View {
  public var body: some View {
    LinearGradient(
      stops: [
        .init(color: Color(uiColor: UIColor(hexString: "8496F9")), location: 0.0),
        .init(color: Color(uiColor: UIColor(hexString: "C6DFFD")), location: 0.36),
        .init(color: Color(uiColor: UIColor(hexString: "E9D8EB")), location: 0.70),
        .init(color: Color(uiColor: UIColor(hexString: "C6DFFD")), location: 1.0)
      ],
      startPoint: .leading,
      endPoint: .trailing
    )
  }
}
