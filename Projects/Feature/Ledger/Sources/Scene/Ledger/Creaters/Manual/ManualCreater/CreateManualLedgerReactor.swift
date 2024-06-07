import Foundation
import UIKit

import NetworkService
import BaseFeature

import ReactorKit

final class CreateManualLedgerReactor: Reactor {
  enum `Type` {
    case operatingCost // 운영비 등록화면
    case ocrResultEdit(OCRResult, Data) // ocr 결과 수정화면
    case createManual
  }
  
  enum ContentType {
    case source
    case amount
    case fundType
    case date
    case time
    case memo
  }
  
  enum AlertType {
    case error(MoneyMongError)
    case deleteImage(ImageData.Item, Section)
    case end
  }

  enum Section: Int, Equatable {
    case receipt
    case document
  }
  
  enum Action {
    case onAppear
    case didTapCompleteButton
    case presentedAlert(AlertType)
    case didTapImageDeleteAlertButton(ImageData.Item, Section)
    case didTapImageAddButton(Section)
    case selectedImage(ImageData.Item, Section)
    case inputContent(_ value: String, type: ContentType)
  }
  
  enum Mutation {
    case setOperatingCostValues // 동아리 운영비 등록하러 가기 일때의 고정값
    case setName(String)
    case addImage(ImageData.Item, Section)
    case deleteImage(UUID, Section)
    case deleteImageURL(Int, Section)
    case setContent(String, type: ContentType)
    case setSection(Section)
    case addImageURL(ImageInfo, Section)
    case setDestination
    case setAlertContent(AlertType)
    case setOCRResult(OCRResult)
  }
  
  struct State {
    let agencyId: Int
    let type: `Type`
    @Pulse var userName: String = ""
    @Pulse var receiptImages: [ImageData.Item] = [.button]
    @Pulse var documentImages: [ImageData.Item] = [.button]
    @Pulse var selectedSection: Section? = nil
    @Pulse var alertMessage: (String, String?, AlertType)? = nil
    @Pulse var isButtonEnabled = false
    @Pulse var destination: Destination?
    var content = Content()
    
    enum Destination {
      case ledger
    }
  }
  
  struct Content {
    @Pulse var source: String = ""
    @Pulse var amount: String = ""
    @Pulse var fundType: Int = -1
    @Pulse var date: String = ""
    @Pulse var time: String = ""
    @Pulse var memo: String = ""
    @Pulse var receiptImages = [ImageInfo]()
    @Pulse var documentImages = [ImageInfo]()
  }
  
  let initialState: State
  private let service: LedgerServiceInterface
  private let ledgerRepo: LedgerRepositoryInterface
  private let userRepo: UserRepositoryInterface
  private let formatter: ContentFormatter
  
