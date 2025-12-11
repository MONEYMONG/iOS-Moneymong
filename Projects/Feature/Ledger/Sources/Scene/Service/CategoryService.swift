import LedgerFeatureInterface

import RxSwift

final class CategoryService: CategoryServiceInterface {
  let event = PublishSubject<CategoryEvent>()
}
