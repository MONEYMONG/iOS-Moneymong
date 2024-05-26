import UIKit

import BaseFeature

protocol ImagePickerPresentable where Self: Coordinator {
  func imagePicker(
    animated: Bool,
    delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate
  )
}

extension ImagePickerPresentable {
  func imagePicker(
    animated: Bool,
    delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate
  ) {
    let picker: UIImagePickerController = {
      let v = UIImagePickerController()
      v.sourceType = .photoLibrary
      return v
    }()
    picker.delegate = delegate
    picker.modalPresentationStyle = .fullScreen
    navigationController.present(picker, animated: animated)
  }
}
