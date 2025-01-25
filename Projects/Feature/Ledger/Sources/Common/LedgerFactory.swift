import UIKit

import AgencyInterface
import UserInterface
import LedgerInterface
import BaseFeature
import LedgerFeatureInterface

public struct LedgerFactory: LedgerFactoryInterface {
  private let ledgerService: LedgerServiceInterface
  private let contentFormatter: ContentFormatter
  
  public init(ledgerService: LedgerServiceInterface, contentFormatter: ContentFormatter) {
    self.ledgerService = ledgerService
    self.contentFormatter = contentFormatter
  }
  
  public func makeLedgerMain() -> UIViewController {
    let vc = LedgerVC()
    vc.reactor = LedgerReactor(
      getMyAgencyUseCase: DIContainer.shared.resolve(type: GetMyAgencyUseCaseInterface.self),
      getSelectedAgency: DIContainer.shared.resolve(type: GetSelectedAgencyUseCaseInterface.self),
      updateSelectedAgency: DIContainer.shared.resolve(type: UpdateSelectedAgencyUseCaseInterface.self),
      ledgerService: ledgerService
    )
    return vc
  }
  
  public func makeLedgerTab(navigationController: UINavigationController) -> UIViewController {
    let vc = LedgerTabVC()
    vc.rootNavigationController = navigationController
    vc.reactor = LedgerTabReactor(
      getLedgerDateRangeUseCase: DIContainer.shared.resolve(type: GetLedgerDateRangeUseCaseInterface.self),
      getUserIDUseCase: DIContainer.shared.resolve(type: GetUserIDUseCaseInterface.self),
      saveLedgerDateRangeUseCase: DIContainer.shared.resolve(type: SaveLedgerDateRangeUseCaseInterface.self),
      getLedgerListUseCase: DIContainer.shared.resolve(type: GetLedgerListUseCaseInterface.self),
      getMemberListUseCase: DIContainer.shared.resolve(type: GetMemberListUseCaseInterface.self),
      ledgerService: ledgerService,
      formatter: contentFormatter
    )
    vc.title = "장부"
    return vc
  }
  
  public func makeMemberTab(navigationController: UINavigationController, delegate: MemberTabVCDelegate) -> UIViewController {
    let vc = MemberTabVC()
    vc.rootNavigationController = navigationController
    vc.delegate = delegate
    vc.reactor = MemberTabReactor(
      getUserIDUseCase: DIContainer.shared.resolve(type: GetUserIDUseCaseInterface.self),
      getSelectedAgencyUseCase: DIContainer.shared.resolve(type: GetSelectedAgencyUseCaseInterface.self),
      reissueCodeUseCase: DIContainer.shared.resolve(type: ReissueCodeUseCaseInterface.self),
      kickoutMemberUseCase: DIContainer.shared.resolve(type: KickoutMemberUseCaseInterface.self),
      deleteAgencyUseCase: DIContainer.shared.resolve(type: DeleteAgencyUseCaseInterface.self),
      getMyInfoUseCase: DIContainer.shared.resolve(type: GetMyInfoUseCaseInterface.self),
      getInvitationCodeUseCase: DIContainer.shared.resolve(type: GetInvitationCodeUseCaseInterface.self),
      getMemberListUseCase: DIContainer.shared.resolve(type: GetMemberListUseCaseInterface.self),
      ledgerService: ledgerService
    )
    vc.title = "맴버"
    return vc
  }
  
  public func makeCreateManual(agencyId: Int, type: ManualPresentType) -> UIViewController {
    let vc = CreateManualLedgerVC()
    vc.reactor = CreateManualLedgerReactor(
      agencyId: agencyId,
      type: type,
      getMyInfoUseCase: DIContainer.shared.resolve(type: GetMyInfoUseCaseInterface.self),
      deleteImageUseCase: DIContainer.shared.resolve(type: DeleteImageUseCaseInterface.self),
      createLedgerUseCase: DIContainer.shared.resolve(type: CreateLedgerUseCaseInterface.self),
      uploadImageUseCase: DIContainer.shared.resolve(type: UploadImageUseCaseInterface.self),
      ledgerService: ledgerService,
      formatter: contentFormatter
    )
    return vc
  }
  
