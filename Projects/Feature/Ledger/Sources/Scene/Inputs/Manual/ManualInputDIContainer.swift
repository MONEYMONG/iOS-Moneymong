import UIKit

import BaseFeature

public final class ManualInputDIContainer {
  public init() {}
  
  func manualInput(with coordinator: ManualInputCoordinator) -> ManualInputVC {
    let vc = ManualInputVC()
    vc.reactor = ManualInputReactor()
    vc.coordinator = coordinator
    return vc
  }
  
  func imagePicker() -> UIImagePickerController {
    let picker = UIImagePickerController()
    picker.sourceType = .photoLibrary
    return picker
  }
}

