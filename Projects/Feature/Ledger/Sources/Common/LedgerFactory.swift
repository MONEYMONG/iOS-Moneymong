import UIKit

import AgencyInterface
import BaseDomain
import BaseFeature
import UserInterface
import LedgerInterface
import LedgerFeatureInterface

struct LedgerFactory {
  private let ledgerService: LedgerServiceInterface
  private let contentFormatter: ContentFormatter
  
  init(ledgerService: LedgerServiceInterface, contentFormatter: ContentFormatter) {
    self.ledgerService = ledgerService
    self.contentFormatter = contentFormatter
  }
  
  func makeLedgerMain(ledgerTab: UIViewController, memberTab: UIViewController) -> LedgerVC {
    let vc = LedgerVC([ledgerTab, memberTab])
    vc.reactor = LedgerReactor(
      getMyAgencyUseCase: DIContainer.shared.resolve(type: GetMyAgencyUseCaseInterface.self),
      getSelectedAgency: DIContainer.shared.resolve(type: GetSelectedAgencyUseCaseInterface.self),
      updateSelectedAgency: DIContainer.shared.resolve(type: UpdateSelectedAgencyUseCaseInterface.self),
      ledgerService: ledgerService
    )
    return vc
  }
  
  func makeLedgerTab() -> LedgerTabVC {
    let vc = LedgerTabVC()
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
  
  func makeMemberTab() -> MemberTabVC {
    let vc = MemberTabVC()
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
  
  func makeCreateManual(agencyId: Int, type: ManualPresentType) -> CreateManualLedgerVC {
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
  
  func makeDatePicker(start: DateInfo, end: DateInfo) -> DatePickerSheetVC {
    let vc = DatePickerSheetVC()
    vc.reactor = DatePickerReactor(
      startDate: start,
      endDate: end,
      ledgerService: ledgerService,
      formatter: contentFormatter
    )
    return vc
  }
  
  func makeEditMember(agencyID: Int, member: Member) -> EditMemberSheetVC {
    let vc = EditMemberSheetVC()
    vc.reactor = EditMemberReactor(
      agencyID: agencyID,
      member: member,
      changeMemberRoleUseCase: DIContainer.shared.resolve(type: ChangeMemberRoleUseCaseInterface.self),
      ledgerService: ledgerService
    )
    return vc
  }
  
  func makeSelectAgency() -> SelectAgencySheetVC {
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
  
  func makeDetail(ledgetID: Int, role: Member.Role) -> LedgerDetailVC {
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
