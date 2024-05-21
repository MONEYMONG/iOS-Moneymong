import UIKit

final class LedgerContensImageCollentionView: UICollectionView {

  private let layout = UICollectionViewFlowLayout()

  init() {
    super.init(frame: .zero, collectionViewLayout: layout)
    setupUI()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    isScrollEnabled = false
    let cellWidth = frame.width * 0.28
    let cellHeight = cellWidth * 1.33
    layout.minimumLineSpacing = (frame.width * 0.28) * 0.095
    layout.minimumInteritemSpacing = (frame.width * 0.28) * 0.095
    layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
    layout.sectionInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
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
