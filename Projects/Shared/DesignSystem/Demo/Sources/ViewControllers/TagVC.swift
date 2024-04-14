import UIKit

import DesignSystem

final class TagVC: UIViewController {
  
  private let tag1 = TagView()
  private let tag2 = TagView()
  private let tag3 = TagView()
  private let tag4 = TagView()
  private let tag5 = TagView()
  private let tag6 = TagView()
  private let tag7 = TagView()
  private let tag8 = TagView()
  
  private let rootContainer = UIView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupView()
    setupConstraints()
  }
  
  private func setupView() {
    view.backgroundColor = .white
    title = "Tags"
    tag1.configure(title: "동아리", titleColor: Colors.White._1, backgroundColor: Colors.Blue._4)
    tag2.configure(title: "감사위원회", titleColor: Colors.White._1, backgroundColor: Colors.Mint._3)
    tag3.configure(title: "학생회", titleColor: Colors.White._1, backgroundColor: Colors.Red._3)
    tag4.configure(title: "일반맴버", titleColor: Colors.White._1, backgroundColor: Colors.Gray._7)
    tag5.configure(title: "운영진", titleColor: Colors.Blue._4, backgroundColor: Colors.Blue._1)
    tag6.configure(title: "dudu", titleColor: Colors.Mint._3, backgroundColor: Colors.Mint._1)
    tag7.configure(title: "safari", titleColor: Colors.Red._3, backgroundColor: Colors.Red._1)
    tag8.configure(title: "malrang", titleColor: Colors.Gray._5, backgroundColor: Colors.Gray._2)
  }
  
  private func setupConstraints() {
    view.addSubview(rootContainer)
    
    rootContainer.flex.direction(.column).justifyContent(.center).define { flex in
      flex.addItem().direction(.row).justifyContent(.spaceBetween).define { flex in
        flex.addItem(tag1)
        flex.addItem(tag2)
        flex.addItem(tag3)
        flex.addItem(tag4)
      }
      .marginBottom(10)
      
      flex.addItem().direction(.row).justifyContent(.spaceBetween).define { flex in
        flex.addItem(tag5)
        flex.addItem(tag6)
        flex.addItem(tag7)
        flex.addItem(tag8)
      }
    }
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    rootContainer.pin.top().bottom().horizontally(50)
    rootContainer.flex.layout()
  }
}
