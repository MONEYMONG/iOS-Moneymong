//
//  ChipListView.swift
//  DesignSystem
//
//  Created by 이시원 on 10/30/25.
//

import UIKit

import FlexLayout

public final class ChipListView: UIView {
  private var chips: [CategoryChip] = []
  public var chipTapAction: ((CategoryChip) -> Void) = {_ in}
  private var selectedChipIndex: Int?
  
  override public func layoutSubviews() {
    super.layoutSubviews()
    updateButtonsLayout()
  }
  
  public func setupChips(with titles: [String]) {
    chips = titles.map {
      let chip = CategoryChip(title: $0)
      chip.sizeToFit()
      chip.addAction { [weak self] in
        self?.chipTapAction(chip)
        self?.flex.markDirty()
        self?.layoutIfNeeded()
      }
      addSubview(chip)
      return chip
    }
    flex.markDirty()
    layoutIfNeeded()
  }
  
  public func selectChip(_ title: String?) {
    if let selectedChipIndex {
      chips[selectedChipIndex].updateState(.unselected)
      self.selectedChipIndex = nil
    }
    
    if let title {
      guard let newChipIndex = chips.firstIndex(where: {
        $0.titleLabel?.text == title
      }) else { return }
      chips[newChipIndex].updateState(.selected)
      selectedChipIndex = newChipIndex
    }
  }
  
  private func updateButtonsLayout() {
    var lineCount: CGFloat = 1
    let marginX: CGFloat = 10
    let marginY: CGFloat = 8
    
    var positionX: CGFloat = 0
    var positionY: CGFloat = 0
    
    for (index, chip) in chips.enumerated() {
      chip.frame = CGRect(x: positionX, y: positionY, width: chip.frame.width, height: chip.frame.height)
      
      if index < chips.count - 1 {
        positionX += chip.frame.width + marginX
        if positionX + chips[index + 1].frame.width > frame.width {
          positionX = 0
          positionY += chip.frame.height + marginY
          lineCount += 1
        }
      }
    }
    
    let height = chips.first?.frame.height ?? 0
    let margins: CGFloat = (lineCount - 1) * marginY
    frame = CGRect(
      x: frame.origin.x,
      y: frame.origin.y,
      width: frame.width,
      height: (lineCount * height) + margins
    )
  }
}
