import UIKit

import DesignSystem
import PinLayout

final class SearchView: UIView {
  
  private let rootConainter = UIView()
  
  let searchBar = UISearchBar()
  let cancelButton: UIButton = {
    let v = UIButton()
    v.setTitle("취소", for: .normal)
    v.setTitleColor(Colors.Black._1, for: .normal)
    v.titleLabel?.font = Fonts.body._2
    v.clipsToBounds = true
    return v
  }()
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
    setupConstraints()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    // placeHolder 설정
    searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
      string: "소속을 검색해보세요",
      attributes: [
        .foregroundColor: Colors.Gray._4,
        .font: Fonts.body._2
      ]
    )
    
    // border 설정
    searchBar.searchTextField.layer.borderColor = Colors.Blue._4.cgColor
    searchBar.searchTextField.layer.cornerRadius = 8
    searchBar.searchTextField.layer.borderWidth = 2
    
    // 기타 설정
    searchBar.tintColor = Colors.Black._1
    searchBar.backgroundImage = UIImage()
    searchBar.searchTextField.backgroundColor = Colors.White._1
    searchBar.searchTextField.clearButtonMode = .always
    searchBar.searchTextField.leftView = nil
    
    if let textField = searchBar.value(forKey: "searchField") as? UITextField {
      textField.leftView?.frame.origin.x = 10  // 왼쪽 여백
      textField.rightView?.frame.origin.x = 10  // 오른쪽 여백
    }
  }
  
  private func setupConstraints() {
    addSubview(rootConainter)
    
    rootConainter.flex.direction(.row).alignItems(.center).define {
      $0.addItem(searchBar).shrink(1)
      $0.addItem(cancelButton).marginLeft(5)
    }
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    rootConainter.pin.all()
    rootConainter.flex.layout()
  }
}