  init(
    agencyId: Int,
    type: `Type`,
    ledgerRepo: LedgerRepositoryInterface,
    userRepo: UserRepositoryInterface,
    ledgerService: LedgerServiceInterface,
    formatter: ContentFormatter
  ) {
    self.ledgerRepo = ledgerRepo
    self.userRepo = userRepo
    self.service = ledgerService
    self.formatter = formatter
    self.initialState = State(agencyId: agencyId, type: type)
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .onAppear:
      switch currentState.type {
      case .operatingCost:
        return .merge(
          .task { try await userRepo.user().nickname }
            .map { .setName($0) },
          .just(.setOperatingCostValues)
        )
      case .createManual:
        return .task { try await userRepo.user().nickname }
          .map { .setName($0) }
      case let .ocrResultEdit(model, imageData):
        let image = ImageData(id: .init(), data: imageData)
        return .merge([
          .task { try await userRepo.user().nickname }.map { .setName($0) },
          uploadImage(image: image, section: .receipt),
          .just(.setOCRResult(model))
        ])
      }
      
    case let .selectedImage(item, section):
      guard case let .image(image) = item else { return .empty() }
      return uploadImage(image: image, section: section)
      .catch { .just(.setAlertContent(.error($0.toMMError))) }
    case .presentedAlert(let type):
        return .just(.setAlertContent(type))
    case let .didTapImageDeleteAlertButton(item, section):
      guard case let .image(image) = item else { return .empty() }
      return .task {
        var index: Int?
        let imageURL: ImageInfo
        switch section {
        case .receipt:
          index = currentState.content.receiptImages.firstIndex(where: {
            $0.id == image.id
          })
          guard let index else { throw MoneyMongError.appError(errorMessage: "이미지 삭제가 정상적으로 이뤄지지 않았습니다") }
          imageURL = currentState.content.receiptImages[index]
        case .document:
          index = currentState.content.documentImages.firstIndex(where: {
            $0.id == image.id
          })
          guard let index else { throw MoneyMongError.appError(errorMessage: "이미지 삭제가 정상적으로 이뤄지지 않았습니다") }
          imageURL = currentState.content.documentImages[index]
        }
        try await ledgerRepo.imageDelete(imageURL)
        return index!
      }
      .flatMap { Observable<Mutation>.concat([
        .just(.deleteImage(image.id, section)),
        .just(.deleteImageURL($0, section))
      ]) }
      .catch { .just(.setAlertContent(.error($0.toMMError))) }
    case .didTapImageAddButton(let section):
      return .just(.setSection(section))
    case .inputContent(let value, let type):
      return .just(.setContent(value, type: type))
    case .didTapCompleteButton:
      return .concat([
        requestCreateLedgerRecord(),
        service.ledgerList.createLedgerRecord().flatMap { _ in
          Observable<Mutation>.empty()
        }
      ])
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    newState.alertMessage = nil
    switch mutation {
    case .setOperatingCostValues:
      newState.content.source = "동아리 운영비"
      newState.content.date = formatter.convertToDate(date: .now)
      newState.content.time = formatter.convertToTime(date: .now)
      newState.content.fundType = 1
    case let .setName(name):
      newState.userName = name
      
    case let .addImage(item, section):
      switch section {
      case .receipt:
        addImage(images: &newState.receiptImages, item: item)
      case .document:
        addImage(images: &newState.documentImages, item: item)
      }
    case .deleteImage(let id, let section):
      switch section {
      case .receipt:
        deleteImage(images: &newState.receiptImages, id: id)
      case .document:
        deleteImage(images: &newState.documentImages, id: id)
      }
    case .setSection(let section):
      newState.selectedSection = section
    case .setContent(let value, let type):
      setContent(&newState.content, value: value, type: type)
      newState.isButtonEnabled = checkContent(newState.content)
    case .setDestination:
      newState.destination = .ledger
    case .addImageURL(let imageURL, let section):
      switch section {
      case .receipt:
        newState.content.receiptImages.append(imageURL)
      case .document:
        newState.content.documentImages.append(imageURL)
      }
    case .deleteImageURL(let index, let section):
      switch section {
      case .receipt:
        newState.content.receiptImages.remove(at: index)
      case .document:
        newState.content.documentImages.remove(at: index)
      }
    case .setAlertContent(let type):
      switch type {
      case .error(let moneyMongError):
        newState.alertMessage = (moneyMongError.errorDescription!, nil, type)
      case .deleteImage:
        newState.alertMessage = ("사진을 삭제하시겠습니까?", "삭제된 사진은 되돌릴 수 없습니다", type)
      case .end:
        newState.alertMessage = ("정말 나가시겠습니까?", "작성한 내용이 저장되지 않았습니다", type)
      }
    case let .setOCRResult(model):
      newState.content.source = model.source
      newState.content.amount = model.amount
      newState.content.date = model.date.joined(separator: "/")
      newState.content.time = model.time.joined(separator: ":")
      newState.content.fundType = 0
    }
    return newState
  }
}

private extension CreateManualLedgerReactor {
  func addImage(images: inout [ImageData.Item], item: ImageData.Item) {
    images.append(item)
    if images.count > 12 {
      images.removeFirst()
    }
  }
  
