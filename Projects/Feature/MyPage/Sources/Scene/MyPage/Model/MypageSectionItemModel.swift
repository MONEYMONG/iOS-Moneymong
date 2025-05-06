import Foundation

import BaseDomain
import UserInterface

import RxDataSources

/// TableView Section, Row에 사용
struct MyPageSectionItemModel {
  typealias Model = SectionModel<Section, Item>
  
  enum Section: Equatable {
    case inquiry(UserInfo)
    case setting(String)
  }
  
  enum Item: Equatable {
    case kakaoInquiry
    case setting(SettingItem)
  }
  
  let model: Section
  let items: [Item]
}
