import UIKit

import BaseDomain
import BaseFeature
import DesignSystem
import LedgerFeatureInterface

public final class CreateManualLedgerCoordinator: CreateManualLedgerCoordinatorInterface {
  public weak var navigationController: UINavigationController?
  public weak var parentCoordinator: Coordinator?
  
  private let contentFormatter: ContentFormatter
  
  enum Scene {
    case categorySheet(categories: [MMCategory])
  }

  public init(contentFormatter: ContentFormatter) {
    self.contentFormatter = contentFormatter
  }

  public func start(agencyId: Int, type: ManualPresentType, animated: Bool) {
    let vc = LedgerFactory(contentFormatter: contentFormatter).makeCreateManual(agencyId: agencyId, type: type)
    vc.coordinator = self
    navigationController?.pushViewController(vc, animated: animated)
  }
  
  func present(_ scene: Scene) {
    switch scene {
    case let .categorySheet(categories):
      categorySheet(categories: categories)
    }
  }
  
  func pop() {
    navigationController?.popViewController(animated: true)
  }
}

private extension CreateManualLedgerCoordinator {
  func categorySheet(categories: [MMCategory]) {
    let vc = LedgerFactory(
      ledgerService: ledgerService,
      contentFormatter: contentFormatter
    ).makeCategorySheet(categories: categories)
    vc.modalPresentationStyle = .overFullScreen
    navigationController?.present(vc, animated: false)
  }
}