  func deleteImage(images: inout [ImageData.Item], id: UUID) {
    images.removeAll {
      guard case let .image(image) = $0 else { return false }
      return image.id == id
    }
    if !images.contains(.button) {
      images.insert(.button, at: 0)
    }
  }
  
  func setContent(_ content: inout Content, value: String, type: ContentType) {
    switch type {
    case .source:
      content.source = value
    case .amount:
      content.amount = formatter.convertToAmount(with: value) ?? ""
    case .fundType:
      content.fundType = Int(value)!
    case .date:
      content.date = formatter.convertToDate(with: value)
    case .time:
      content.time = formatter.convertToTime(with: value)
    case .memo:
      content.memo = value
    }
  }
  
  func checkContent(_ content: Content) -> Bool {
    // source
    guard content.source.isEmpty == false,
          content.source.count <= 20
    else {
      return false
    }
    
    // amount
    guard content.amount.isEmpty == false,
          let amount = Int(content.amount.replacingOccurrences(of: ",", with: "")),
          amount <= 999_999_999
    else {
      return false
    }

    // fund
    guard content.fundType == 1 || content.fundType == 0 else {
      return false
    }
    
    var pattern: String
    var value: String
    var regex: NSRegularExpression
    var result: NSTextCheckingResult?
    
    // date
    pattern = "^\\d{4}/(0[1-9]|1[012])/(0[1-9]|[12]\\d|3[01])$"
    value = content.date
    regex = try! NSRegularExpression(pattern: pattern)
    result = regex.firstMatch(in: value, range: NSRange(location: 0, length: value.count))
    guard result != nil else { return false }
    
    // time
    pattern = "^([01]?[0-9]|2[0-3]):[0-5][0-9](:[0-5][0-9])?$"
    value = content.time
    regex = try! NSRegularExpression(pattern: pattern)
    result = regex.firstMatch(in: value, range: NSRange(location: 0, length: value.count))
    guard result != nil else { return false }

    // memo
    guard content.memo.count <= 300
    else {
      return false
    }
    
    return true
  }
  
  func requestCreateLedgerRecord() -> Observable<Mutation> {
    return .task {
      guard let amount = Int(currentState.content.amount.filter { $0.isNumber }) else {
        throw MoneyMongError.appError(errorMessage: "금액을 확인해 주세요")
      }
      guard let date = formatter.mergeWithISO8601(
        date: currentState.content.date,
        time: currentState.content.time
      )
      else {
        throw MoneyMongError.appError(errorMessage: "날짜 및 시간을 확인해 주세요")
      }
      let memo = currentState.content.memo.isEmpty ? "내용없음" : currentState.content.memo
      return try await ledgerRepo.create(
        id: currentState.agencyId,
        storeInfo: currentState.content.source,
        fundType: currentState.content.fundType == 1 ? .income : .expense,
        amount: amount,
        description: memo,
        paymentDate: date,
        receiptImageUrls: currentState.content.receiptImages.map(\.url),
        documentImageUrls: currentState.content.documentImages.map(\.url)
      )}
      .map { .setDestination }
      .catch {
        return .just(.setAlertContent(.error($0.toMMError)))
      }
  }
  
  func uploadImage(image: ImageData, section: Section) -> Observable<Mutation> {
    return .task {
      guard let resizeImateData = UIImage(data: image.data)?.jpegData(compressionQuality: 0.027) else {
        throw MoneyMongError.appError(errorMessage: "첨부 이미지를 확인해 주세요")
      }
      var entity = try await ledgerRepo.imageUpload(resizeImateData)
      entity.id = image.id
      return entity
    }
    .flatMap { Observable<Mutation>.merge([
      .just(.addImage(.image(image), section)),
      .just(.addImageURL($0, section))
    ])}
    .catch {
      return .just(.setAlertContent(.error($0.toMMError)))
    }
  }
}
