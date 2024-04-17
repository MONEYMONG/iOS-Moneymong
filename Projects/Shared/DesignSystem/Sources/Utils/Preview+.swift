import SwiftUI

/**
 ```
 struct MyViewPreview: PreviewProvider{
   static var previews: some View {
     UIViewPreview {
        MyView()
     }.previewLayout(.sizeThatFits)
   }
 }
 ```
 */
public struct UIViewPreview<View: UIView>: UIViewRepresentable {
  let view: View
  
  public init(_ builder: @escaping () -> View) {
    view = builder()
  }
  
  // MARK: - UIViewRepresentable
  
  public func makeUIView(context: Context) -> UIView {
    return view
  }
  
  public func updateUIView(_ view: UIView, context: Context) {
    view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    view.setContentHuggingPriority(.defaultHigh, for: .vertical)
  }
}


public struct UIViewControllerPreView<View: UIViewController>: UIViewControllerRepresentable {
  let view: View
  
  public init(_ builder: @escaping () -> View) {
    view = builder()
  }
  
  // MARK: - UIViewRepresentable
  
  public func makeUIViewController(context: Context) -> UIViewController {
    return view
  }
  
  public func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
}
