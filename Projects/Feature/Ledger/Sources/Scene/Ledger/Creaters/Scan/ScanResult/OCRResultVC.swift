import UIKit

import DesignSystem
import BaseFeature

import ReactorKit
import PinLayout
import FlexLayout

final class OCRResultVC: BaseVC, View {
  var disposeBag = DisposeBag()
  weak var coordinator: CreateOCRLedgerCoordinator?
  
  private let receiptImageView: UIImageView = {
    let v = UIImageView()
    v.contentMode = .scaleAspectFill
    v.clipsToBounds = true
    return v
  }()
  
  private let gradationView: GradationView = {
    let v = GradationView()
    v.setGradation(
      colors: [
        UIColor.black.cgColor,
        UIColor.black.withAlphaComponent(0.0).cgColor
      ],
      location: [0.0]
    )
    return v
  }()
  
  private let sourceLabel = UILabel().text(
    "출처",
    font: Fonts.body._3,
    color: Colors.Gray._8
  )
  
  private let moneyLabel = UILabel().text(
    "1,800원",
    font: Fonts.body._3,
    color: Colors.Gray._8
  )
  
  private let dateLabel = UILabel().text(
    "2023년 11월 15일",
    font: Fonts.body._3,
    color: Colors.Gray._8
  )
  
  private let timeLabel = UILabel().text(
    "14:02:11",
    font: Fonts.body._3,
    color: Colors.Gray._8
  )
  
  private let retryView: UIView = {
    let v = UIView()
    v.backgroundColor = Colors.Gray._7
    v.layer.cornerRadius = 20
    return v
  }()
  
  private let editButton = MMButton(title: "수정하기", type: .secondary)
  private let completeButton = MMButton(title: "등록하기", type: .primary)
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    receiptImageView.pin.all()
    rootContainer.pin.all()
    rootContainer.flex.layout()
  }
  
  override func setupUI() {
    super.setupUI()
    setTitle("스캔결과", color: .white)
  }
  
  override func setupConstraints() {
    view.addSubview(receiptImageView)
    super.setupConstraints()
    
    rootContainer.flex.define { flex in
      flex.addItem(gradationView).height(100)
      flex.addItem().grow(1)
      flex.addItem().define { flex in
        flex.addItem(retryView).direction(.row).define { flex in
          flex.addItem(UIImageView(image: Images.scan)).marginLeft(6)
          flex.addItem(UILabel().text("다시 찍기", font: Fonts.body._4, color: .white))
        }.width(131).height(40).justifyContent(.center).alignItems(.center)
      }.alignItems(.center).marginBottom(16)
      flex.addItem().define { flex in
        flex.addItem().define { flex in
          flex.addItem().direction(.row).define { flex in
            flex.addItem(UIImageView(image: Images.agencyLineBlue))
              .marginRight(8)
            flex.addItem(
              UILabel().text("수입·지출 출처: ", font: Fonts.body._3, color: Colors.Gray._6)
            )
            flex.addItem(sourceLabel)
          }.marginBottom(14)
          flex.addItem().direction(.row).define { flex in
            flex.addItem(UIImageView(image: Images.moneyLineBlue))
              .marginRight(8)
            flex.addItem(
              UILabel().text("금액: ", font: Fonts.body._3, color: Colors.Gray._6)
            )
            flex.addItem(moneyLabel)
          }.marginBottom(14)
          flex.addItem().direction(.row).define { flex in
            flex.addItem(UIImageView(image: Images.planLineBlue))
              .marginRight(8)
            flex.addItem(
              UILabel().text("날짜: ", font: Fonts.body._3, color: Colors.Gray._6)
            )
            flex.addItem(dateLabel)
          }.marginBottom(14)
          flex.addItem().direction(.row).define { flex in
            flex.addItem(UIImageView(image: Images.timeLineBlue))
              .marginRight(8)
            flex.addItem(
              UILabel().text("시간: ", font: Fonts.body._3, color: Colors.Gray._6)
            )
            flex.addItem(timeLabel)
          }.marginBottom(16)
          flex.addItem().direction(.row).define { flex in
            flex.addItem(editButton)
              .height(52).marginRight(10).width(50%)
            flex.addItem(completeButton)
              .height(52).width(50%)
          }.marginBottom(34)
        }.padding(20)
      }.backgroundColor(.white).cornerRadius(20)
    }
  }
  
  func bind(reactor: OCRResultReactor) {
    setLeftItem(.backWhite)
    setRightItem(.closeWhite)
    
    navigationItem.leftBarButtonItem?.rx.tap
      .bind(with: self) { owner, _ in
        owner.navigationController?.popViewController(animated: true)
      }
      .disposed(by: disposeBag)
    
    navigationItem.rightBarButtonItem?.rx.tap
      .bind(with: self) { owner, _ in
        owner.dismiss(animated: true)
      }
      .disposed(by: disposeBag)
    
    rx.viewWillAppear
      .map { Reactor.Action.onAppear }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    retryView.rx.tapGesture
      .bind(with: self) { owner, _ in
        owner.navigationController?.popViewController(animated: true)
      }
      .disposed(by: disposeBag)
    
    completeButton.rx.tap
      .map { Reactor.Action.didTapCompleteButton }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    editButton.rx.tap
      .map { Reactor.Action.didTapEditButton }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$receiptImageData)
      .map { UIImage(data: $0) }
      .bind(to: receiptImageView.rx.image)
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$source)
      .bind(to: sourceLabel.rx.text)
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$money)
      .bind(to: moneyLabel.rx.text)
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$date)
      .map { "\($0[0])년 \($0[1])월 \($0[2])일" }
      .bind(to: dateLabel.rx.text)
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$time)
      .map { "\($0[0]):\($0[1]):\($0[2])" }
      .bind(to: timeLabel.rx.text)
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$error)
      .observe(on: MainScheduler.instance)
      .compactMap { $0 }
      .bind(with: self) { owner, error in
        owner.coordinator?.present(.alert(title: "오류", subTitle: error.errorDescription, type: .onlyOkButton()))
      }
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$destination)
      .observe(on: MainScheduler.instance)
      .compactMap { $0 }
      .bind(with: self) { owner, destination in
        switch destination {
        case .ledger:
          owner.dismiss(animated: true)
        case let .createManualLedger(agencyID, ocrModel, imageData):
          owner.coordinator?.present(.createManualLedger(agencyID, .ocrResultEdit(ocrModel, imageData)))
        }
      }
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$isSuccess)
      .filter { !$0 }
      .bind(with: self) { owner, _ in
        owner.completeButton.setState(.disable)
        owner.coordinator?.present(.snackBar(title: "일부 내용을 스캔하지 못했습니다"))
      }
      .disposed(by: disposeBag)
  }
}


