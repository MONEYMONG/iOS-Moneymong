import UIKit

import RxDataSources
import FlexLayout

final class LedgerContensImageCollentionView: UICollectionView {

  private let layout = UICollectionViewFlowLayout()

  lazy var dataSources = RxCollectionViewSectionedReloadDataSource<LedgerImageSectionModel.Model>(
    configureCell: { [weak self] dataSource, collectionView, indexPath, item in
      switch item {
      case .creatAdd:
        return collectionView.dequeueCell(AddImageCell.self, for: indexPath)

      case .updateAdd:
        return collectionView.dequeueCell(AddImageCell.self, for: indexPath)

      case .readImage(let url):
        return collectionView.dequeueCell(DefaultImageCell.self, for: indexPath)
          .configure(with: url)

      case .updateImage:
        return collectionView.dequeueCell(DefaultImageCell.self, for: indexPath)
      }
    },
    configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
      let section = dataSource[indexPath.section]
      switch section.model {
      case .default(let title):
        let section = collectionView.dequeueHeader(DefaultSectionHeader.self, for: indexPath)
          .configure(title: title)
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
    register(AddImageCell.self)
    register(DefaultImageCell.self)
    registerHeader(DefaultSectionHeader.self)
  }

  private struct ViewSize {
    static var cell: CGSize {
      let width = UIScreen.main.bounds.width * 0.28
      let height = width * 1.33
      return CGSize(width: width, height: height)
    }
    static var cellSpacing: Double = cell.width * 0.095
    static var receiptHeaderHeight: CGFloat = 31
    static var documentHeaderHeight: CGFloat = 16
    static var collectionBaseHeight: CGFloat = receiptHeaderHeight + documentHeaderHeight + 24 + (ViewSize.cell.height + 8) * 2
  }

  func updateCollectionHeigh(images: [LedgerImageSectionModel.Model]) {
    let cellSize: CGSize = {
      let width = frame.width * 0.313
      let height = width * 1.33
      return CGSize(width: width, height: height)
    }()

    layout.itemSize = cellSize
    layout.minimumLineSpacing = 9
    layout.minimumInteritemSpacing = 9
    layout.sectionInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
    let imageCount = images[0].items.count
    let lineCount = ceil(Double(imageCount) / 3)
    flex.height(
      16 + 8 + ((lineCount - 1) * 9) + (cellSize.height * lineCount)
    ).markDirty()
    setNeedsLayout()
  }
}

extension LedgerContensImageCollentionView: UICollectionViewDelegateFlowLayout {
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
