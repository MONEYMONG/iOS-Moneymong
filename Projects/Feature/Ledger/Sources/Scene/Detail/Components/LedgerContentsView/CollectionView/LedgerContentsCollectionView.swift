import UIKit

import RxDataSources
import FlexLayout

final class LedgerContentsCollectionView: UICollectionView {

  private let layout = UICollectionViewFlowLayout()

  weak var reactor: LedgerContentsReactor?

  lazy var dataSources = RxCollectionViewSectionedReloadDataSource<LedgerImageSectionModel.Model>(
    configureCell: { [weak self] dataSource, collectionView, indexPath, item in
      switch item {
      case .description(let description):
        let cell = collectionView.dequeueCell(DescriptionCell.self, for: indexPath)
        cell.configure(with: description)
        return cell

      case .imageAddButton:
        let cell = collectionView.dequeueCell(AddImageButtonCell.self, for: indexPath)
        return cell

      case .image(let imageInfo):
        let cell = collectionView.dequeueCell(DefaultImageCell.self, for: indexPath)
        cell.reactor = self?.reactor
        cell.bind()
        cell.configure(with: imageInfo)
        return cell
      }
    },
    configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
      let section = dataSource[indexPath.section]
      switch section.model {
      case .default(let title):
        let section = collectionView.dequeueHeader(DefaultSectionHeader.self, for: indexPath)
        section.configure(title: title)
        return section
      }
    }
  )

  init() {
    super.init(frame: .zero, collectionViewLayout: layout)
    setupUI()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupUI() {
    delegate = self
    isScrollEnabled = false
    register(DescriptionCell.self)
    register(AddImageButtonCell.self)
    register(DefaultImageCell.self)
    registerHeader(DefaultSectionHeader.self)
  }

  func updateCollectionHeigh(items: LedgerImageSectionModel.Model) {
    layout.minimumLineSpacing = 9
    layout.minimumInteritemSpacing = 9
    layout.sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 0, right: 16)

    /// item이 description일 경우 Height
    if case .description = items.items[0] {
      flex.height(16 + 8 + 20).markDirty()
      setNeedsLayout()
      return
    }

    let cellSize: CGSize = {
      let width = frame.width * 0.28
      let height = width * 1.33
      return CGSize(width: width, height: height)
    }()

    layout.itemSize = cellSize
    let imageCount = items.items.count
    let lineCount = ceil(Double(imageCount) / 3)
    flex.height(
      16 + 8 + ((lineCount - 1) * 9) + (cellSize.height * lineCount)
    ).markDirty()
    setNeedsLayout()
  }
}

extension LedgerContentsCollectionView: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    referenceSizeForHeaderInSection section: Int
  ) -> CGSize {
    return CGSize(
      width: collectionView.frame.width,
      height: 16
    )
  }
}
