//
//  ReportCollectionView.swift
//  LedgerFeature
//
//  Created by 이시원 on 4/24/26.
//

import UIKit

import DesignSystem

final class ReportInfoCollectionView: UICollectionView {
  private var cellHeight: CGFloat?
  private var spacing: CGFloat?
  
  init(cellHeight: CGFloat, spacing: CGFloat) {
    self.cellHeight = cellHeight
    self.spacing = spacing
    let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
      let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                            heightDimension: .estimated(cellHeight))
      let item = NSCollectionLayoutItem(layoutSize: itemSize)
      let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                             heightDimension: .estimated(cellHeight))
      let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
      
      let section = NSCollectionLayoutSection(group: group)
      section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
      section.interGroupSpacing = spacing
      return section
    }
    super.init(frame: .zero, collectionViewLayout: layout)
    setupViews()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupViews()
  }
  
  private func setupViews() {
    isScrollEnabled = false
    backgroundColor = Colors.Gray._1
    layer.cornerRadius = 20
  }
  
  func getHeight(cellCount: Int) -> CGFloat {
    return (cellHeight ?? 0) * CGFloat(cellCount) + (spacing ?? 0) * (CGFloat(cellCount) - 1) + 40
  }
}