  public func makeOCR(agencyId: Int) -> UIViewController {
    let vc = CreateOCRLedgerVC()
    vc.reactor = CreateOCRLedgerReactor(
      agencyId: agencyId,
      receiptOCRUseCase: DIContainer.shared.resolve(type: ReceiptOCRUseCaseInterface.self)
    )
    return vc
  }
  
  public func makeOCRResult(agencyId: Int, model: OCRResult, imageData: Data) -> UIViewController {
    let vc = OCRResultVC()
    vc.reactor = OCRResultReactor(
      agencyId: agencyId,
      model: model,
      imageData: imageData,
      uploadImageUseCase: DIContainer.shared.resolve(type: UploadImageUseCaseInterface.self),
      createLedgerUseCase: DIContainer.shared.resolve(type: CreateLedgerUseCaseInterface.self),
      ledgerService: ledgerService,
      formatter: contentFormatter
    )
    return vc
  }
  
  public func makeDatePicker(start: DateInfo, end: DateInfo) -> UIViewController {
    let vc = DatePickerSheetVC()
    vc.reactor = DatePickerReactor(
      startDate: start,
      endDate: end,
      ledgerService: ledgerService,
      formatter: contentFormatter
    )
    return vc
  }
  
  public func makeEditMember(agencyID: Int, member: Member) -> UIViewController {
    let vc = EditMemberSheetVC()
    vc.reactor = EditMemberReactor(
      agencyID: agencyID,
      member: member,
      changeMemberRoleUseCase: DIContainer.shared.resolve(type: ChangeMemberRoleUseCaseInterface.self),
      ledgerService: ledgerService
    )
    return vc
  }
  
  public func makeSelectAgency() -> UIViewController {
    let vc = SelectAgencySheetVC()
    vc.reactor = SelectAgencySheetReactor(
      getMyAgencyUseCase: DIContainer.shared.resolve(type: GetMyAgencyUseCaseInterface.self),
      updateSelectedAgencyUseCase: DIContainer.shared.resolve(type: UpdateSelectedAgencyUseCaseInterface.self),
      getUserIDUseCase: DIContainer.shared.resolve(type: GetUserIDUseCaseInterface.self),
      getSelectedAgencyUseCase: DIContainer.shared.resolve(type: GetSelectedAgencyUseCaseInterface.self),
      service: ledgerService
    )
    return vc
  }
  
  public func makeDetail(ledgetID: Int, role: Member.Role) -> UIViewController {
    let ledgerDetailContentsService = LedgerDetailContentsService()
    let ledgerContentReactor = LedgerContentsReactor(
      ledgerContentsService: ledgerDetailContentsService,
      updateLedgerUseCase: DIContainer.shared.resolve(type: UpdateLedgerUseCaseInterface.self),
      uploadImageUseCase: DIContainer.shared.resolve(type: UploadImageUseCaseInterface.self),
      uploadReceiptUseCase: DIContainer.shared.resolve(type: UploadReceiptUseCaseInterface.self),
      uploadDocumentUseCase: DIContainer.shared.resolve(type: UploadDocumentUseCaseInterface.self),
      deleteReceiptUseCase: DIContainer.shared.resolve(type: DeleteReceiptUseCaseInterface.self),
      deleteDocumentUseCase: DIContainer.shared.resolve(type: DeleteDocumentUseCaseInterface.self),
      formatter: contentFormatter
    )
    let contentView = LedgerContentsView(reactor: ledgerContentReactor)
    let vc = LedgerDetailVC(contentsView: contentView)
    contentView.delegate = vc
    vc.reactor = LedgerDetailReactor(
      ledgerID: ledgetID,
      role: role,
      getLedgerDetailUseCase: DIContainer.shared.resolve(type: GetLedgerDetailUseCaseInterface.self),
      deleteLedgerUseCase: DIContainer.shared.resolve(type: DeleteLedgerUseCaseInterface.self),
      ledgerService: ledgerService,
      ledgerContentsService: ledgerDetailContentsService
    )
    return vc
  }
}
